---
status: closed
landing: cef9336
---
# Trail: verify-block

## Ziel

User 2026-11-19, asked "Soll das Verifier-Urteil Code-Landungen im Vim-Spickzettel aufhalten?": "Ja, auf block stellen (Recommended)".

## Route

- `[gate] verify = "block"` in `.claude/cycle.toml`. A land that changes code waits for the verifier's verdict, and a FAIL holds it.
- anvanvan.com, locknote and lazysvn carry the same value.

## Pivots

None.

## Proofs

- `~/.claude/bin/get-toml.py .claude/cycle.toml gate verify` prints `block` on the branch.
