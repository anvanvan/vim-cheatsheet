# Slash command menu

A user who types `/vim` in the prompt sees `/vim-keys` in the slash menu with the description `Vim-Mode-Cheatsheet in einem Panel anzeigen`, and can pick it from there.

## Sub-features

- `menu-entry` lists `/vim-keys` with its description while the prompt holds `/vim`.
- `menu-pick` runs the command when the user presses Enter on the highlighted entry.

## How to get to it (user POV)

- Type `/` and the start of the name in the prompt.

## Driving it with testenv tui

Preconditions:

- Fresh env, `$V doctor` prints `doctor: ok`.

- **Open the menu.** Type `/vim` without Enter. Run `$T tui vimkeys-verify send --no-enter '/vim'`, wait one second, then `$V snap <dir>/01-menu`. Below the screen a line `❯ /vim-keys   Vim-Mode-Cheatsheet in einem Panel anzeigen` shows, highlighted with `❯`.
- **Pick the entry.** Press Enter. Run `$T tui vimkeys-verify keys Enter`, then `$T tui vimkeys-verify read` until the reply shows, then `$V snap <dir>/02-picked`. The chat shows `❯ /vim-keys` and the reply `vim-cheatsheet: Vim-Cheatsheet geöffnet.`, and the pane opens on the right.

## Gotchas

- The env copies the checkout's project skills, so `/deploy` shows in the same menu. It is not part of the plugin.
- A plugin that failed to load shows no `/vim-keys` entry at all. Check `$V doctor` for `plugin:` before you call the entry missing.
