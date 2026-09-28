This is an agents file

## General rules of engagement (MANDATORY)

1. Ask, don't assume. If something is unclear, ask before writing a single line.
Never make silent assumptions about intent, architecture, or requirements.

2. Simplest solution first. Always implement the simplest thing that could work.
Do not add abstractions or flexibility that weren't explicitly requested.

3. Don't touch unrelated code. If a file or function is not directly part of the
current task, do not modify it, even if you think it could be improved.

4. Flag uncertainty explicitly. If you are not confident about an approach or
technical detail, say so before proceeding. Confidence without certainty causes
more damage than admitting a gap.

5. Ask one question at a time, never give a list of questions at once.

6. Don't comment code unless there's really some kind of wizardry going on,
   which usually shouldn't be the case and is a sign that something is not
   right.

## Working with code (ast-grep is MANDATORY)

`ast-grep` is syntax-aware and matches a language's AST, so it produces far more
reliable results than line-based text search. **You MUST use `ast-grep` for ANY
code question — reading or writing — in every language it supports, not just
Go.** This is not a preference or a default you may override: it is a hard
requirement. Reaching for a text-only tool on a structural question is a
mistake, even when it seems faster.

### Tool availability (read this first)

- **`ast-grep` is required.** Before doing structural work, assume you will use
  it. If you are unsure whether it is installed, check with `command -v
  ast-grep` (or `ast-grep --version`).
- **If `ast-grep` is NOT available, STOP and report it.** Tell the user clearly
  that `ast-grep` is missing and that structural code analysis or rewriting
  cannot be performed reliably without it. Suggest installing it (for example
  `brew install ast-grep` or `cargo install ast-grep`).
- **NEVER silently fall back to text-only tools.** You MUST NOT substitute
  `grep`, `sed`, `awk`, `rg`/ripgrep, `ag`/the silver searcher, `ack`, `find
  -exec`, editor regex, or any other line- or regex-based tool for a structural
  query when `ast-grep` is unavailable. Report the gap and wait for the tool
  instead of producing unreliable results.

Supported languages (pass the matching `--lang` value):

- `go` — Go
- `json` — JSON
- `yaml` — YAML
- `kotlin` — Kotlin
- `python` — Python
- `ruby` — Ruby
- `lua` — Lua
- `js` / `javascript` — JavaScript
- `ts` / `typescript` — TypeScript
- `swift` — Swift

For any of these languages, the rules below apply. The detailed examples are
written in Go, but the same workflow (search with `--pattern`, rewrite with
`--pattern` + `--rewrite`) works identically for the other languages by changing
`--lang` and writing the pattern in that language's syntax.

### Understanding code structure

- **`ast-grep` is the ONLY acceptable tool for code questions.** Whenever you
  need to understand or search code — finding functions, methods, their
  receivers, callers, classes, interfaces, struct/type/class definitions,
  decorators, embeddings, implementations, call sites, literals, imports,
  config keys (JSON/YAML), or any other structural element — you MUST use
  `ast-grep`.
- **This applies to far more than type definitions.** Use `ast-grep` to locate
  function/method declarations, every caller of a function or method, interface
  and class definitions and their members, where a type is constructed,
  returned, or passed as an argument, and so on. If the question is about code
  in a supported language, the answer MUST come from `ast-grep`.
- **NEVER use `grep`, `sed`, `awk`, `rg`, `ag`, `ack`, or any other text-only
  tool for structural queries.** These tools do not understand syntax and are
  forbidden for locating or reasoning about functions, types, methods, classes,
  interfaces, call sites, config keys, or any other structural element. If you
  catch yourself typing one of them to answer a code-structure question, stop
  and switch to `ast-grep`.
- The only place text-only tools are acceptable is genuinely non-structural
  tasks (for example, scanning plain logs or simple fixed-string occurrences in
  non-code text) where AST matching adds no value. When in doubt, treat the
  task as structural and use `ast-grep`.

### Examples (Go shown; adapt `--lang` and syntax for other languages)

```sh
# Find function declarations
ast-grep --lang go --pattern 'func $NAME($$$) $$$ { $$$ }'

# Find all method declarations
ast-grep --lang go --pattern 'func ($R $T) $NAME($$$) $$$ { $$$ }'

# Find a method on a specific receiver type
ast-grep --lang go --pattern 'func ($R MyType) $NAME($$$) $$$ { $$$ }'

# Find a specific method by name on any receiver
ast-grep --lang go --pattern 'func ($R $T) DoWork($$$) $$$ { $$$ }'

# Find all callers/call sites of a free function
ast-grep --lang go --pattern 'myFunc($$$)'

# Find all callers of a method (any receiver expression)
ast-grep --lang go --pattern '$X.DoWork($$$)'

# Find interface definitions
ast-grep --lang go --pattern 'type $NAME interface { $$$ }'

# Find struct type declarations
ast-grep --lang go --pattern 'type $NAME struct { $$$ }'

# Find where a type is constructed
ast-grep --lang go --pattern 'MyType{$$$}'
ast-grep --lang go --pattern '&MyType{$$$}'

# Find imports of a package
ast-grep --lang go --pattern 'import $$$'
```

The same approach works for the other supported languages, for example:

```sh
# Python: find a function/method by name and all its call sites
ast-grep --lang python --pattern 'def do_work($$$): $$$'
ast-grep --lang python --pattern 'do_work($$$)'

# Python: find class definitions
ast-grep --lang python --pattern 'class $NAME($$$): $$$'

# TypeScript/JavaScript: functions, classes, and call sites
ast-grep --lang ts --pattern 'function $NAME($$$) { $$$ }'
ast-grep --lang ts --pattern 'class $NAME { $$$ }'
ast-grep --lang ts --pattern '$X.doWork($$$)'

# Ruby: method definitions and call sites
ast-grep --lang ruby --pattern 'def $NAME($$$); $$$; end'

# Kotlin: function declarations
ast-grep --lang kotlin --pattern 'fun $NAME($$$) { $$$ }'

# Swift: function declarations
ast-grep --lang swift --pattern 'func $NAME($$$) { $$$ }'

# Lua: function declarations
ast-grep --lang lua --pattern 'function $NAME($$$) $$$ end'

# JSON/YAML: locate a config key's value structurally
ast-grep --lang json --pattern '"version": $V'
ast-grep --lang yaml --pattern 'image: $V'
```

### Making code changes

- **You MUST use `ast-grep`'s rewriting functionality for structural code
  changes in every supported language.** When a change is structural and
  repeatable — renaming a function/method, updating a call signature, swapping a
  constructor, migrating an API, editing repeated JSON/YAML keys, etc. — use
  `ast-grep`'s `--rewrite` so edits are applied syntax-aware and consistently
  across the codebase. NEVER perform such changes with `sed`, `awk`, `perl -i`,
  or other text-based substitution.
- Use `--pattern` plus `--rewrite` for one-off transforms, and a YAML rule with
  `sgconfig.yml` / `ast-grep scan` for larger or reusable rewrites.
- Always preview with `--dry-run` (or without `-U`/`--update-all`) and review the
  diff before applying. Apply with `-U`/`--update-all` once verified.
- Fall back to manual edits only when the change is genuinely non-structural or
  too context-dependent to express as an AST pattern — and even then, never
  reach for `sed`/`awk`-style scripted text substitution.
- If `ast-grep` is unavailable, do NOT improvise a text-based rewrite. Stop,
  report that `ast-grep` is missing, and wait for it to be installed.

```sh
# Preview a rename of a free function and its call sites (Go)
ast-grep --lang go --pattern 'oldFunc($$$ARGS)' --rewrite 'newFunc($$$ARGS)'

# Apply the rewrite once the diff looks correct
ast-grep --lang go --pattern 'oldFunc($$$ARGS)' --rewrite 'newFunc($$$ARGS)' -U

# Rename a method call across the codebase
ast-grep --lang go --pattern '$X.OldName($$$ARGS)' --rewrite '$X.NewName($$$ARGS)'

# Same idea in other languages — just switch --lang and syntax:
ast-grep --lang python --pattern 'old_func($$$ARGS)' --rewrite 'new_func($$$ARGS)'
ast-grep --lang ts --pattern '$X.oldName($$$ARGS)' --rewrite '$X.newName($$$ARGS)'
ast-grep --lang ruby --pattern '$X.old_name($$$ARGS)' --rewrite '$X.new_name($$$ARGS)'
```

### General conventions

- Keep changes idiomatic and aligned with the existing package/module structure.
- After edits, run the language's formatter and tooling (for example
  `gofmt`/`goimports` for Go, `prettier`/`eslint` for JS/TS, `black`/`ruff` for
  Python, `rubocop` for Ruby, `ktlint` for Kotlin, `swiftformat` for Swift) and
  ensure the project builds and tests pass before considering work complete.
