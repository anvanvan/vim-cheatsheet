---
name: verify
description: Starts a throwaway Claude Code TUI with the vim-cheatsheet plugin loaded from this checkout and drives /vim-keys, its side pane and the vim-mode prompt by keys like a user, with screen captures as proof. Use to verify a vim-cheatsheet change live, run or drive the plugin, '/verify'.
---

# Verify vim-cheatsheet

This skill proves that a vim-cheatsheet feature works on the real surface: a Claude Code TUI that loads the plugin from the checkout you stand in. The TUI runs in an isolated testenv on its own tmux server, you type and press keys as a user does, and you keep screen captures of each action and its result. The recipes live in `features/`, indexed by [`features/README.md`](features/README.md).

A change that adds or changes a user-facing feature updates its card in `features/` in the same change.

The helper is `<root>/.claude/skills/verify/scripts/vimkeys-verify.rb`, called `$V` below. `<root>` is `git rev-parse --show-toplevel`; in a cycle worktree that is the worktree. `$V --help` lists every verb. The drive itself goes through `testenv`, called `$T` below (`T=~/.claude/bin/testenv.rb`). Every verb takes `--name <env>`; the default env is `vimkeys-verify`, and `$T` needs that name spelled out.

## Step 1. Launch

1. **Read the machine.** Run `~/.claude/bin/machine-light.rb` and follow its `next:` line. One TUI counts as a small job.
2. **Start the env.** Run `$V up` from `<root>`. It builds the testenv `/private/tmp/cc-testenv/vimkeys-verify` as a copy of the checkout, uncommitted edits included, starts `claude --plugin-dir` on that copy, and resizes the pane to 160x80. Ready means the printed `state: prompt ready` line. The env has its own config dir, so no live plugin, memory, MCP server or setting of the user reaches it, and vim mode starts off.

There is no build step: the plugin loads its TypeScript source directly. An edit after `up` is invisible to the running env. Run `$V down`, then `$V up` again.

To run beside another verification, give each run its own `--name`. Never drive the user's own Claude Code session or a testenv you did not start.

## Step 2. Doctor

Run `$V doctor` and require `doctor: ok`. It reads the env without touching it: source path and HEAD against the checkout, plugin version, tui state and claude pid, and the `editorMode` the env holds. A `problem:` line names its repair. Run it again whenever a screen looks wrong.

## Step 3. Drive

- **Type a command.** `$T tui vimkeys-verify send '/vim-keys' --wait '<regex>'` types the text, presses Enter and waits for the regex on screen (exit 1 on timeout, 90 s default, `--timeout S` changes it).
- **Type without Enter.** `$T tui vimkeys-verify send --no-enter '<text>'` leaves the text in the prompt, which opens the slash menu for text starting with `/`.
- **Press keys.** `$T tui vimkeys-verify keys <key>...` sends tmux key names: `Escape`, `Enter`, `Down`, `Up`, `Left`, `Right`, `C-u`. Lower-case letters sent through `send --no-enter` reach the prompt as vim commands in NORMAL mode, after `Escape`.
- **Read.** `$T tui vimkeys-verify read` prints the screen. The pane sits right of a `│` column, at about column 88; the chat and the prompt are left of it.

Handles to wait for: the reply line `vim-cheatsheet: Vim-Cheatsheet geöffnet.`, the pane section titles `Modus`, `Navigation`, `Bearbeiten`, `Textobjekte (mit d c y)`, `VISUAL`, `Nicht unterstützt`, the pane footer `Aktivieren: /config → Editor mode → vim`, and the mode badge `-- INSERT --` in the status line below the prompt. NORMAL mode shows no badge: the status line then starts with `⏵⏵`.

## Step 4. Evidence

Store everything under `<root>/.claude/cycles/<cycle>/verify/<feature-id>/`. With no running cycle, create one with `~/.claude/bin/new-cycle.rb verify-<feature-id>`.

- **Screens.** Run `$V snap <dir>/<NN>-<step>` before and after each action. It writes `<stem>.txt` (screen text) and `<stem>.png` (rendered screen).
- **Side effects.** The plugin writes nothing. The one stored state a journey changes is `editorMode` in the env's `settings.json`; `$V doctor` reads it back.
- **Standard.** Type the real command and press the real keys of the card. A unit test or `claude plugin test` is no drive. Capture the screen before and after each action, not only the end. Report a sub-feature you could not reach with the keys you pressed and the screen you got; never report it as verified through another path.

## Step 5. Cleanup

Run `$V down`, after a failed run too. It stops the tmux server `cc-testenv-vimkeys-verify` and the claude it started and removes the env dir, nothing else. `$V down --dry-run` lists the targets first. Run it from outside the env's own session. The evidence stays in the cycle folder. Never kill claude by name: the user runs their own sessions.

## Output

Return the feature id, the evidence directory, and per sub-feature `pass` or `fail` with the snap file that shows it.
