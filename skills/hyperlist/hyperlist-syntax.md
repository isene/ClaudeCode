# HyperList Syntax Reference v2.6

## Overview

HyperList is a text-based system for representing any data - states, actions, processes, or ideas. It's Turing complete, wiki-able (easy collaboration), and uses hierarchical indentation with a rich markup syntax.

## Basic Structure

A HyperList Item consists of (in sequence):
1. **Starter** (optional) - Identifier or Multi-line Indicator
2. **Type** (optional) - State or Transition
3. **Content** (required) - Element and/or Additive
4. **Separator** - Newline or semicolon

## Indentation

- Use **tabs** or **asterisks (*)** for indentation
- Each level = one tab or one asterisk
- Children are indented one level to the right
- Consistent indentation within a file

## 1. Starter (Optional)

### Identifier
- Unique indicator for referring to Items
- Numbering: `1.1.1.1` or `1A1A` (compact form)
- Required if Item has multi-line content

### Multi-line Indicator
- Symbol: `+` (plus sign at start)
- Use when Item spans multiple lines
- Second line indented same level + one space prefix
- If one Item on a level is multi-line, ALL on that level need Starter

Example:
```
Multi-line Indicator = "+"
   1 Following lines are of the same indent with a "space" before
    the text
   + If one Item on a certain level/indent is multi-line, all Items
    on the same level/indent must start with a plus sign ("+") or <Identifier>
```

## 2. Type (Optional)

Explicitly mark state vs transition Items:
- **State**: `S:` or `|` (describes things/states)
- **Transition**: `T:` or `/` (describes actions/processes)
- Children inherit parent's Type unless specified otherwise

## 3. Content (Required)

### 3.1 Element

#### Operator
- Operates on Item(s)
- **ALL CAPS** ending in `: ` (colon + space)
- Logical operators: `AND:`, `OR:`, `AND/OR:`, `NOT:`, `IMPLIES:`
- Special operators: `EXAMPLE:`, `EXAMPLES:`, `CONTINUOUS:`, `ENCRYPTION:`
- Can contain Comments: `OR(PRIORITY):` means sub-Items chosen by priority order

Examples:
```
OR:
   Option 1
   Option 2
   Option 3

AND:
   Condition 1 must be true
   Condition 2 must be true

CONTINUOUS: YYYY-MM-07: Do this weekly
```

#### Qualifier
- Any statement in **square brackets** `[...]`
- Specifies conditions, repetitions, timestamps
- Multiple Qualifiers separated by commas (AND logic)
- Successive Qualifiers separated by periods (sequential contexts)

**Common Qualifiers:**
- Optional: `[?]`
- Repeat count: `[3]` = do 3 times
- Range: `[2..4]` = do 2 to 4 times
- Minimum: `[1+]` = do 1 or more times
- Maximum: `[<4]` = do up to 4 times
- Conditional: `[Button color = Red]`
- Combined: `[3, foo=true]` = do 3 times while foo is true

**Checkboxes:**
- `[ ]` or `[_]` = Unchecked (to be done)
- `[O]` = In progress
- `[X]` or `[x]` = Checked (completed)
- `[x] YYYY-MM-DD hh.mm:` = Checked with timestamp
- `[-]` = Partial completion

**Timestamps:**
- Format: `YYYY-MM-DD hh.mm.ss` (ISO-8601)
- Shorten to appropriate granularity: `YYYY-MM-DD`, `YYYY-MM`, etc.
- Examples: `[2025-10-16]`, `[2025-10-16 14.30]`

**Time Relations:**
- Wait before: `[+YYYY-MM-DD]`
- Wait after previous: `[<+YYYY-MM-DD]`, `[>+YYYY-MM-DD]`
- Wait before next: `[-YYYY-MM-DD]`, `[<-YYYY-MM-DD]`, `[>-YYYY-MM-DD]`
- Wait after referenced: `[+YYYY-MM-DD<Item>]`
- Obvious formats: `[+1 week]`, `[-2 days]`

**Recurring Timestamps:**
- Intuitive: `[YYYY-MM-03]` = 3rd of every month
- `[YYYY-12-DD]` = Every day in December
- `[Tue,Fri 12.00]` = Noon every Tuesday and Friday
- Strict: `YYYY-MM-DD+X Day hh.mm+Y - YYYY-MM-DD hh.mm`
  - `[2025-05-01+7 13.00]` = Every 7 days from May 1, 2025 at 1pm
  - `[2025-05-01+2,3,2]` = Every 2, then 3, then 2 days, repeating
  - `[2025-05-01 Fri,Sat - 2025-10-01]` = Every Fri & Sat in interval

#### Substitution
- Curly brackets: `{variable}`
- Reuse values in different contexts
- Examples:
  - `[fruit = apples, oranges] Eat {fruit}` → Eat apples, then oranges
  - `Ask which painting; Buy {painting}` → Buy the chosen painting

#### Property
- Attribute ending in `: ` (colon + space)
- Format: `Name: value` or `Name = Value:`
- Examples: `Location = Office:`, `Color = Green:`, `2025-10-16:`, `In Norway:`

#### Description
- Main text content of the Item
- The "meat" of the line
- Most Items have at least a Description

### 3.2 Additive

#### Reference
- Enclosed in `<...>` or `<<...>>`
- Points to another Item, file, URL, etc.

**Types:**
- **Hard Reference** (redirection): Item contains only Reference
  - Transition: Jump to referenced Item and execute
  - State: Include referenced Item at this point
  - Return after: `<<Reference>>` (double brackets)
- **Soft Reference**: Reference is part of Item (lookup info)
- **Softer Reference**: `(<Reference>)` in parentheses (apropos only)

**Reference Formats:**
- Item above: `<Item Description>` or `<Identifier>`
- Item below: `<Parent/Child/Grandchild>` (path with /)
- Different branch: Start from common ancestor
- Relative: `<+7>` = 7 Items below, `<-3>` = 3 Items above
- Concatenated: `<Some long.../Item na...>` (must be unique)
- File: `<file:/path/to/filename>`
- URL: `<http://example.com>`

**Special Keywords:**
- `SKIP` = End current HyperList level
- `END` = End entire HyperList

#### Tag
- Hash sign + alphanumeric: `#tag`
- No spaces allowed
- Examples: `#TODO`, `#RememberThis`, `#urgent`, `#2025`

#### Comment
- Anything in **parentheses**: `(comment text)`
- Not executed as HyperList command
- Can contain References, Tags, etc.

#### Quote
- Anything in **double quotes**: `"quoted text"`
- Not executed as HyperList command
- Can contain References, Tags, etc.

#### Change Markup
- Mark deletions, moves, changes
- **Deletion**: `##<` at end of Item
- **Move**: `##><Reference>` at end (moves below referenced Item)
- **Indent left**: `##<-` at end
- **Indent right**: `##->` at end
- **Combined**: `##><Ref>##->` (move and make child)
- **Changed**: `##Text##` prefix to show change info
  - Example: `##John 2025-10-16## Updated content`

## 4. Separator

### Newline
- Standard separator between Items
- Creates next Item at same level
- With indent (tab or *): Creates child Item

**Separator Semantics:**
- Same/less indent: Reads as "then"
- Parent has Description → Child reads as "with" or "consists of"
- Parent no Description → Child reads as "applies to", children separated by "and"

### Semicolon
- Separates multiple Items on same line
- Example: `Location: Store; Get milk; Get bread`

## Special Features

### Literal Blocks
- Mark start/end with single backslash `\` on its own line
- Everything between is non-interpreted text (like HTML `<pre>`)
- Useful for including code blocks

Example:
```
\
This is literal text
[?] This is NOT a qualifier
<This> is NOT a reference
\
```

### Text Formatting
- **Bold**: `*text*` (asterisk, space-bounded)
- **Italic**: `/text/` (slash, space-bounded)
- **Underline**: `_text_` (underscore, space-bounded)

### Config Line
- First line format: `((option1=value1, option2=value2))`
- Options: `fold_level`, `theme`, `wrap`, `show_numbers`, `auto_save`, `tab_width`
- Example: `((fold_level=2, theme=normal))`

## Complete Example

```
((fold_level=2))
Project Planning 2025-10-16:
   [_] Phase 1: Research
      [x] 2025-10-01: Gather requirements
      [O] Interview stakeholders
         [3] Conduct interviews
         Document findings
      [?] Create user personas
   [_] Phase 2: Development
      Location = Oslo:
      Team: John, Sarah, Mike
      AND:
         Setup development environment
         Create initial prototype
      OR(PRIORITY):
         Agile methodology
         Waterfall approach
   [2025-11-01] Deadline: Deliver final report
      <<Requirements Template>>
   #milestone #important
```

## Best Practices

1. Use tabs (or *) for indentation, not spaces
2. One concept per line, use hierarchy for relationships
3. Properties end with colon-space
4. Operators are ALL-CAPS with colon-space
5. Qualifiers in [...], Comments in (...), Quotes in "..."
6. References for navigation and reuse
7. Tags for categorization and searching
8. Keep lists readable - don't over-complicate

## Colors (TUI/Vim Standard)

See color-scheme.md for complete color mappings.
