---
name: improve
description: Reads the project knowledge base under memory/ (produced by the analyze-project skill) and proposes a prioritized set of improvements, ranked by benefit-to-effort ratio. Use when asked what to improve first, where to invest effort, how to get the most impact for the least work, or for a critical review of a project based on its memory notes.
---

# Improve

Read everything the `analyze-project` skill recorded under `memory/`, reason
about it critically, and recommend **what to improve first** — ordered so the
highest benefit for the least effort comes first.

## Goal

Turn the existing `memory/` notes into a short, actionable, prioritized list of
improvements. The output is advice, not code changes: the user decides what to
act on. Optimize for **impact per unit of effort**, not for exhaustiveness.

## Preconditions

This skill depends on the output of `analyze-project`.

1. Check that `memory/` exists and contains files. Run:

   ```bash
   ls -la memory/ 2>/dev/null && echo "---" && wc -l memory/*.md 2>/dev/null
   ```

2. **If `memory/` is missing or empty, STOP.** Do not analyze the code from
   scratch here. Tell the user to run the `analyze-project` skill first, then
   re-run `improve`.

## Workflow

1. **Read all of `memory/`.** Read every file completely — do not skim. These
   notes are the input; treat them as the source of truth for the project's
   current state.
2. **Verify against code only when it matters.** The memory notes may be stale
   or flag items as `(unverified)`. Before recommending anything based on a
   surprising or high-stakes claim, confirm it against the actual code using
   `ast-grep` (structural queries) or by reading the referenced files. Never
   base a recommendation on an assumption; if you cannot verify a claim, say so.
3. **Think critically, without nitpicking.** Look for problems that genuinely
   matter — see "What counts as worth improving" below. Deliberately ignore
   cosmetic and low-signal issues.
4. **Estimate benefit and effort** for each candidate improvement, then rank by
   benefit-to-effort ratio (see "Ranking").
5. **Present the prioritized list** in the output format below.

## What counts as worth improving (signal, not nitpicks)

Focus on issues that move the needle:

- **Correctness & safety risks** — fragile logic, missing error handling, race
  conditions, unsafe assumptions, data-loss or corruption paths.
- **Security exposure** — secrets handling, auth gaps, injection surfaces,
  unvalidated input at trust boundaries.
- **Architectural friction** — wrong dependency direction, leaky boundaries,
  god modules, coupling that makes routine changes expensive.
- **Recurring pain** — anything the notes flag as a repeated gotcha, footgun, or
  implicit assumption that keeps biting.
- **Missing safety nets** — absent tests around critical/complex logic, no
  validation on key invariants, weak observability where failures hide.
- **Onboarding & maintainability drag** — undocumented tribal knowledge,
  confusing structure, that slows every future change.

Explicitly **do not** raise: formatting/style preferences, naming bikeshedding,
micro-optimizations with no measured impact, speculative "might need it later"
abstractions, or churn that only reshuffles working code. If an item is minor,
leave it out rather than padding the list.

## Ranking

For each candidate, estimate:

- **Benefit** (High / Medium / Low): how much it reduces risk, unblocks work, or
  removes recurring pain — and how central the affected area is.
- **Effort** (Low / Medium / High): rough work to implement, including blast
  radius and coordination cost.

Order the list by **benefit ÷ effort**, so **high-benefit / low-effort wins
come first** ("quick wins"). Break ties toward lower risk and smaller blast
radius. Cap the list at the ~5–8 items that truly matter; a focused list beats a
long one.

## Output format

Report to the user (do not write files unless asked):

1. **One-line project read** — a sentence on the project's state from the notes.
2. **Prioritized improvements** — a table, best ratio first:

   | # | Improvement | Benefit | Effort | Why it pays off |
   |---|-------------|---------|--------|-----------------|

3. **Top recommendation** — the single thing to do first and why, with the
   concrete files/areas to touch (cite `path/to/file:Symbol` from the notes).
4. **Assumptions & gaps** — anything you could not verify, memory notes that
   looked stale, or areas the analysis doesn't cover well enough to judge.

Keep it concise and concrete. Every item must be actionable and tied to
something real in the notes or code — no generic best-practice filler.
