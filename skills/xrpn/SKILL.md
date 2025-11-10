---
name: xrpn
description: Expert knowledge of XRPN stack-based programming language, HP-41 FOCAL compatibility, command syntax, testing framework, and HP-41 RAW file format. Activate when working with XRPN code, HP-41 programs, RPN calculations, or when user mentions XRPN, HP-41, FOCAL, or stack-based programming.
---

# XRPN Programming Language Expert

## Overview

XRPN is a stack-based programming language (similar to Forth) that extends HP-41CX calculator FOCAL language with modern features. It provides:
- Full HP-41CX command compatibility (250+ functions)
- Reverse Polish Notation for calculations
- Self-modification and on-the-fly extensibility
- Modern features: web fetching, regexp, file manipulation, Ruby integration

## When to Use This Skill

Activate this skill when:
- User mentions XRPN, HP-41, FOCAL, or RPN programming
- Working with `.xrpn` program files
- Debugging stack-based calculations
- Creating or modifying XRPN programs
- Testing XRPN commands with the regression framework
- Inspecting HP-41 RAW format files
- Converting HP-41 programs to XRPN

## Core Architecture

### Repository Structure
```
/home/geir/Main/G/GIT-isene/xrpn/
├── bin/xrpn              # Main executable
├── xcmd/                 # Command definitions (250+ files)
├── xlib/                 # Library functions
├── tests/                # Regression test framework
│   ├── run_tests.rb     # Test runner
│   └── specs/*.yml      # YAML test specifications
├── data/                 # Data files
├── extra/               # Extra utilities
└── print/               # Print templates
```

### Command System
- Commands loaded dynamically from `/xcmd/` directory
- Each command is a Ruby method in XRPN class
- Commands can be added/modified at runtime via `cmdadd`/`cmddel`
- User commands in `~/.xrpn/xcmd/` override gem commands

### XRPN Class Structure
```ruby
class XRPN
  @x, @y, @z, @t    # Stack registers (T, Z, Y, X)
  @a                # Alpha register (string)
  @l                # Last X register
  @reg              # Numbered registers (Hash)
  @flg              # Flags (Hash)
  @prg              # Programs by page
  @pc               # Program counter
  @pg               # Current page
end
```

## Command Reference

Complete command documentation is in `references/commands.md`. Key categories:

### Stack Operations
- `enter` - Duplicate X register
- `swap` / `xy` - Exchange X and Y
- `rup` / `rdn` - Rotate stack up/down
- `drop` / `dropy` - Remove register(s)
- `clear` - Clear entire stack
- `lastx` - Recall last X value

### Arithmetic
- `+`, `-`, `*`, `/` - Basic operations
- `pow` - Y^X
- `sqrt`, `sqr`, `cube` - Powers
- `abs`, `chs` - Absolute value, change sign
- `mod` - Modulo
- `fact` - Factorial
- `%` - Percentage

### Registers
- `sto N` - Store to register N
- `rcl N` - Recall from register N
- `st+`, `st-`, `st*`, `st/` - Arithmetic operations on registers
- `sto ind X` - Indirect addressing (register number in X)
- `regswap` - Swap registers (X format: `bbb.eeen`)
- `regmove` - Move registers (X format: `bbb.eeen`)

### Alpha (String) Operations
- `"text"` - Set alpha to text
- `asto x` - Move alpha to X register (for stdout)
- `asto N` - Store alpha to register N
- `arcl N` - Append register to alpha
- `aleng` - Get alpha length (to X)
- `arot` - Rotate alpha left (X = rotation count)
- `xtoa` - Convert X to ASCII character in alpha
- `cla` - Clear alpha

### Program Control
- `lbl "NAME"` - Define label
- `gto "NAME"` - Jump to label
- `xeq "NAME"` / `gsb` - Call subroutine
- `rtn` - Return from subroutine
- `stop` - Halt (enter debug mode)
- `end` - End program

### Conditionals
All skip next instruction if condition is false:
- `x=0?`, `x!=0?`, `x<0?`, `x>0?`, `x<=0?`, `x>=0?`
- `x=y?`, `x!=y?`, `x<y?`, `x>y?`, `x<=y?`, `x>=y?`
- `fs? N`, `fc? N` - Test flag N

### Statistics
- `splus` - Add data point (Σ+)
- `sminus` - Remove data point (Σ-)
- `mean` - Calculate mean
- `sdev` - Standard deviation
- `cls` - Clear statistics

### Base Conversion
- `decbin` / `bindec` - Decimal ↔ Binary
- `decoct` / `octdec` - Decimal ↔ Octal
- `dechex` / `hexdec` - Decimal ↔ Hexadecimal (returns string in X)

### HP-41 RAW File Support
- `rawinfo` - Display info about RAW file (filename in alpha)

## Testing Framework

### Running Tests
```bash
# Run all tests
ruby tests/run_tests.rb

# Run specific category
ruby tests/run_tests.rb tests/specs/01_basic_arithmetic.yml
```

### Test Specification Format (YAML)
```yaml
- name: "Addition: 5 + 3 = 8"
  commands:
    - "5"
    - "3"
    - "+"
  expected:
    x: 8

- name: "With setup"
  setup:
    - "clrg"      # Setup runs first
  commands:
    - "42"
    - "sto 10"
  expected:
    x: 42
```

### Test Validation Types
- `expected.x` - Numeric value in X register
- `expected.alpha` - String value (uses `asto x` then stdout)
- `expected.x_string` - String in X register (like dechex output)
- `expected.tolerance` - Acceptable error (default: 0.0001)
- `should_error` - Test should produce error

### Adding New Tests
1. Create YAML file in `tests/specs/`
2. Define test cases with commands and expected results
3. Run test suite to verify
4. Tests use piping: `echo "cmd1,cmd2,stdout,off" | xrpn`

## Development Workflow

### Creating New Commands
1. Create file in `xcmd/CMDNAME`
2. Define method in XRPN class:
```ruby
class XRPN
  def mycommand
    # Implementation
  end
end
```
3. Command auto-loads via `read_xcmd` function

### Command Naming Conventions
- Lowercase for internal functions
- No spaces or special chars
- Short but descriptive
- HP-41 compatibility names preserved

### Testing New Features
1. Write test specification first (TDD)
2. Run tests to see failure
3. Implement feature
4. Run tests to verify
5. Commit feature + tests together

### Register Format for regswap/regmove
Special format in X register: `bbb.eeen`
- `bbb` = start register (integer part)
- `eee` = end register (3 decimals after point)
- `n` = count (4th decimal)
- Example: `1.002001` = swap reg 1 with reg 2, count=1

## HP-41 RAW File Format

### Structure
- `C0 00 F4/F5 00` - Global label (F4=alpha, F5=numeric)
- `F6 00` - Local label
- Label name in ASCII
- HP-41 bytecodes
- `C0 xx 2F` - End marker

### String Encoding Formats
- `FD TEXT` - String literals
- `F3 TEXT` - String format 2
- `F8 TEXT` - String format 3
- `FB TEXT` - String format 4
- `7F 20 TEXT` - String format 5

### Using RAWINFO Command
```
xrpn
> "/path/to/program.raw"
> rawinfo
```

Output shows:
- All labels (global/local/alpha/numeric)
- Text strings extracted from program
- Hex dump for manual bytecode analysis

### Known Bytecodes
- `A7` - RCL (recall)
- `B2` - STO (store)
- `82` - + (add)
- `83` - - (subtract)
- `84` - * (multiply)
- `85` - / (divide)
- `88` - ENTER
- `8E` - PROMPT
- `9B` - VIEW/AVIEW

## Important Implementation Details

### stdout Command
- Outputs X register value to stdout (without debug mode display)
- Used by test framework for validation
- Works with both numeric and string values in X

### off Command
- Exits XRPN cleanly without entering debug mode
- Essential for automated testing
- Usage: `echo "cmd1,cmd2,stdout,off" | xrpn`

### Alpha to X Transfer
- `asto x` - Moves alpha register content to X register
- Enables string validation via stdout
- Overwrites previous X value

### European Number Format
- Default: comma as decimal separator (8,0000)
- Tests convert: `output.gsub(',', '.')` before validation

### Indirect Addressing
- `sto ind X` - Stores to register number in X
- `rcl ind X` - Recalls from register number in X
- Handles nil register values gracefully (v2.5+)

## Common Patterns

### Simple Calculation
```
5
3
+
prx          # Prints "X = 8,0000"
```

### Using Registers
```
42
sto 10       # Store 42 to register 10
clx          # Clear X
rcl 10       # Recall from register 10
```

### String Manipulation
```
"Hello"      # Set alpha
asto 01      # Store to register 01
cla          # Clear alpha
arcl 01      # Append register to alpha
aview        # Display alpha
```

### Program Structure
```
LBL "MAIN"
  42
  sto 00
  gto "CALC"
END

LBL "CALC"
  rcl 00
  2
  *
  prx
END
```

### Conditional Logic
```
5
x>0?
"Positive"
aview
```

## Troubleshooting

### Tests Hanging
- Ensure programs end with `off` command
- Check for infinite loops
- Use timeout when testing manually

### Division by Zero
- v2.5+ handles gracefully (no crash)
- Returns large/infinity value

### Register Nil Values
- v2.5+ handles nil gracefully in indirect addressing
- Empty registers default to 0

### Command Not Found
- Check spelling (case-insensitive)
- Verify in `/xcmd/` or `~/.xrpn/xcmd/`
- Use `cmds` to list all available commands

## Ruby Gem Management

### Version Locations
- `xrpn.gemspec:3` - s.version
- `xlib/_xrpn_version:2` - Display string

### Release Process
1. Update versions in both files
2. Update README changelog
3. Commit changes
4. Build: `gem build xrpn.gemspec`
5. Push: `gem push xrpn-X.Y.gem`
6. Tag: `git tag X.Y && git push --tags`

## References

For complete command documentation, see `references/commands.md` (generated from wiki).

For regression testing details, see `/tests/README.md` in the repository.
