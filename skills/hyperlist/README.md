# HyperList Skill for Claude Code

Expert knowledge of HyperList format for creating, editing, and converting hierarchical lists.

## What's Included

- **SKILL.md**: Main skill definition (auto-invoked by Claude Code)
- **hyperlist-syntax.md**: Complete HyperList v2.6 syntax reference
- **color-scheme.md**: Color mappings for TUI, Vim, and PDF output
- **scripts/generate_hyperlist_html.py**: Convert .hl files to colored HTML/PDF
- **examples/**: Sample HyperList files demonstrating various use cases

## Usage

This skill is automatically invoked when you mention:
- HyperList or .hl files
- Creating hierarchical lists
- Converting HyperList to PDF
- HyperList syntax or formatting questions

## Quick Reference

### Creating HyperLists
- Use tabs or * for indentation
- Properties end with `: ` (colon-space)
- Operators are ALL-CAPS with `:` (AND:, OR:, IF:, THEN:)
- Qualifiers in square brackets: `[?]`, `[3]`, `[2..4]`, `[condition]`
- Question mark for conditionals: `[? condition]` (best practice)
- Checkboxes: `[ ]`, `[O]`, `[X]`
- Comments in parentheses: `(comment)`
- References: `<item>` or `<<item>>`
- Tags: `#tag`

### Converting to PDF

**Method 1: Direct PDF with ReportLab**
```bash
python3 ~/.claude/skills/hyperlist/scripts/generate_hyperlist_pdf.py file.hl [output.pdf]
```

**Method 2: HTML intermediate (requires wkhtmltopdf)**
```bash
python3 ~/.claude/skills/hyperlist/scripts/generate_hyperlist_html.py file.hl
wkhtmltopdf --page-size A4 --orientation Landscape file.html file.pdf
```

Both methods produce properly colored PDFs in landscape orientation with intelligent page breaks.

## Color Scheme Summary

- **Red**: Properties, dates, multi-line indicators `+`
- **Green**: Qualifiers `[...]`, checkboxes, semicolons `;`
- **Blue**: Operators `AND:`, `OR:`, `EXAMPLE:`
- **Magenta**: References `<...>`, identifiers, `SKIP`, `END`
- **Cyan**: Comments `(...)`, quotes `"..."`
- **Yellow**: Substitutions `{variable}`
- **Orange**: Tags `#tag`

## Resources

- HyperList Homepage: http://isene.org/hyperlist/
- TUI Tool: https://github.com/isene/hyperlist
- Vim Plugin: https://github.com/isene/hyperlist.vim
- Specification: See hyperlist-syntax.md
