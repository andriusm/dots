---
name: go-project-structure
description: Enforces Go project directory layout, package naming conventions, cmd/ purity, and nesting depth limits. Use when creating, restructuring, or reviewing Go projects and packages.
---

# Go Project Structure

Deterministic guardrails for Go project structure. Enforces directory layout,
bans junk-drawer package names, keeps cmd/ thin, and limits package nesting.

## Rules

### 1. Directory Layout

Projects are classified as **service** or **library**:

- **Service**: `cmd/` directory exists, OR `package main` found outside `examples/`/`testdata/`
- **Library**: everything else

**Service rules:**
- `cmd/` must exist with subdirectories: `cmd/{name}/main.go`
- `internal/` must exist — all non-cmd code lives here
- No Go packages at the project root (except `cmd/`, `internal/`, `vendor/`, `testdata/`)
- No Go files directly in `cmd/` — must be in `cmd/{name}/`

**Library rules:**
- Exported packages at root are allowed
- `internal/` is optional

**Forbidden top-level directories** (service or library):
`pkg`, `models`, `helpers`, `controllers`

### 2. Banned Package Names

The following package names are forbidden **anywhere** in the project:

`util`, `utils`, `common`, `shared`, `helpers`, `misc`, `base`, `core`

These become junk drawers with no cohesion. Find a meaningful name that
describes what the package actually does.

### 3. Thin Composition Root (cmd/ purity)

Files in `cmd/*/` must contain only wiring code:

- **No type definitions** (struct, interface, type alias)
- **No method declarations** (func with receiver)

Functions like `main()` and `run()` are fine. Types and methods belong in `internal/`.

### 4. Package Depth Limit

Maximum **4 levels** of nesting under `internal/`:

- ✓ `internal/domain/order/service/` (4 levels — ok)
- ✗ `internal/domain/order/service/validation/rules/` (6 levels — too deep)

## Verification

Run the check script from the project root:

```bash
bash /path/to/go-project-structure/scripts/check.sh [project-dir]
```

The script uses ast-grep (`sg`) for cmd/ purity checks when available,
falls back to grep-based detection. Both are reliable for gofmt'd Go code.

Exit codes: `0` = pass, `2` = violations found.

### ast-grep rules (optional)

For CI or standalone use, ast-grep rules are in `rules/`:

```bash
sg scan --rule /path/to/rules/cmd-no-types.yml cmd/
sg scan --rule /path/to/rules/cmd-no-methods.yml cmd/
```

## Proactive Enforcement

When creating new files or packages:

- Always place new packages under `internal/` in services
- Never create packages with banned names — pick a name that describes the responsibility
- Keep `cmd/*/` to pure wiring: `main()`, `run()`, and calls into `internal/`
- Prefer flat package structures — if you need 5 levels deep, reconsider the design
