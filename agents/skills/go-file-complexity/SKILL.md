---
name: go-file-complexity
description: Checks Go file complexity by counting exported and non-exported functions per file. Detects god files with too many functions or imbalanced public/private ratios. Use when writing or reviewing Go code.
---

# Go File Complexity

Detects god files by counting functions and methods per file. Catches files
that do too much (too many exported functions), hide too much complexity
(too many non-exported functions), or have a suspicious imbalance between the two.

## Rules

### Thresholds (per `.go` file, excluding `_test.go`)

| Metric | Limit | Rationale |
|--------|-------|-----------|
| Exported functions | **max 10** | File has too broad an API surface — split by responsibility |
| Non-exported functions | **max 20** | Too much hidden complexity — extract a sub-package |
| Non-exported to exported ratio | **max 6:1** | One exported function backed by 12 private ones means it's doing too much |
| Interface methods | **max 20** | Interface is too broad — split into smaller, focused interfaces |

The ratio check is **skipped** for files with zero exported functions (pure
internal helpers).

### What counts

Only **standalone functions** (no receiver) are counted:

- `func DoSomething()` — exported function ✓ counted
- `func doSomething()` — non-exported function ✓ counted

**Methods** (with receiver) are excluded — they are interface implementations
or type behavior, not package-level API surface:

- `func (s *Server) Start()` — exported method ✗ not counted
- `func (s *server) start()` — non-exported method ✗ not counted

**Interfaces** are checked for method count — the interface defines the contract,
so that's where the API surface is measured:

- `type Repository interface { ... }` — methods inside are counted

Generated files (`Code generated ... DO NOT EDIT`) are skipped.

## Verification

```bash
bash /path/to/go-file-complexity/scripts/check.sh [project-dir]
```

Exit codes: `0` = pass, `2` = violations found.

### Custom thresholds

```bash
bash /path/to/go-file-complexity/scripts/check.sh [project-dir] [max-exported] [max-unexported] [max-ratio] [max-interface-methods]
```

Defaults: `10 20 6 20`

## Fixing Violations

- **Too many exported functions**: the file is doing too many things. Split into
  multiple files by responsibility, or extract a sub-package.
- **Too many non-exported functions**: hidden complexity. Extract private helpers
  into an `internal/` sub-package where they become the public API of a smaller,
  focused package.
- **Ratio too high**: a thin public API hiding a mountain of implementation.
  The exported function is likely orchestrating too much — break it down.
- **Interface too large**: the interface has too many methods. Apply the
  Interface Segregation Principle — split into smaller, role-specific interfaces
  that consumers can implement and depend on independently.
