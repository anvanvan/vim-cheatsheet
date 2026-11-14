# vim-cheatsheet

A Claude Code plugin for people who use vim mode in the prompt and forget the keys. Type `/vim-keys` and a pane opens beside the chat. It lists every vim-mode binding Claude Code supports: mode switches, motions, editing commands, text objects, visual mode, and what is not supported. You keep typing in the prompt while the pane stays open.

## Install

```
claude plugin install vim-cheatsheet --marketplace anvanvan/vim-cheatsheet
```

Inside a session, use `/plugin install vim-cheatsheet --marketplace anvanvan/vim-cheatsheet` instead.

## Use

1. Turn on vim mode: `/config`, then Editor mode, then `vim`.
2. Type `/vim-keys`. The pane opens beside the chat. When vim mode is off, the command also tells you how to turn it on.

The plugin works in Claude Code: the terminal, the desktop app's Code tab and the VS Code extension. Chat on claude.ai and in the Claude apps ignores it, so `/vim-keys` does not appear there.

## Source

The list follows the official docs: [Interactive mode, vim editor mode](https://code.claude.com/docs/en/interactive-mode#vim-editor-mode). Some keys need a newer Claude Code: `Ctrl+[` needs 2.1.242, `d0` needs 2.1.281, and `%` needs 2.1.301. The pane marks them.

## Privacy

The plugin reads no files, sends no data, and stores nothing. It registers one slash command and draws one pane.

## License

MIT
