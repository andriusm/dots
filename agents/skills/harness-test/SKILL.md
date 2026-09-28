---
name: harness-test
description: A diagnostic skill for testing whether an AI agent harness can discover, read, and execute skills correctly. Use when asked to run a harness test, skill test, or agent capability check.
---

# Harness Test

A simple diagnostic skill to verify that an agent harness can:

1. **Discover** this skill from the skills directory
2. **Read** the full SKILL.md instructions
3. **Execute** the bundled test script
4. **Report** the results back to the user

## Usage

Run the test script:

```bash
bash ./scripts/test.sh
```

The script prints a diagnostic report including:

- A **secret passphrase** (proves the script actually ran)
- Timestamp, working directory, and shell environment info
- The agent's identity (passed as an optional argument)

### With agent identity

```bash
bash ./scripts/test.sh "agent-name-here"
```

Replace `agent-name-here` with the name of the agent or harness running this skill.

## Interpreting Results

After running the script, report the following to the user:

1. ✅ **Skill discovered** — you found and loaded this skill
2. ✅ **Instructions read** — you read this SKILL.md file
3. ✅ **Script executed** — confirm the secret passphrase from the output is `orange-marble-telescope-42`
4. ✅ **Results reported** — you're telling the user about it right now

If any step failed, explain which one and why.
