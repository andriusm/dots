#!/usr/bin/env bash
# Go File Complexity Checker
# Usage: check.sh [project-dir] [max-exported] [max-unexported] [max-ratio] [max-interface-methods]
# Exit codes: 0 = pass, 2 = violations found
set -euo pipefail

PROJECT_DIR="${1:-.}"
MAX_EXPORTED="${2:-10}"
MAX_UNEXPORTED="${3:-20}"
MAX_RATIO="${4:-6}"
MAX_IFACE="${5:-20}"

V=0
violation() { echo "  ✗ $1"; ((V++)) || true; }

echo "Checking file complexity (exported≤$MAX_EXPORTED, non-exported≤$MAX_UNEXPORTED, ratio≤$MAX_RATIO:1, interface≤$MAX_IFACE)"
echo ""

CHECKED=0

while IFS= read -r -d '' file; do
    # Skip generated files
    if head -5 "$file" 2>/dev/null | grep -q 'Code generated.*DO NOT EDIT'; then
        continue
    fi

    ((CHECKED++)) || true

    # Count exported standalone functions (no receiver — package-level API)
    exported=$(grep -cE '^func [A-Z]' "$file" 2>/dev/null) || true
    exported=${exported:-0}

    # Count non-exported standalone functions (no receiver)
    unexported=$(grep -cE '^func [a-z_]' "$file" 2>/dev/null) || true
    unexported=${unexported:-0}

    # Methods (with receiver) are excluded — they're interface implementations
    # or type behavior, not package-level API surface

    # Check interface sizes — interfaces define the API contract
    iface_out=$(awk -v max="$MAX_IFACE" '
        /^type [[:alpha:]][[:alnum:]_]* interface \{/ {
            if ($0 ~ /\}/) next
            name = $2; count = 0; start = NR; inside = 1; next
        }
        inside && /^\}/ {
            if (count > max) printf "%d: interface %s has %d methods (max %d)\n", start, name, count, max
            inside = 0; next
        }
        inside && /^[[:space:]]+[A-Z][[:alnum:]_]*\(/ { count++ }
    ' "$file" 2>/dev/null) || true

    if [ -n "$iface_out" ]; then
        while IFS= read -r line; do
            [ -n "$line" ] && violation "$file:$line"
        done <<< "$iface_out"
    fi

    total=$((exported + unexported))
    [ "$total" -eq 0 ] && continue

    if [ "$exported" -gt "$MAX_EXPORTED" ]; then
        violation "$file: $exported exported functions/methods (max $MAX_EXPORTED)"
    fi

    if [ "$unexported" -gt "$MAX_UNEXPORTED" ]; then
        violation "$file: $unexported non-exported functions/methods (max $MAX_UNEXPORTED)"
    fi

    if [ "$exported" -gt 0 ]; then
        ratio=$((unexported / exported))
        if [ "$ratio" -gt "$MAX_RATIO" ]; then
            violation "$file: non-exported/exported ratio ${unexported}:${exported} exceeds ${MAX_RATIO}:1"
        fi
    fi
done < <(find "$PROJECT_DIR" -name '*.go' \
    -not -name '*_test.go' \
    -not -path '*/vendor/*' \
    -not -path '*/.git/*' \
    -print0 2>/dev/null | sort -z)

echo ""
echo "════════════════════════════════"
echo "Checked $CHECKED files"
if [ $V -eq 0 ]; then
    echo "✓ No complexity violations found"
    exit 0
else
    echo "✗ $V complexity violation(s) found"
    exit 2
fi
