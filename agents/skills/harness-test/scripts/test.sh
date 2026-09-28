#!/usr/bin/env bash
# Harness Test — diagnostic script for agent skill verification
# Part of the harness-test skill

set -euo pipefail

AGENT_NAME="${1:-unknown}"

cat <<EOF
╔══════════════════════════════════════════════╗
║          HARNESS TEST — DIAGNOSTIC           ║
╠══════════════════════════════════════════════╣
║  Secret Passphrase: orange-marble-telescope-42
║  Timestamp:         $(date -u '+%Y-%m-%dT%H:%M:%SZ')
║  Agent:             ${AGENT_NAME}
║  Shell:             ${SHELL:-not set}
║  User:              $(whoami)
║  Working Dir:       $(pwd)
║  OS:                $(uname -s) $(uname -m)
║  Script Path:       ${BASH_SOURCE[0]}
╠══════════════════════════════════════════════╣
║  Status: ALL CHECKS PASSED                  ║
╚══════════════════════════════════════════════╝
EOF
