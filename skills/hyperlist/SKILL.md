---
name: HyperList Expert
description: Expert knowledge of HyperList format (.hl files) for creating, editing, converting, and generating PDFs from hierarchical lists. Activate when user mentions HyperList, .hl files, hierarchical lists, or needs to work with structured outline formats.
---

# HyperList Expert Skill

This skill provides comprehensive knowledge of the HyperList format, syntax, coloring, and tooling.

## When to Use This Skill

Activate when the user:
- Mentions "HyperList" or ".hl files"
- Wants to create, edit, or format hierarchical lists
- Needs to convert HyperList to PDF, HTML, or other formats
- Asks about HyperList syntax, operators, or formatting
- References the HyperList TUI or Vim plugin
- Wants to apply HyperList coloring or styling

## Core Capabilities

### 1. HyperList Syntax Mastery
- Complete understanding of HyperList 2.6 specification
- Indentation with tabs or asterisks (*)
- Operators (AND:, OR:, S:, T:, etc.) - ALL-CAPS with colon-space
- Qualifiers in square brackets [...]
- Properties (Name: value) - lowercase/normal case ending with colon-space
- Checkboxes ([X], [O], [-], [ ])
- References (<item> or <<item>>)
- Substitutions {variable} for reusable values
- Tags (#tag)
- Text formatting (*bold*, /italic/, _underline_)
- Quotes and comments

**CRITICAL SYNTAX RULES:**
- **Operators** are ALL-CAPS ending in colon-space: `AND:`, `OR:`, `EXAMPLE:`
  - Used for logical operations on child items
  - Do NOT use for labels like "DETECTION" or "HANDLING" - those are just descriptions
- **Properties** end with colon-space: `Name: value` or `Color: Red`
  - Can be normal case or Title Case
- **Conditionals** use qualifier syntax: `[? condition]` or `[? condition <reference>]`
  - NOT written as `IF: condition` unless operating on child items
- **Substitutions** use curly braces: `{variable}` not `<variable>`
  - Angle brackets `<...>` are for References only
- **Numbered lists** use period after number: `1. item` NOT `1: item`
  - Colon after number would make it a Property

### 2. Color Scheme Knowledge
Exact color mappings from HyperList TUI and Vim plugin:
- **Red (#FF0000 / #CC0000 for print)**: Properties, dates, multi-line indicators, change markup
- **Green (#00FF00 / #00AA00 for print)**: Qualifiers, checkboxes, state/transition markers, semicolons
- **Blue (#0000FF / #0000CC for print)**: Operators (ALL-CAPS:), keywords like EXAMPLE
- **Magenta (#D700FF / #AA00AA for print)**: References <...>, special keywords (SKIP, END)
- **Cyan (#00FFFF / #00AAAA for print)**: Parentheses (...), quoted strings "..."
- **Yellow (#FFFF00 / #AA8800 for print)**: Substitutions {...}
- **Orange (#FF8700 / #CC5500 for print)**: Hash tags #tag

### 3. Conversion Tools
- Python script for HTML generation with proper coloring
- PDF generation via wkhtmltopdf
- Intelligent page breaks preserving context
- Landscape orientation for readability

### 4. Best Practices
- Use tabs (or *) for indentation, not spaces
- Keep config lines at top: ((fold_level=2, theme=normal))
- One concept per line, use indentation for hierarchy
- Properties end with colon-space (Name: value)
- Operators are ALL-CAPS with colon-space (AND:, OR:, EXAMPLE:)
- Use qualifiers [...] for conditions and metadata
- Use substitutions {...} for variables/placeholders
- Use references <...> for navigation and cross-references
- Use parentheses (...) for comments
- Numbered lists use period: `1. item` not `1: item`
- Section headers are just descriptions (not Operators unless they truly operate on children)

## Available Resources

- **hyperlist-definition.md**: Complete HyperList 2.6 syntax specification
- **color-scheme.md**: Detailed color mappings for TUI/Vim/PDF
- **scripts/generate_hyperlist_html.py**: Convert .hl to colored HTML/PDF
- **examples/**: Sample HyperList files

## Tool Usage

When working with HyperList:
1. Read hyperlist-definition.md for syntax questions
2. Reference color-scheme.md for coloring details
3. Use scripts/generate_hyperlist_html.py for conversions
4. Check examples/ for patterns

## Output Guidelines

When creating HyperList content:
- Always use proper indentation (tabs or *)
- Apply correct operators and qualifiers
- Follow HyperList conventions strictly
- Preserve hierarchy and relationships
- Use appropriate formatting (bold, italic, etc.)
- Include config line if non-default settings needed

## Common Mistakes to Avoid

1. **DO NOT use Operators for section headers/labels**
   - Wrong: `DETECTION:` (unless it truly operates on children)
   - Right: `DETECTION - Ask questions in sequence` (just a description)

2. **DO NOT use colons after numbers in lists**
   - Wrong: `1: "Where did this come from?"`
   - Right: `1. "Where did this come from?"`
   - Reason: Colon makes it a Property, not a list item

3. **DO NOT confuse Substitutions with References**
   - Substitutions: `{variable}` for values to be filled in
   - References: `<item>` for navigation to other items
   - Wrong: `<subject>` when you mean a placeholder
   - Right: `{subject}` for a variable/placeholder

4. **DO NOT write conditionals as Operators**
   - Wrong: `IF: metered THEN: Put on meter`
   - Right: `[? metered] Put on meter`
   - Exception: `IF:` as Operator only when it operates on child items

5. **Conditional with reference to another item**
   - Use: `[? condition <reference>]` format
   - Example: `[? answer = "yes" <LOCATION>]` jumps to LOCATION if answer is yes
