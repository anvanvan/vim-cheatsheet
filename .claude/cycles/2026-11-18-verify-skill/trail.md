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
- Fresh agent r1 (Sonnet 5.5, sha 002dac2) on vim-mode-hint: 3/3 pass, 4 GAP lines (80-row output, ambiguous "second reply", unconfirmed filter). Fixed in 8bfb39e. Evidence `verify/smoke/vim-mode-hint/`.
- Fresh agent r2 (Sonnet 5.5, sha 8bfb39e) on vim-mode-hint: 3/3 pass, GAP: 0. Evidence `verify/smoke/vim-mode-hint-r2/`.
- /simplify: snap from one capture, --dry-run only on down, case dispatch; helper rechecked live (up, doctor, snap, down, usage errors exit 2).
- Fix 4da8469: snap text was ANSI- and OSC-laden (grep for handles missed); now plain.
- Fresh agent r3 (Sonnet 5.5, sha 4da8469) on vim-mode-hint: 3/3 pass, GAP: 0. Evidence `verify/smoke/vim-mode-hint-r3/`.
- Skipped from /simplify: Kit::CLI and Kit::Sh reuse (a one-file verify helper in a foreign repo stays free of the ~/.claude load path), testenv status --json for doctor (it reports isolation, not the tui or the source head), parallel subprocesses (milliseconds).
