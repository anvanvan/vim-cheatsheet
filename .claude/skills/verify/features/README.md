# vim-cheatsheet verification map

This directory is the maintained source for verifying the user-facing behaviour of the vim-cheatsheet plugin. Read the index, then drive the matching card with the steps of `../SKILL.md`.

## Baseline preconditions

- `$V up` ran from the checkout under test, and `$V doctor` prints `doctor: ok`.
- The env is fresh: `editorMode: normal (unset)` in `$V doctor`, one `/vim-keys` reply at most on screen. A card that needs another state says so under `Preconditions:`.
- `$V` is `<root>/.claude/skills/verify/scripts/vimkeys-verify.rb`, `$T` is `~/.claude/bin/testenv.rb`.

## Driving conventions

- Start each card from a fresh env: `$V down`, then `$V up`. A card that turns vim mode on leaves it on.
- Type commands with `$T tui vimkeys-verify send`, never by editing `settings.json` or calling the hook module.
- Clear the prompt with `$T tui vimkeys-verify keys C-u` before typing new text into it.
- Snap before and after each action with `$V snap <dir>/<NN>-<step>`.

## Proof and skip reporting

- A screen capture shows the action (the typed command or the prompt text) and its result.
- A vim-mode change carries the `$V doctor` line `editorMode:` as its read-back.
- Report an unreachable step with the keys pressed and the screen you got. Never report it as verified through another path.

## Feature entry contract

Each card starts with an H1 title and one paragraph of user-visible behaviour, then exactly four H2 sections in this order: `Sub-features`, `How to get to it (user POV)`, `Driving it with testenv tui`, `Gotchas`. The drive section starts with `Preconditions:` and pairs each user action with its exact command and the observable result.

## Features

- [Slash command menu](./command-menu.md) covers finding `/vim-keys` in the slash menu with its description.
- [Open the pane](./open-pane.md) covers the reply line, the side pane with every section, and running the command twice.
- [Vim-mode hint](./vim-mode-hint.md) covers the hint when vim mode is off, turning vim on through `/config`, and the reply without the hint.
- [Typing beside the pane](./type-beside-pane.md) covers typing and vim-mode editing in the prompt while the pane stays open.
