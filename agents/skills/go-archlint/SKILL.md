---
name: go-archlint
description: Runs archlint to enforce domain dependency direction in Go projects. Ensures domain packages never import infrastructure, transport, or cross-cutting packages. Use when modifying Go package imports or structure.
---

# Go Archlint

Runs [archlint](https://github.com/vinted/archlint) to enforce that **domain**
packages have no outward dependencies on infrastructure, transport, or
cross-cutting packages.

## What archlint checks

Packages are classified by naming convention:

| Category | Matched when path segment … |
|----------|----------------------------|
| **domain** | contains `domain` |
| **transport** | equals `server`, `api`, `http`, or `grpc` |
| **infra** | contains `infra`, `persistence`, `repo`, `adapter`, `eventpublisher`, … |
| **crosscut** | contains `config`, `log`, `metrics`, `middleware`, `cache`, `util`, … |
| **cmd** | equals `root` or starts with `cmd` |

**Violation**: a `domain` package imports an `infra`, `transport`, or `crosscut`
package. Domain must depend only on other domain packages (and stdlib/external).

## Verification

```bash
bash /path/to/go-archlint/scripts/check.sh [project-dir]
```

Exit codes: `0` = pass, `1` = archlint not available, `2` = violations found.

### Generate dependency graph

When archlint is installed:

```bash
archlint graph -f svg -o deps.svg .
```

This produces an SVG with color-coded packages and red edges for violations.

## Installation

The check script handles installation automatically:

- If `mise.toml` exists in the project → adds archlint to `[tools]`
- Otherwise → installs via `go install`

Manual installation:

```bash
# Via mise (preferred)
mise use go:github.com/vinted/archlint@latest

# Via go install
go install github.com/vinted/archlint@latest
```

## Fixing Violations

When domain imports a non-domain package:

1. **Define an interface in domain** that describes what domain needs
2. **Implement it in the infra/adapter package**
3. **Inject the implementation** via the composition root (`cmd/`)

Domain should express its needs through interfaces, not reach out to
infrastructure directly.
