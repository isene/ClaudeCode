# HyperList Color Scheme Reference

## Overview

HyperList uses consistent syntax highlighting across the TUI and Vim plugin. This document maps each syntax element to its color code.

## TUI "Normal" Theme (256-color codes)

Terminal colors for dark background terminals:

```
red      = 196   (#FF0000)  - Properties, dates, multi-line indicators, change markup
green    = 46    (#00FF00)  - Qualifiers, checkboxes, state/transition markers, semicolons
blue     = 21    (#0000FF)  - Operators (ALL-CAPS:)
magenta  = 165   (#D700FF)  - References <...>, special keywords (SKIP, END)
cyan     = 51    (#00FFFF)  - Parentheses (...), quoted strings "..."
yellow   = 226   (#FFFF00)  - Substitutions {...}
orange   = 208   (#FF8700)  - Hash tags #tag
gray     = 245   (#8A8A8A)  - Dimmed text
```

## Vim Plugin Colors

Terminal colors (cterm) and GUI colors:

```vim
hi HLident   ctermfg=Magenta  guifg=Magenta     " Identifiers
hi HLmulti   ctermfg=Red      guifg=Red         " Multi-line indicator +
hi HLtag     ctermfg=Red      guifg=Red         " Hash tags (Vim uses red)
hi HLop      ctermfg=Blue     guifg=Blue        " Operators AND:, OR:, etc.
hi HLqual    ctermfg=Green    guifg=LimeGreen   " Qualifiers [...]
hi HLsub     ctermfg=157      guifg=LightGreen  " Substitutions {...}
hi HLhash    ctermfg=184      guifg=#aaa122     " Hash tags (alternate)
hi HLref     ctermfg=Magenta  guifg=Magenta     " References <...>
hi HLkey     ctermfg=Magenta  guifg=Magenta     " Keywords SKIP, END
hi HLcomment ctermfg=Cyan     guifg=Cyan        " Comments (...)
hi HLquote   ctermfg=Cyan     guifg=Cyan        " Quotes "..."
hi HLb       cterm=bold       gui=bold          " Bold *text*
hi HLi       cterm=italic     gui=italic        " Italic /text/
hi HLu       underlined                         " Underline _text_
```

## PDF/Print Colors (Readable on white background)

Adjusted darker colors for printing:

```
red      = #CC0000  - Properties, dates, multi-line indicators
green    = #00AA00  - Qualifiers, checkboxes, state/transition markers
blue     = #0000CC  - Operators
magenta  = #AA00AA  - References, special keywords
cyan     = #00AAAA  - Parentheses, quoted strings
yellow   = #AA8800  - Substitutions
orange   = #CC5500  - Hash tags
```

## Syntax Element to Color Mapping

### Red Elements
- **Properties**: `Name: value` (mixed case, ends with `: `)
- **Dates/Timestamps**: `2025-10-16`, `YYYY-MM-DD hh.mm:`
- **Multi-line indicator**: `+` at line start
- **Change markup**: `##<`, `##>`, `##->`

### Green Elements
- **Qualifiers**: `[...]` (conditions, counts, timestamps in brackets)
- **Checkboxes**: `[ ]`, `[_]`, `[O]`, `[x]`, `[X]`, `[-]`
- **State marker**: `|` at line start
- **Transition marker**: `/` at line start
- **Semicolons**: `;` separator

### Blue Elements
- **Operators**: ALL-CAPS followed by `: ` (colon-space)
  - Examples: `AND:`, `OR:`, `NOT:`, `IF:`, `THEN:`, `IMPLIES:`
  - Special: `EXAMPLE:`, `CONTINUOUS:`, `ENCRYPTION:`
- **Special operator keyword**: `EXAMPLE:` in contexts

### Magenta/Purple Elements
- **References**: `<item>` or `<<item>>`
- **Identifiers**: `1.1.1`, `1A2B` at line start
- **Special keywords**: `SKIP`, `END`

### Cyan Elements
- **Parentheses**: `(...)` for comments
- **Quoted strings**: `"..."` for quotes

### Yellow Elements
- **Substitutions**: `{variable}`

### Orange Elements
- **Hash tags**: `#tag`, `#TODO`, `#important`

## TUI Processing Order

The TUI applies colors in this priority order to avoid conflicts:

1. Checkboxes `[X]`, `[O]`, `[-]`, `[ ]`
2. Multi-line indicator `+` at start
3. Date timestamps `YYYY-MM-DD hh.mm:`
4. Operators (ALL-CAPS:)
5. Properties (mixed case:)
6. State/transition markers `|`, `/` at start
7. Qualifiers `[...]` (if not checkbox)
8. Parentheses `(...)`
9. Semicolons `;`
10. References `<...>`
11. Special keywords `SKIP`, `END`
12. Quoted strings `"..."`
13. Change markup `##...`
14. Substitutions `{...}`
15. Hash tags `#tag`
16. Text formatting `*bold*`, `/italic/`, `_underline_`

## Usage Notes

- **Avoid conflicts**: Order matters - checkboxes before qualifiers
- **Consistency**: Use same theme across documents
- **Readability**: Dark colors on white for print, bright on dark for terminals
- **Testing**: View in TUI (`hyperlist file.hl`) to verify coloring
