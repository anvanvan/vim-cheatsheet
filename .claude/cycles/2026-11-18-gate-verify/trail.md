---
status: closed
landing: a5bad99
---
# Trail: gate-verify

## Ziel

User 2026-11-18, asked whether the verifier should run for the three projects that got a verify skill today: "Alle drei einschalten (Recommended)". The option sets `verify = "advise"`.

## Route

- `[gate] verify = "advise"` in `.claude/cycle.toml`. The gate asks a verifier session for every land that changes code and attaches its verdict to the land. A FAIL does not hold the land.
- anvanvan.com and locknote already carry `verify = "block"` by the user's own order, so this cycle changes vim-cheatsheet only.

## Proofs

- `~/.claude/bin/get-toml.py .claude/cycle.toml gate verify` prints `advise` on the branch.
