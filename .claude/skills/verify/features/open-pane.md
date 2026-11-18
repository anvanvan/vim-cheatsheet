# Open the pane

`/vim-keys` answers with one reply line and opens a side pane right of the chat. The pane lists the vim-mode keys of Claude Code in six sections and ends with the line that names how to turn vim mode on.

## Sub-features

- `pane-reply` prints `vim-cheatsheet: Vim-Cheatsheet geöffnet.` under the command.
- `pane-open` draws a pane right of a `│` column with a `✕` in its top-right corner.
- `pane-sections` shows `Modus`, `Navigation`, `Bearbeiten`, `Textobjekte (mit d c y)`, `VISUAL` and `Nicht unterstützt`, each with key rows.
- `pane-footer` ends with `Aktivieren: /config → Editor mode → vim`.
- `pane-version-marks` marks `Ctrl+[`, `d0` and `%` with `ab v2.1.242`, `ab v2.1.281` and `ab v2.1.301`.
- `pane-twice` runs the command again and still shows one pane.

## How to get to it (user POV)

- Type `/vim-keys` and press Enter.
- Pick `/vim-keys` from the slash menu (see [command-menu](./command-menu.md)).

## Driving it with testenv tui

Preconditions:

- Fresh env, `$V doctor` prints `doctor: ok`.

- **Before.** Run `$V snap <dir>/01-before`. No `│` column runs down the screen.
- **Run the command.** Run `$T tui vimkeys-verify send '/vim-keys' --wait 'Cheatsheet geöffnet'`, then `$V snap <dir>/02-open`. The chat shows the reply line, and the pane shows all six section titles, the three version marks and the footer line.
- **Run it again.** Run `$T tui vimkeys-verify send '/vim-keys' --wait 'Cheatsheet geöffnet(.|\n)*Cheatsheet geöffnet'`, then `$V snap <dir>/03-twice`. The chat holds two reply lines, and the screen still has one `│` column and one `Modus` title.

## Gotchas

- The pane needs the 160x80 size `$V up` sets. At the testenv default of 48 rows the pane cuts off after `VISUAL`, and `Nicht unterstützt` and the footer never show.
- The pane title `Vim-Mode Keys` does not render in the TUI. Do not wait for it.
- Long descriptions wrap inside the pane, so a row such as `INSERT: vor Cursor / Zeilenanfang / nach Cursor / Zeilenende` spans two lines. Match on the key column or a short fragment.
- `Escape` does not close the pane. Only the `✕`, which needs a mouse click, closes it, and this harness sends no mouse events.
- With vim mode off the reply line goes on with the hint of [vim-mode-hint](./vim-mode-hint.md). Match the reply up to `geöffnet.`.
