---
name: go-thin-methods
description: Detects thin pass-through methods in Go that add a stack frame but no real value. Uses ast-grep to match structural delegation patterns. Use when reviewing Go code for unnecessary indirection.
---

# Go Thin Methods

Detects methods that are pure delegation — they call exactly one other method
and return the result, possibly wrapping an error. These add a stack frame,
clutter the codebase, and provide no value beyond satisfying a layering idiom.

Requires **ast-grep** (`sg`) for AST-based pattern matching.

## Detected Patterns

### 1. Pure pass-through

A method whose entire body delegates to another method:

```go
func (s *Service) GetUser(ctx context.Context, id int64) (*User, error) {
    return s.repo.GetUser(ctx, id)
}
```

### 2. Single-call with error wrapping

A method that makes one call, checks the error, and returns:

```go
func (s *Service) GetUser(ctx context.Context, id int64) (*User, error) {
    user, err := s.repo.GetUser(ctx, id)
    if err != nil {
        return nil, fmt.Errorf("getting user: %w", err)
    }
    return user, nil
}
```

Both patterns indicate the method exists only for layering, not for doing
real work. The caller could invoke the target directly.

## Verification

```bash
bash /path/to/go-thin-methods/scripts/check.sh [project-dir]
```

Requires `sg` (ast-grep) on PATH. Exit codes: `0` = pass, `1` = setup error,
`2` = thin methods found.

### Install ast-grep

```bash
brew install ast-grep    # macOS
npm install -g @ast-grep/cli  # or via npm
```

## Adding More Patterns

Additional delegation patterns can be added as YAML rule files in `rules/`.
Each rule uses ast-grep's pattern matching against the Go AST. See existing
rules for the format.

## Fixing Violations

- **Remove the method** and have callers invoke the target directly
- **Add real logic** — validation, transformation, caching, logging — to justify the method's existence
- If the method exists to satisfy an interface, question whether the interface
  itself is necessary at that layer
