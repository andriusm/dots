#!/usr/bin/env bash
# Go Project Structure Checker
# Usage: check.sh [project-dir]
# Exit codes: 0 = pass, 2 = violations found
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="$SCRIPT_DIR/../rules"
PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

V=0
violation() { echo "  ✗ $1"; ((V++)) || true; }
ok()        { echo "  ✓ $1"; }
section()   { echo ""; echo "── $1 ──"; }

# ═══════════════════════════════════════
# Project type detection
# ═══════════════════════════════════════
section "Project type detection"

IS_SERVICE=false

if [ -d "cmd" ]; then
    IS_SERVICE=true
    echo "  Detected: SERVICE (cmd/ directory exists)"
else
    MAIN_FILES=$(find . -name '*.go' \
        -not -path './vendor/*' \
        -not -path './examples/*' \
        -not -path './_examples/*' \
        -not -path './testdata/*' \
        -not -path './.git/*' \
        -exec grep -l '^package main$' {} + 2>/dev/null || true)

    if [ -n "$MAIN_FILES" ]; then
        IS_SERVICE=true
        echo "  Detected: SERVICE (package main found outside examples/testdata)"
        while IFS= read -r f; do
            [ -n "$f" ] && violation "$f: package main should be in cmd/{name}/main.go"
        done <<< "$MAIN_FILES"
    else
        echo "  Detected: LIBRARY"
    fi
fi

# ═══════════════════════════════════════
# Required directories (services only)
# ═══════════════════════════════════════
if $IS_SERVICE; then
    section "Required directories"

    if [ -d "cmd" ]; then
        ok "cmd/ exists"

        # No Go files directly in cmd/
        DIRECT=$(find cmd -maxdepth 1 -name '*.go' 2>/dev/null || true)
        if [ -n "$DIRECT" ]; then
            violation "Go files directly in cmd/ — use cmd/{name}/main.go"
        fi

        # Each subdirectory must have main.go
        HAS_SUBDIRS=false
        for d in cmd/*/; do
            [ -d "$d" ] || continue
            HAS_SUBDIRS=true
            if [ -f "${d}main.go" ]; then
                ok "${d}main.go exists"
            else
                violation "${d} missing main.go"
            fi
        done

        if ! $HAS_SUBDIRS; then
            violation "cmd/ has no subdirectories — use cmd/{name}/main.go"
        fi
    else
        violation "cmd/ missing — services must use cmd/{name}/main.go"
    fi

    if [ -d "internal" ]; then
        ok "internal/ exists"
    else
        violation "internal/ missing — service code must live under internal/"
    fi

    # No Go packages at root (besides allowed dirs)
    for dir in */; do
        dir="${dir%/}"
        case "$dir" in
            cmd|internal|vendor|testdata|examples|_*) continue ;;
        esac
        if [ -d "$dir" ] && find "$dir" -maxdepth 1 -name '*.go' -not -name '*_test.go' -print -quit 2>/dev/null | grep -q .; then
            violation "Go package at project root: $dir/ — move to internal/"
        fi
    done
fi

# ═══════════════════════════════════════
# Forbidden top-level directories
# ═══════════════════════════════════════
section "Forbidden directories"

PRE=$V
for name in pkg models helpers controllers; do
    if [ -d "$name" ]; then
        violation "forbidden top-level directory: $name/"
    fi
done
[ $V -eq $PRE ] && ok "no forbidden top-level directories"

# ═══════════════════════════════════════
# Banned package names (anywhere)
# ═══════════════════════════════════════
section "Banned package names"

PRE=$V
for name in util utils common shared helpers misc base core; do
    while IFS= read -r -d '' dir; do
        violation "banned package name: $dir"
    done < <(find . -type d -name "$name" \
        -not -path './vendor/*' \
        -not -path './.git/*' \
        -print0 2>/dev/null)
done
[ $V -eq $PRE ] && ok "no banned package names"

# ═══════════════════════════════════════
# cmd/ purity — no types, no methods
# ═══════════════════════════════════════
if [ -d "cmd" ]; then
    section "cmd/ purity (no types, no methods)"

    PRE=$V

    if command -v sg &>/dev/null; then
        # ast-grep: accurate AST-based detection
        while IFS= read -r line; do
            [ -n "$line" ] && violation "$line"
        done < <(sg scan --rule "$RULES_DIR/cmd-no-types.yml" cmd/ 2>/dev/null || true)

        while IFS= read -r line; do
            [ -n "$line" ] && violation "$line"
        done < <(sg scan --rule "$RULES_DIR/cmd-no-methods.yml" cmd/ 2>/dev/null || true)
    else
        # Fallback: grep (reliable for gofmt'd Go code)
        while IFS= read -r line; do
            [ -n "$line" ] && violation "type declaration in cmd/: $line"
        done < <(grep -rn '^type ' cmd/ --include='*.go' --exclude='*_test.go' 2>/dev/null || true)

        while IFS= read -r line; do
            [ -n "$line" ] && violation "method declaration in cmd/: $line"
        done < <(grep -rn '^func (' cmd/ --include='*.go' --exclude='*_test.go' 2>/dev/null || true)
    fi

    [ $V -eq $PRE ] && ok "cmd/ contains only wiring code"
fi

# ═══════════════════════════════════════
# Package depth limit (max 4 from internal/)
# ═══════════════════════════════════════
if [ -d "internal" ]; then
    section "Package depth (max 4 levels under internal/)"

    PRE=$V
    while IFS= read -r -d '' dir; do
        if find "$dir" -maxdepth 1 -name '*.go' -print -quit 2>/dev/null | grep -q .; then
            violation "too deep: $dir"
        fi
    done < <(find internal -mindepth 5 -type d -print0 2>/dev/null)

    [ $V -eq $PRE ] && ok "all packages within depth limit"
fi

# ═══════════════════════════════════════
# Summary
# ═══════════════════════════════════════
echo ""
echo "════════════════════════════════"
if [ $V -eq 0 ]; then
    echo "✓ No structure violations found"
    exit 0
else
    echo "✗ $V structure violation(s) found"
    exit 2
fi
