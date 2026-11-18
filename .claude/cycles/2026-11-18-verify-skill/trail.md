---
status: open
---
# Trail: verify-skill

## Ziel
> Verify-Skills vervollständigen. Fehlt: anvanvan.com, lazysvn, locknote, vim-cheatsheet.

Relayed by session #758 on 2026-11-18 ("go 1,2,3,4,5"). This cycle covers vim-cheatsheet: a verify skill that starts a throwaway Claude Code TUI with the plugin from the checkout and drives `/vim-keys` like a user, with feature cards, proven by a fresh agent.

## Route
- /create-verification-skill.
- Surface: Claude Code TUI in an isolated `testenv` (own config dir, own tmux server `cc-testenv-<name>`), plugin loaded with `claude --plugin-dir <env root>`. No live session touched.
- Helper `.claude/skills/verify/scripts/vimkeys-verify.rb` (up, doctor, snap, down). Drive keys through `testenv tui`.
- Cards: command-menu, open-pane, vim-mode-hint, type-beside-pane.

## Proofs
- Author run: all four cards driven live, snaps under `verify/author/` (local only).
