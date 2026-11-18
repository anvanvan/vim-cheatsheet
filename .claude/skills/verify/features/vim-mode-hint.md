# Vim-mode hint

When vim mode is off, `/vim-keys` still opens the pane and adds to its reply how to turn vim mode on. After the user turns vim mode on through `/config`, the reply carries no hint.

## Sub-features

- `hint-off` appends `Vim-Mode ist aus: /config → Editor mode → vim` to the reply while vim mode is off.
- `hint-enable` turns vim mode on through `/config`, the path the hint names, and the prompt shows `-- INSERT --`.
- `hint-on` answers `vim-cheatsheet: Vim-Cheatsheet geöffnet.` with nothing after it once vim mode is on.

## How to get to it (user POV)

- Type `/vim-keys` with vim mode off.
- Type `/config`, search `Editor`, set `Editor mode` to `vim`, close with Escape, and type `/vim-keys` again.

## Driving it with testenv tui

Preconditions:

- Fresh env, `$V doctor` prints `editorMode: normal (unset)`.

- **Hint while off.** Run `$T tui vimkeys-verify send '/vim-keys' --wait 'Vim-Mode ist aus'`, then `$V snap <dir>/01-hint`. The reply reads `vim-cheatsheet: Vim-Cheatsheet geöffnet. Vim-Mode ist aus: /config → Editor mode → vim`, wrapped over two lines, and the pane is open.
- **Open the settings.** Run `$T tui vimkeys-verify send '/config' --wait 'Search settings'`. The `Settings` tab shows with a search field.
- **Find the setting.** Run `$T tui vimkeys-verify send --no-enter 'Editor'`, wait one second, then `$T tui vimkeys-verify read | grep -E 'Editor|external editor'`. The list shrinks to the two rows `Editor mode   normal` and `Show last response in external editor`, and `❯` marks `Editor mode`.
- **Switch to vim.** Run `$T tui vimkeys-verify keys Down`, then `$T tui vimkeys-verify keys Enter`, then `$V snap <dir>/02-config-vim`. The row reads `Editor mode   ‹ vim ›`.
- **Close the settings.** Run `$T tui vimkeys-verify keys Escape`, wait one second, then `$V snap <dir>/03-insert`. The status line under the prompt starts with `-- INSERT --`.
- **Read back.** Run `$V doctor` and keep its output as `<dir>/04-doctor.txt`. It prints `editorMode: vim`.
- **No hint while on.** Run `$T tui vimkeys-verify send '/vim-keys' --wait 'geöffnet\.\s+│'`, then `$V snap <dir>/05-no-hint`. The newest reply, the last `⎿` line on screen, ends at `geöffnet.` and the pane's `│` column follows it on the same row. The older reply above it still carries the hint.

## Gotchas

- `Down` in `/config` moves focus from the search field into the list, and `Enter` then toggles the highlighted row. Typing more text after `Down` edits nothing.
- The setting lives in the env's own `settings.json`, not in the user's. It survives until `$V down`, so every later card in the same env starts with vim mode on.
- `--wait 'geöffnet'` alone matches the first reply still on screen and returns at once. Wait for the pattern of the step.
