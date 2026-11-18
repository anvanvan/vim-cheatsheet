# Typing beside the pane

The pane stays open while the user goes on typing in the prompt. With vim mode on, the vim keys the pane lists edit the prompt text while the pane is visible.

## Sub-features

- `type-insert` puts typed text into the prompt while the pane is open.
- `type-normal` switches to NORMAL with Escape and runs a vim command on the prompt text.
- `type-pane-stays` keeps the pane on screen through both.

## How to get to it (user POV)

- Open the pane with `/vim-keys`, then type in the prompt as usual.

## Driving it with testenv tui

Preconditions:

- Vim mode on: drive the `hint-enable` steps of [vim-mode-hint](./vim-mode-hint.md) first, and `$V doctor` prints `editorMode: vim`.
- The pane is open: `$T tui vimkeys-verify send '/vim-keys' --wait 'Modus'`.

- **Type in INSERT.** Run `$T tui vimkeys-verify send --no-enter 'eins zwei drei'`, then `$V snap <dir>/01-typed`. The prompt reads `❯ eins zwei drei`, the status line shows `-- INSERT --`, and the pane is still open.
- **Switch to NORMAL.** Run `$T tui vimkeys-verify keys Escape`, then `$V snap <dir>/02-normal`. The status line drops the `-- INSERT --` badge; NORMAL mode shows no badge of its own.
- **Delete a word.** Run `$T tui vimkeys-verify send --no-enter '0dw'`, then `$V snap <dir>/03-dw`. The prompt reads `❯ zwei drei`, and the pane is still open with `Modus` on top.
- **Clear.** Run `$T tui vimkeys-verify keys C-u` so the next card starts from an empty prompt.

## Gotchas

- With vim mode off, Escape and `0dw` do nothing vim-like: `0dw` lands in the prompt as text. Check the precondition first.
- `send` without `--no-enter` submits the prompt as a chat message and starts a paid model turn. Use `--no-enter` for every step of this card.
