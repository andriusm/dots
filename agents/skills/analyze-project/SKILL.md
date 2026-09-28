---
name: analyze-project
description: Thoroughly analyzes the codebase in the current directory and records dense architectural, structural, and logical findings as themed files under memory/. Use when asked to analyze a project, build a project memory/knowledge base, onboard onto an unfamiliar codebase, or document how a project works for later agent use.
---

# Analyze Project

Deeply analyze the code in the current directory and persist the important
findings as a set of themed reference files under `memory/`. These files are
written for a future agent (or yourself in a later session): they must be
**succinct but detailed enough** to convey the core ideas and concepts of the
project without re-reading the whole codebase.

## Goal

Produce a `memory/` directory containing dense, well-organized notes that let an
agent understand the project's architecture, structure, and important logic
quickly and act on it confidently.

## Analysis Workflow

Work from the outside in. Prefer structural understanding over line-by-line
reading.

1. **Survey the project.** Identify the language(s), build system, entry points,
   dependency manifests, and top-level directory layout. Read READMEs, docs,
   config, and manifests first — they encode intent cheaply.
2. **Map the structure.** Determine modules/packages/services, their
   responsibilities, and how they depend on each other. Note the layering
   (e.g. transport → domain → infrastructure) and dependency direction.
3. **Trace the important logic.** For each core capability, follow the main
   flows: entry point → orchestration → domain logic → side effects (DB, network,
   filesystem). Capture the non-obvious rules, invariants, and edge cases.
4. **Note cross-cutting concerns.** Configuration, error handling, logging,
   auth, concurrency, transactions, caching, feature flags, testing strategy,
   and build/deploy.
5. **Record surprises.** Anything counterintuitive, fragile, implicit, or
   easily misunderstood — this is the highest-value information to preserve.

Use structural code search (`ast-grep`) for locating functions, types, methods,
call sites, interfaces, and config keys in supported languages, as required by
the project's engineering rules. Fall back to reading files for prose, and
never guess — if a detail is uncertain, mark it as such rather than asserting it.

## Output: the memory/ directory

Write findings into `memory/`, **grouped by theme**, one file per theme. Create
several files — do not dump everything into one. Choose theme names that fit the
project. Typical themes (create only those that apply, add others as needed):

- `memory/overview.md` — what the project is, its purpose, the big picture.
- `memory/architecture.md` — components, boundaries, layering, dependency
  direction, key design decisions and their rationale.
- `memory/structure.md` — directory/module layout and what lives where.
- `memory/data-model.md` — core entities, schemas, persistence, migrations.
- `memory/<domain-area>.md` — important business/domain logic, rules, invariants
  (split per bounded context or feature when large).
- `memory/flows.md` — key end-to-end request/processing flows.
- `memory/integrations.md` — external services, APIs, protocols.
- `memory/config.md` — configuration, environment, secrets, feature flags.
- `memory/build-and-run.md` — build, run, test, and deploy commands.
- `memory/gotchas.md` — surprises, fragile spots, implicit assumptions, TODO/tech-debt.

## Writing Rules (density matters)

- **Be dense.** Every sentence should carry information. Prefer bullet lists,
  short tables, and file/symbol references (`path/to/file.go:FuncName`) over prose.
- **No repetition.** State each fact once, in the most relevant file. Cross-link
  with a relative path (`see [architecture](architecture.md)`) instead of
  duplicating.
- **Anchor to code.** Reference concrete files, packages, types, and functions so
  a future reader can jump straight to the source.
- **Capture the "why", not just the "what."** Record rationale and constraints
  behind non-obvious decisions.
- **Stay accurate.** Only record what you verified. Flag uncertain items
  explicitly (e.g. `(unverified)`), don't fabricate.
- **Keep it current-state.** Describe how the project works now, not a change log.

## Appending to an existing memory/

If `memory/` already exists with files:

- **Never delete or wipe existing files.** Preserve prior findings.
- **Merge, don't duplicate.** If a new finding fits an existing themed file,
  integrate it there. Update stale statements in place rather than adding a
  contradictory duplicate; when correcting, replace the outdated text.
- **Add new theme files** only when a finding doesn't fit any existing theme.
- **Keep density intact.** After appending, ensure the file still reads as one
  coherent, non-repetitive reference.

## Completion

Before finishing:

1. Ensure `memory/` contains multiple themed files that together cover
   architecture, structure, and important logic.
2. Re-read each file you wrote/edited to confirm it is dense, accurate,
   non-repetitive, and useful on its own.
3. Report to the user a short summary: which files exist in `memory/`, and what
   each covers.
