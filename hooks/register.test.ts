import { expect, test } from 'claude-code/testing'

// Answers what the engine would: the settings with the given editorMode, and
// every ui.open as placed. Returns the ids of the panes the mod opened.
const engine = (on: any, editorMode: string) => {
  const opened: string[] = []
  on('settings.read', async () => ({ value: { editorMode } }))
  on('ui.open', async (_$: unknown, e: { id: string }) => {
    opened.push(e.id)
    return { value: { isPlaced: true } }
  })
  return opened
}

// The run as a person typing /vim-keys in a 200-column terminal makes it.
const RUN = {
  command: 'vim-keys',
  args: '',
  origin: { kind: 'composer' },
  presentation: { isFullscreen: false, columns: 200 },
} as const

test('vim mode on: opens the pane without a hint', async ($, on) => {
  const opened = engine(on, 'vim')
  const { text } = await $.command.run(RUN)
  expect(opened).toEqual(['vim-keys'])
  expect(text).toBe('Vim-Cheatsheet geöffnet.')
})

test('vim mode off: opens the pane and says how to turn vim on', async ($, on) => {
  const opened = engine(on, 'normal')
  const { text } = await $.command.run(RUN)
  expect(opened).toEqual(['vim-keys'])
  expect(text).toContain('Vim-Mode ist aus')
  expect(text).toContain('/config → Editor mode → vim')
})
