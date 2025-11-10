---
name: rcurses
description: "Expert knowledge of rcurses Ruby TUI library for creating terminal user interfaces. Activate when building Ruby TUI applications, working with terminal panes, handling user input, or debugging rcurses applications. Covers initialization, pane management, text formatting, cursor control, and common pitfalls."
license: Public Domain (Unlicense)
---

# rcurses - Ruby Terminal User Interface Library

## Overview

rcurses is a pure Ruby alternative to the traditional curses library, designed for creating terminal user interfaces (TUIs) with:
- Multi-pane layouts with borders and colors
- Rich text formatting (bold, italic, underline, blink, reverse)
- 256-color and RGB color support
- Built-in text editors for panes
- Robust input handling with special key detection
- Cursor positioning and control

**Current Version**: 6.1.5
**Repository**: https://github.com/isene/rcurses
**Installation**: `gem install rcurses`

## Critical Initialization Pattern

### ALWAYS Use This Pattern

```ruby
#!/usr/bin/env ruby
require 'rcurses'
require 'io/wait'  # CRITICAL for stdin flush

class MyApp
  include Rcurses
  include Rcurses::Input

  def run
    # 1. Initialize rcurses FIRST
    Rcurses.init!

    # 2. Get terminal size
    @h, @w = IO.console.winsize

    # 3. Create your panes
    @pane_top = Pane.new(1, 1, @w, 1, 255, 235)
    @pane_main = Pane.new(1, 3, @w, @h-4, 15, 0)

    # 4. Load initial data and render
    load_data
    render_all

    # 5. CRITICAL: Flush stdin before main loop
    # Prevents cursor position requests from blocking initial render
    $stdin.getc while $stdin.wait_readable(0)

    # 6. Main loop pattern
    loop do
      render_all           # Render first
      chr = getchr         # Then get input
      handle_input(chr)    # Then handle it
      break if chr == 'q'
    end
  ensure
    # Clean up
    Cursor.show
    Rcurses.clear_screen
  end

  def render_all
    # Use text= and refresh for render loops
    @pane_top.text = "My Application"
    @pane_top.refresh

    @pane_main.text = @content
    @pane_main.refresh
  end
end

# Run the application
MyApp.new.run
```

### Why This Pattern?

1. **Rcurses.init!** must be called explicitly (breaking change in v6.0.0)
2. **stdin flush** prevents blank panes on startup (terminal sends `\e[6n` cursor position request)
3. **render → input → handle** prevents race conditions and blank screens
4. **text= + refresh** preserves scroll position; `say` resets to top

## Pane Class Reference

### Creating Panes

```ruby
pane = Rcurses::Pane.new(x, y, w, h, fg, bg)

# Example: Create pane at column 10, row 5, 40 chars wide, 20 rows tall
# with foreground color 19 and background color 229
pane = Rcurses::Pane.new(10, 5, 40, 20, 19, 229)

# Omit colors for terminal defaults
pane = Rcurses::Pane.new(10, 5, 40, 20)

# Use terminal size for responsive layouts
@max_h, @max_w = IO.console.winsize
pane_left = Rcurses::Pane.new(1, 1, @max_w/2, @max_h, 255, 0)
pane_right = Rcurses::Pane.new(@max_w/2 + 1, 1, @max_w/2, @max_h, 0, 255)
```

### Pane Properties

| Property | Type | Description |
|----------|------|-------------|
| `x` | Integer | Column position (1-indexed) |
| `y` | Integer | Row position (1-indexed) |
| `w` | Integer | Width in characters |
| `h` | Integer | Height in rows |
| `fg` | Integer/String | Foreground color (0-255 or RGB hex "ff00aa") |
| `bg` | Integer/String | Background color (0-255 or RGB hex "ff00aa") |
| `border` | Boolean | Draw border around pane (default: false) |
| `scroll` | Boolean | Show scroll indicators ∆/∇ (default: true) |
| `text` | String | Content of the pane |
| `ix` | Integer | Top line index for scrolling (default: 0) |
| `index` | Integer | User-defined selected item index |
| `align` | String | Text alignment: "l", "c", "r" (default: "l") |
| `prompt` | String | Prompt text for editline |
| `moreup` | Boolean | True when content exists above visible area |
| `moredown` | Boolean | True when content exists below visible area |
| `record` | Boolean | Enable history tracking (default: false) |
| `history` | Array | History of text changes (when record=true) |

### Pane Methods

#### Display Methods

```ruby
# Refresh pane with current content
pane.refresh

# Refresh border only - CRITICAL after changing border property
pane.border = true
pane.border_refresh  # Must call this!

# Force complete repaint (clears render cache)
pane.full_refresh

# Shorthand: set text and refresh
pane.say("Hello World")  # Resets ix to 0

# Shorthand: prompt and get input
result = pane.ask("Enter name: ", "default")

# Clear pane content
pane.clear
```

#### Scrolling Methods

```ruby
pane.lineup        # Scroll up one line
pane.linedown      # Scroll down one line
pane.pageup        # Scroll up one page (h-1 lines)
pane.pagedown      # Scroll down one page (h-1 lines)
pane.top           # Scroll to top (ix = 0)
pane.bottom        # Scroll to bottom
```

#### Position Methods

```ruby
# Move pane by relative amounts
pane.move(dx, dy)  # e.g., move(-5, 10) moves left 5, down 10
```

#### Editor Methods

```ruby
# Multi-line editor with markdown-like formatting
pane.edit
# In editor:
# - *bold* → bold text
# - /italic/ → italic text
# - _underline_ → underlined text
# - #reverse# → reverse colors
# - <fg,bg,biulr|text> → fully formatted text
# - Ctrl-S saves, ESC cancels
# - Ctrl-L/C-R/C-C for left/right/center align
# - Ctrl-Y copies to clipboard

# Single-line editor with prompt
pane.editline
# Features:
# - Shows prompt + editable text
# - UP/DOWN for history (when record=true)
# - HOME/END/LEFT/RIGHT navigation
# - Ctrl-K clears line
# - Word-back delete
# - Multi-line paste support (shows indicator)
# - ENTER saves, ESC cancels

# Memory management
pane.cleanup  # Clear caches and history
```

## String Extensions for Text Formatting

### Color Methods

Colors can be integers (0-255) or RGB hex strings ("ff00aa"):

```ruby
# Foreground color
"Error".fg(196)           # Bright red using 256-color
"Success".fg("00ff00")    # Bright green using RGB

# Background color
"Warning".bg(226)         # Yellow background
"Info".bg("0088ff")       # Blue background

# Both foreground and background
"Alert".fb(255, 196)      # White on red
"Note".fb("ffffff", "0000ff")  # White on blue
```

### Text Attributes

```ruby
"Bold".b           # Bold
"Italic".i         # Italic
"Underline".u      # Underlined
"Blink".l          # Blinking (limited terminal support)
"Reverse".r        # Reverse video (swap fg/bg)

# Chain attributes
"Important".b.u.fg(196)  # Bold, underlined, red

# Coded format: fg,bg,biulr
"Styled".c("204,45,bui")  # fg=204, bg=45, bold+underline+italic
```

### ANSI-Safe String Methods

New in v6.1.0 to prevent ANSI code corruption:

```ruby
# Safe regex substitution (preserves ANSI codes)
colored_text.safe_gsub(/pattern/) { |m| m.fg(46) }
colored_text.safe_gsub!(/(word)/) { |m| m.b }

# Check for ANSI codes
text.has_ansi?  # → true/false

# Get visible length (excluding ANSI codes)
"Hello".fg(196).visible_length  # → 5, not ~15

# Conditional coloring (only if no ANSI codes present)
text.safe_fg(196)  # Apply fg only if text has no ANSI
text.safe_bg(226)  # Apply bg only if text has no ANSI

# Strip formatting
decorated = "Bold".b.fg(196)
decorated.pure  # → "Bold" (no ANSI codes)

# Strip uncolored ANSI wrappers
text.clean_ansi

# Shorten while preserving ANSI
long_colored_text.shorten(50)  # Visible length = 50

# Inject at position while preserving ANSI
text.inject("chars", pos)  # pos=-1 appends at end
```

## Cursor Module

```ruby
include Rcurses::Cursor

# Query position
row, col = pos
row = rowget
col = colget

# Set position
set(col, row)  # Note: col, row order!
col(10)        # Move to column 10
row(5)         # Move to row 5

# Relative movement
up(n)          # Move up n rows
down(n)        # Move down n rows
left(n)        # Move left n columns
right(n)       # Move right n columns
next_line      # Move to start of next line
prev_line      # Move to start of previous line

# Visibility
hide           # Hide cursor
show           # Show cursor

# Save/restore
save           # Save current position
restore        # Restore saved position

# Clearing
clear_char(n)        # Erase n characters from cursor
clear_line           # Erase entire line, return to start
clear_line_before    # Erase from line start to cursor
clear_line_after     # Erase from cursor to line end
scroll_up            # Scroll display up one line
scroll_down          # Scroll display down one line
clear_screen_down    # Clear from current row to bottom
```

## Input Module - getchr Function

```ruby
include Rcurses::Input

# Basic usage
chr = getchr

# With timeout (returns nil if no input)
chr = getchr(5)  # Wait 5 seconds

# Without stdin flush (for editors)
chr = getchr(flush: false)

# Handle multi-character input
chr = getchr
while $stdin.ready?
  chr += $stdin.getc
end
```

### Key Return Values

| Key Pressed | Returned String |
|-------------|----------------|
| Escape | "ESC" |
| Up/Down/Left/Right | "UP", "DOWN", "LEFT", "RIGHT" |
| Shift+Arrow | "S-UP", "S-DOWN", "S-LEFT", "S-RIGHT" |
| Ctrl+Arrow | "C-UP", "C-DOWN", "C-LEFT", "C-RIGHT" |
| Page Up/Down | "PgUP", "PgDOWN" |
| Ctrl+Page Up/Down | "C-PgUP", "C-PgDOWN" |
| Home/End | "HOME", "END" |
| Ctrl+Home/End | "C-HOME", "C-END" |
| Insert/Delete | "INS", "DEL" |
| Ctrl+Insert/Delete | "C-INS", "C-DEL" |
| Backspace | "BACK" |
| Word-back (Ctrl-W) | "WBACK" |
| Tab/Shift-Tab | "TAB", "S-TAB" |
| Enter | "ENTER" |
| Ctrl+A-Z | "C-A" through "C-Z" |
| Ctrl+Space | "C-SPACE" |
| F1-F12 | "F1" through "F12" |
| Any other char | The character itself |

## Common Patterns and Solutions

### 1. Blank Panes on Startup

**Problem**: All panes appear blank until user presses a key.

**Solution**: Flush stdin before main loop:

```ruby
# After initial render, before loop
$stdin.getc while $stdin.wait_readable(0)

loop do
  render_all
  chr = getchr
  # ...
end
```

### 2. Render Loop Pattern

**Use text= + refresh** to preserve scroll position:

```ruby
def render_pane
  @pane.text = build_content
  @pane.ix = @scroll_position  # Preserve scroll
  @pane.refresh
end
```

**Use say** for one-time messages (resets scroll):

```ruby
@status_pane.say("Processing...")  # Resets ix to 0
```

### 3. Border Not Showing After Change

**Problem**: Changed `pane.border = true` but nothing happened.

**Solution**: Call `border_refresh`:

```ruby
@pane.border = true
@pane.border_refresh  # Required!
```

### 4. Scrollable Lists

```ruby
class FileList
  def initialize
    @items = load_items
    @index = 0
    @scroll_pos = 0
    @pane = Pane.new(1, 1, 40, 20, 255, 0)
  end

  def render
    # Build content with highlighting
    content = @items.map.with_index do |item, i|
      if i == @index
        "> #{item}".b.fg(196)  # Highlighted
      else
        "  #{item}"
      end
    end.join("\n")

    @pane.text = content
    @pane.ix = @scroll_pos
    @pane.refresh
  end

  def handle_input(chr)
    case chr
    when "DOWN", "j"
      @index = (@index + 1) % @items.size
      # Auto-scroll if needed
      @scroll_pos = @index if @index >= @scroll_pos + @pane.h
      @scroll_pos = @index - @pane.h + 1 if @index < @scroll_pos
      render
    when "UP", "k"
      @index = (@index - 1) % @items.size
      @scroll_pos = @index - @pane.h + 1 if @index < @scroll_pos
      @scroll_pos = 0 if @scroll_pos < 0
      render
    when "PgDOWN"
      @pane.pagedown
      @index = [@index + @pane.h - 1, @items.size - 1].min
    when "PgUP"
      @pane.pageup
      @index = [@index - @pane.h + 1, 0].max
    end
  end
end
```

### 5. Status Bar Pattern

```ruby
# Create thin status bar
@status = Pane.new(1, @max_h, @max_w, 1, 255, 235)

# Update status
def update_status(message)
  @status.align = "l"
  @status.text = " #{message}"
  @status.refresh
end

# Quick status updates
@status.say(" Ready".fg(46))  # Green success
@status.say(" Error: #{msg}".fg(196))  # Red error
```

### 6. Modal Dialog Pattern

```ruby
def show_dialog(title, message, width = 40, height = 10)
  # Calculate center position
  x = (@max_w - width) / 2
  y = (@max_h - height) / 2

  # Create modal pane
  dialog = Pane.new(x, y, width, height, 255, 235)
  dialog.border = true
  dialog.align = "c"
  dialog.text = "#{title}\n\n#{message}\n\n[Press any key]"
  dialog.refresh

  # Wait for input
  getchr

  # Redraw everything under the dialog
  render_all
end
```

### 7. Text Input with Validation

```ruby
def get_filename
  @input_pane.prompt = "Filename: "
  @input_pane.text = ""
  @input_pane.record = true  # Enable history

  loop do
    @input_pane.editline
    filename = @input_pane.text

    return nil if filename.empty?  # User cancelled

    # Validate
    if filename.match?(/^[a-zA-Z0-9._-]+$/)
      return filename
    else
      show_dialog("Error", "Invalid filename. Use only letters, numbers, ., -, _")
      @input_pane.text = filename  # Keep for editing
    end
  end
end
```

### 8. Split Pane Layout

```ruby
class SplitView
  def initialize
    @h, @w = IO.console.winsize
    @split_ratio = 0.5  # 50/50 split
    create_panes
  end

  def create_panes
    split_col = (@w * @split_ratio).to_i

    @left = Pane.new(1, 1, split_col, @h, 255, 0)
    @right = Pane.new(split_col + 1, 1, @w - split_col, @h, 0, 255)

    @left.border = true
    @right.border = true
  end

  def change_split(ratio)
    @split_ratio = ratio.clamp(0.2, 0.8)
    create_panes  # Recreate with new sizes
    render_all
  end

  def handle_resize
    @h, @w = IO.console.winsize
    create_panes
    render_all
  end
end
```

## Error Logging

New in v6.1.1 - Debug crashes with error logging:

```bash
# Enable error logging
RCURSES_ERROR_LOG=1 ruby my_app.rb
```

Creates detailed logs at `/tmp/rcurses_errors_PID.log` with:
- Full stack trace with line numbers
- Error class and message
- Process info (PID, program name, working directory)
- Ruby and rcurses version info
- Relevant environment variables

Process-specific filenames prevent race conditions with multiple apps.

## Environment Variables

```bash
# Force ASCII borders instead of UTF-8 box drawing
RCURSES_BORDERS=ascii ruby app.rb

# Enable error logging
RCURSES_ERROR_LOG=1 ruby app.rb

# Enable debug output
DEBUG=1 ruby app.rb
RCURSES_DEBUG=1 ruby app.rb
```

## Performance Tips

1. **Use diff rendering**: `refresh` only redraws changed lines
2. **Batch updates**: Minimize refresh calls
3. **Clean up panes**: Call `pane.cleanup` for unused panes
4. **Limit history**: Set `@max_history_size` if using `record`
5. **Use `ix` directly**: Faster than scrolling methods in loops
6. **Cache formatted text**: Don't rebuild ANSI strings every render

## Reference Applications

Study these for best practices:

- **RTFM** (https://github.com/isene/RTFM) - Complex file manager with multi-pane layouts, scrolling, and rich interactions
- **GiTerm** (https://github.com/isene/GiTerm) - Git interface with dynamic content updates
- **T-REX** (https://github.com/isene/T-REX) - Calculator with simpler UI patterns

## Quick Reference Card

```ruby
# Initialization
require 'rcurses'
require 'io/wait'
Rcurses.init!
include Rcurses
include Rcurses::Input

# Pane creation
pane = Pane.new(x, y, w, h, fg, bg)

# Pane display
pane.text = "content"
pane.refresh                    # Diff-based update
pane.full_refresh               # Force complete redraw
pane.say("text")                # Set text + refresh + reset scroll
pane.border_refresh             # Refresh border only

# Pane scrolling
pane.ix = position              # Set scroll position directly
pane.lineup / pane.linedown     # Scroll by line
pane.pageup / pane.pagedown     # Scroll by page
pane.top / pane.bottom          # Scroll to extremes

# Pane editing
result = pane.ask("Prompt: ", "default")
pane.editline                   # Single-line editor
pane.edit                       # Multi-line editor

# Text formatting
"text".fg(196)                  # Foreground color
"text".bg(226)                  # Background color
"text".fb(255, 0)               # Both colors
"text".b.i.u                    # Bold, italic, underline
"text".c("196,226,bi")          # Coded format

# ANSI-safe methods
text.safe_gsub(/pattern/) {|m| m.fg(46)}
text.has_ansi?                  # Check for ANSI codes
text.visible_length             # Length excluding ANSI
text.pure                       # Strip all ANSI

# Input
chr = getchr                    # Get single character
chr = getchr(5)                 # With timeout

# Cursor
set(col, row)                   # Position cursor
hide / show                     # Visibility
save / restore                  # Save/restore position

# Cleanup
Rcurses.clear_screen
Cursor.show
```

## Breaking Changes

### Version 6.0.0

**Auto-initialization removed** - You MUST call `Rcurses.init!` explicitly:

```ruby
# Old (pre-6.0.0) - NO LONGER WORKS
require 'rcurses'
# rcurses auto-initialized here

# New (6.0.0+) - REQUIRED
require 'rcurses'
Rcurses.init!  # Must call explicitly
```

This change ensures compatibility with Ruby 3.4+ and gives applications better control over terminal initialization timing.

## Troubleshooting

### App hangs on startup
- Check if you called `Rcurses.init!`
- Ensure `require 'io/wait'` is included
- Add stdin flush before main loop

### Panes render garbage
- Call `Rcurses.clear_screen` before rendering
- Use `pane.full_refresh` to force clean render
- Check terminal size with `IO.console.winsize`

### Colors not showing
- Verify terminal supports 256 colors: `echo $TERM`
- Try RGB colors instead: `text.fg("ff0000")`
- Check if pane fg/bg are set correctly

### Border not visible
- Call `pane.border_refresh` after changing `border` property
- Check border fits in terminal (needs w+2, h+2 space)

### Memory usage growing
- Call `pane.cleanup` for unused panes
- Disable history: `pane.record = false`
- Clear history manually: `pane.history.clear`

### Text wrapping issues
- Check pane width: `pane.w`
- Use `text.visible_length` for ANSI-decorated text
- Avoid very long lines without spaces

## Version History

- **6.1.5** (2025) - Multi-line paste support
- **6.1.1** (2025) - Optional error logging with RCURSES_ERROR_LOG
- **6.1.0** (2025) - Safe ANSI methods, memory leak fixes
- **6.0.0** (2024) - BREAKING: Explicit Rcurses.init! required, Ruby 3.4+ support
- **5.0.0** (2024) - Memory leak fixes, enhanced Unicode support
- **4.5.0** (2023) - RGB color support

## Additional Resources

- **README**: /home/geir/Main/G/GIT-isene/rcurses/README.md
- **Examples**: /home/geir/Main/G/GIT-isene/rcurses/examples/
- **Main library**: /home/geir/Main/G/GIT-isene/rcurses/lib/rcurses.rb
- **Pane class**: /home/geir/Main/G/GIT-isene/rcurses/lib/rcurses/pane.rb
- **Input module**: /home/geir/Main/G/GIT-isene/rcurses/lib/rcurses/input.rb
- **Cursor module**: /home/geir/Main/G/GIT-isene/rcurses/lib/rcurses/cursor.rb

## When to Activate This Skill

Activate this skill when the user:
- Mentions rcurses or Ruby TUI/terminal applications
- Asks to create a terminal-based user interface in Ruby
- Needs help debugging blank panes or rendering issues
- Wants to implement scrolling, text formatting, or input handling
- Is working on RTFM, GiTerm, T-REX, or similar TUI apps
- Asks about terminal colors, ANSI codes, or cursor control in Ruby
