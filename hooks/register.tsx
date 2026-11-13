import type { Register } from 'claude-code'

const PANE = 'vim-keys'
const TITLE = 'Vim-Mode Keys'

type Section = { title: string; rows: [string, string][] }

// Source: https://code.claude.com/docs/en/interactive-mode.md#vim-editor-mode
const SECTIONS: Section[] = [
  { title: 'Modus', rows: [
    ['Esc / Ctrl+[', 'NORMAL (Ctrl+[ ab v2.1.242)'],
    ['i I a A', 'INSERT: vor Cursor / Zeilenanfang / nach Cursor / Zeilenende'],
    ['o O', 'neue Zeile unten / oben'],
    ['v V', 'VISUAL zeichen- / zeilenweise'],
  ] },
  { title: 'Navigation', rows: [
    ['h j k l', 'links / runter / hoch / rechts'],
    ['w e b', 'nächstes Wort / Wortende / voriges Wort'],
    ['0 ^ $', 'Zeilenanfang / erstes Zeichen / Zeilenende'],
    ['gg G', 'Eingabeanfang / letzte Zeile'],
    ['f F t T {c}', 'zu Zeichen vor / zurück / bis vor / bis nach'],
    ['; ,', 'f/F/t/T wiederholen / umgekehrt'],
    ['%', 'passende Klammer (ab v2.1.301)'],
    ['/', 'History-Suche (wie Ctrl+R)'],
    ['{n}  z. B. 3x 2dw', 'Zähler vor Befehl (getestet, nicht dokumentiert)'],
  ] },
  { title: 'Bearbeiten', rows: [
    ['x  r{c}', 'Zeichen löschen / ersetzen'],
    ['dd D', 'Zeile / bis Zeilenende löschen'],
    ['dw de db', 'Wort / bis Ende / zurück löschen'],
    ['df{c} dt{c}', 'bis einschl. / bis vor Zeichen'],
    ['dj dk dgg dG', 'Zeilen unten / oben / bis Anfang / bis Ende'],
    ['d0 c0 y0', 'bis Zeilenanfang (ab v2.1.281)'],
    ['d% c% y%', 'durch Klammer (ab v2.1.301)'],
    ['cc C cw ce cb', 'ändern: Zeile / Rest / Wort / Ende / zurück'],
    ['s S', 'Zeichen / Zeile ersetzen (INSERT)'],
    ['yy Y yw ye yb', 'kopieren: Zeile / Wort / Ende / zurück'],
    ['p P', 'einfügen danach / davor'],
    ['>> <<  J  u  .', 'einrücken / ausrücken / verbinden / undo / wiederholen'],
  ] },
  { title: 'Textobjekte (mit d c y)', rows: [
    ['iw aw  iW aW', 'Wort / WORT'],
    ['i" a"  i\' a\'', 'Anführungszeichen'],
    ['i( i[ i{  a( a[ a{', 'Klammern'],
  ] },
  { title: 'VISUAL', rows: [
    ['d x  y  c s  p', 'löschen / kopieren / ändern / ersetzen'],
    ['r{c}  ~ u U', 'alle ersetzen / Case umschalten / klein / groß'],
    ['> <  J  o', 'ein- / ausrücken / verbinden / Ende tauschen'],
  ] },
  { title: 'Nicht unterstützt', rows: [
    ['Ctrl+V', 'Blockweise Auswahl'],
    ['"a  m  :', 'Register, Marks, Ex-Befehle: nicht dokumentiert'],
  ] },
]

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'vim-keys',
      description: 'Vim-Mode-Cheatsheet in einem Panel anzeigen',
    })
    return next(e)
  })

  on('command.run', { command: 'vim-keys' }, async $ => {
    await $.ui.open({ id: PANE, title: TITLE })
    return { text: 'Vim-Cheatsheet geöffnet.' }
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    return (
      <Box flexDirection="column">
        {SECTIONS.map(s => (
          <Box flexDirection="column" marginBottom={1}>
            <Text bold>{s.title}</Text>
            {s.rows.map(([k, d]) => (
              <Text>
                <Text color="cyan">{k.padEnd(20)}</Text>
                <Text dimColor>{d}</Text>
              </Text>
            ))}
          </Box>
        ))}
        <Text dimColor>Aktivieren: /config → Editor mode → vim</Text>
      </Box>
    )
  })
}
