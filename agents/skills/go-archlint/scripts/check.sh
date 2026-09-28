#!/usr/bin/env bash
# Archlint Runner
# Usage: check.sh [project-dir]
# Exit codes: 0 = pass, 1 = setup error, 2 = violations found
set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

# ═══════════════════════════════════════
# Ensure archlint is installed
# ═══════════════════════════════════════
if ! command -v archlint &>/dev/null; then
    echo "archlint not found, installing..."

    if [ -f "mise.toml" ]; then
        echo "  mise.toml found — adding archlint to managed tools"

        if grep -q 'github.com/vinted/archlint' mise.toml 2>/dev/null; then
            echo "  archlint already in mise.toml, running mise install..."
        else
            # Add to [tools] section, creating it if needed
            if grep -q '^\[tools\]' mise.toml 2>/dev/null; then
                sed -i.bak '/^\[tools\]/a\
"go:github.com/vinted/archlint" = "latest"
' mise.toml && rm -f mise.toml.bak
            else
                printf '\n[tools]\n"go:github.com/vinted/archlint" = "latest"\n' >> mise.toml
            fi
            echo "  Added archlint to mise.toml [tools]"
        fi

        mise install 2>&1 || {
            echo "ERROR: mise install failed"
            exit 1
        }

        # mise shims may not be on PATH — try to locate
        if ! command -v archlint &>/dev/null; then
            eval "$(mise activate bash 2>/dev/null)" || true
        fi
    else
        echo "  No mise.toml — installing via go install"
        go install github.com/vinted/archlint@latest 2>&1 || {
            echo "ERROR: go install failed. Try: GOPROXY=direct GONOSUMDB='*' go install github.com/vinted/archlint@latest"
            exit 1
        }
    fi

    if ! command -v archlint &>/dev/null; then
        echo "ERROR: archlint installed but not on PATH"
        echo "  Add \$(go env GOPATH)/bin to your PATH, or run: mise activate"
        exit 1
    fi

    echo "  ✓ archlint installed"
    echo ""
fi

# ═══════════════════════════════════════
# Run archlint check
# ═══════════════════════════════════════
echo "Running: archlint check ."
echo ""
archlint check .
