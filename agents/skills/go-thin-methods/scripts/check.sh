#!/usr/bin/env bash
# Go Thin Method Detector
# Usage: check.sh [project-dir]
# Exit codes: 0 = pass, 1 = setup error, 2 = thin methods found
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="$SCRIPT_DIR/../rules"
PROJECT_DIR="${1:-.}"

if ! command -v sg &>/dev/null; then
    echo "ERROR: ast-grep (sg) is required for thin method detection"
    echo "Install: brew install ast-grep"
    echo "    or: npm install -g @ast-grep/cli"
    exit 1
fi

echo "Checking for thin methods..."
echo ""

# Collect non-generated Go files
GO_FILES=$(find "$PROJECT_DIR" -name '*.go' \
    -not -name '*_test.go' \
    -not -name '*.gen.go' \
    -not -name '*.pb.go' \
    -not -name '*_generated.go' \
    -not -path '*/vendor/*' \
    -not -path '*/.git/*' \
    2>/dev/null)

# Further exclude files with generated header
FILTERED=""
for f in $GO_FILES; do
    if ! head -5 "$f" 2>/dev/null | grep -q 'Code generated.*DO NOT EDIT'; then
        FILTERED="$FILTERED $f"
    fi
done

if [ -z "$FILTERED" ]; then
    echo "No non-generated Go files found"
    exit 0
fi

FOUND=false

for rule in "$RULES_DIR"/*.yml; do
    output=$(echo "$FILTERED" | xargs sg scan --rule "$rule" 2>/dev/null) || true
    if [ -n "$output" ]; then
        echo "$output"
        echo ""
        FOUND=true
    fi
done

echo "════════════════════════════════"
if $FOUND; then
    echo "✗ Thin methods detected (see above)"
    exit 2
else
    echo "✓ No thin methods found"
    exit 0
fi
