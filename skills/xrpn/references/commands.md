# XRPN Complete Command Reference

This document provides comprehensive reference for all XRPN commands based on HP-41CX FOCAL language with XRPN extensions.

## Command Naming

- XRPN uses lowercase for commands internally
- Accepts mixed-case input for HP-41 compatibility
- Commands convert automatically (e.g., "STO" → "sto")

## Stack Operations

| Command | HP-41 | Description |
|---------|-------|-------------|
| enter | ENTER | Duplicate X into Y, lift stack |
| swap, xy | X↔Y | Exchange X and Y registers |
| rup | R↑ | Roll stack up (X→T→Z→Y→X) |
| rdn | R↓ | Roll stack down (X→Y→Z→T→X) |
| drop | DROP | Remove X, drop stack |
| dropy | - | Remove Y and Z |
| clx | CLX | Clear X register to 0 |
| clear | CLEAR | Clear entire stack to 0 |
| lastx | LASTX | Recall last X value |
| lift | - | Enable stack lift |

## Arithmetic Operations

| Command | HP-41 | Description |
|---------|-------|-------------|
| + | + | Add: Y + X |
| - | - | Subtract: Y - X |
| * | × | Multiply: Y × X |
| / | ÷ | Divide: Y ÷ X |
| pow | Y^X | Power: Y to the X |
| sqrt | √X | Square root of X |
| sqr | X² | Square of X |
| cube | - | Cube of X |
| root | X√Y | Xth root of Y |
| recip, 1/x | 1/X | Reciprocal of X |
| abs | ABS | Absolute value |
| chs | CHS | Change sign |
| mod | MOD | Modulo: Y mod X |
| fact | N! | Factorial of X |
| % | %  | Percentage: X% of Y |
| percentch | %CH | Percent change: (Y-X)/X × 100 |
| int | INT | Integer part |
| frc | FRC | Fractional part |
| rnd | RND | Round to display format |
| sign | SIGN | Sign of X (-1, 0, or 1) |

## Trigonometric Functions

| Command | HP-41 | Description |
|---------|-------|-------------|
| sin | SIN | Sine of X |
| cos | COS | Cosine of X |
| tan | TAN | Tangent of X |
| asin | ASIN | Arc sine |
| acos | ACOS | Arc cosine |
| atan | ATAN | Arc tangent |
| deg | DEG | Set degrees mode |
| rad | RAD | Set radians mode |
| grad | GRAD | Set grads mode (400°) |
| degq | DEG? | Query angle mode |
| d_r | →RAD | Convert degrees to radians |
| r_d | →DEG | Convert radians to degrees |
| p_r | →REC | Polar to rectangular |
| r_p | →POL | Rectangular to polar |

## Logarithmic & Exponential

| Command | HP-41 | Description |
|---------|-------|-------------|
| ln | LN | Natural logarithm |
| ln1x | LN1+X | ln(1+X) for small X |
| log | LOG | Base-10 logarithm |
| exp | e^X | e to the power X |
| expx1 | E^X-1 | e^X-1 for small X |
| tenx, 10^x | 10^X | 10 to the power X |
| pi | π | Load pi constant |

## Register Operations

| Command | HP-41 | Description |
|---------|-------|-------------|
| sto N | STO N | Store X to register N |
| rcl N | RCL N | Recall register N to X |
| stplus | STO+ | Add X to register |
| stsubtract | STO- | Subtract X from register |
| stmultiply | STO× | Multiply register by X |
| stdivide | STO÷ | Divide register by X |
| clrg | CLRG | Clear all registers |
| clrgx | CLRGX | Clear registers except stats |
| sto ind X | STO IND | Store using indirect addressing |
| rcl ind X | RCL IND | Recall using indirect addressing |
| regmove | - | Move registers (X=bbb.eeen format) |
| regswap | - | Swap registers (X=bbb.eeen format) |

**Register Format for regswap/regmove:**
- X register format: `bbb.eeen`
- bbb = start register
- eee = end register (3 decimals)
- n = count (4th decimal)
- Example: `1.002001` swaps register 1 with 2

## Flag Operations

| Command | HP-41 | Description |
|---------|-------|-------------|
| sf N | SF N | Set flag N |
| cf N | CF N | Clear flag N |
| fs? N | FS? N | Test if flag set (skip if false) |
| fc? N | FC? N | Test if flag clear (skip if false) |
| fsc? | FS?C | Test set then clear |
| fcc? | FC?C | Test clear then clear |
| fcs? | FC?S | Test clear then set |
| fss? | FS?S | Test set then set |
| clfl | CLFL | Clear all flags |
| invf | - | Invert all flags |
| prflags | - | Print all flags |
| rclflag | - | Recall flag to X |
| stoflag | - | Store X to flag |

## Alpha (String) Operations

| Command | HP-41 | Description |
|---------|-------|-------------|
| "text" | - | Set alpha to text |
| cla | CLA | Clear alpha |
| asto N | ASTO N | Store alpha to register |
| asto x | ASTO X | Move alpha to X register |
| arcl N | ARCL N | Append register to alpha |
| arcli | ARCL IND | Append using indirect |
| arclrec | - | Append record to alpha |
| aleng | ALENG | Alpha length to X |
| anum | ANUM | Extract first number |
| atox | ATOX | First char code to X |
| xtoa | XTOA | Append ASCII char to alpha |
| arot | AROT | Rotate alpha left (X times) |
| asub | - | Substitute first match |
| agsub | - | Substitute all matches (global) |
| aview | AVIEW | Display alpha |
| aviewc | - | Display with color code |
| pra | - | Print alpha |
| getsub | - | Extract substring |
| appchr | APPCHR | Append character |
| delchr | - | Delete character |
| apprec | - | Append record |
| delrec | - | Delete record |
| insrec | - | Insert record |
| inschr | - | Insert character |
| ashf | ASHF | Alpha shift |
| asroom | - | Alpha room available |

## Program Control

| Command | HP-41 | Description |
|---------|-------|-------------|
| lbl "NAME" | LBL "NAME" | Define label |
| gto "NAME" | GTO "NAME" | Go to label |
| gto ind X | GTO IND | Indirect goto |
| xeq "NAME" | XEQ "NAME" | Execute subroutine |
| gsb | - | Same as xeq |
| rtn | RTN | Return from subroutine |
| stop | STOP | Stop execution (debug mode) |
| end | END | End program |
| on | ON | Power on simulation |
| off | OFF | Exit XRPN |
| pse | PSE | Pause briefly |
| prompt | PROMPT | Wait for input |
| isg | ISG | Increment skip if greater |
| dse | DSE | Decrement skip if equal |
| runsw | RUNSW | Run/stop switch test |
| stopsw | STOPSW | Stop switch test |

## Conditional Tests

All conditionals skip the next line if condition is FALSE.

**Compare to Zero:**
| Command | HP-41 | Test |
|---------|-------|------|
| xeq0? | X=0? | X equals 0 |
| xneq0? | X≠0? | X not equal 0 |
| xlt0? | X<0? | X less than 0 |
| xgt0? | X>0? | X greater than 0 |
| xlteq0? | X≤0? | X less/equal 0 |
| xgteq0? | X≥0? | X greater/equal 0 |

**Compare to Y:**
| Command | HP-41 | Test |
|---------|-------|------|
| xeqy? | X=Y? | X equals Y |
| xneqy? | X≠Y? | X not equal Y |
| xlty? | X<Y? | X less than Y |
| xgty? | X>Y? | X greater than Y |
| xlteqy? | X≤Y? | X less/equal Y |
| xgteqy? | X≥Y? | X greater/equal Y |

**Compare to Number:**
Replace `nn` with number (e.g., `xeqnn?` becomes `x=5?`)
- xeqnn?, xneqnn?, xltnn?, xgtnn?, xlteqnn?, xgteqnn?

## Statistical Functions

| Command | HP-41 | Description |
|---------|-------|-------------|
| splus | Σ+ | Add data point (Y,X) |
| sminus | Σ- | Remove data point |
| mean | MEAN | Statistical mean → X,Y |
| sdev | SDEV | Standard deviation |
| cls | CLS | Clear statistics |
| sreg | ΣREG | Set stats register start |
| sregq | ΣREG? | Query stats register |
| correct | CORRECT | Correct last data point |

**Statistics Registers:**
- Default start: register 11
- Σn (count), ΣX, ΣX², ΣY, ΣY², ΣXY stored sequentially

## Display & Output

| Command | HP-41 | Description |
|---------|-------|-------------|
| fix N | FIX N | Fixed decimal places |
| sci N | SCI N | Scientific notation |
| eng N | ENG N | Engineering notation |
| fixq | FIX? | Query fix setting |
| prx | - | Print X register |
| pra | - | Print alpha |
| prstk | - | Print stack |
| prregs | - | Print all registers |
| view | VIEW | View register |
| aview | AVIEW | View alpha |
| aviewc | - | View with color |
| stdout | - | Output X to stdout (testing) |
| prp | - | Print program |
| pprg | - | Pretty print program |
| pprgx | - | Print with line numbers |
| pprgtofile | - | Export program to file |

## Date & Time Functions

| Command | HP-41 | Description |
|---------|-------|-------------|
| date | DATE | Current date |
| time | TIME | Current time |
| adate | ADATE | Formatted date to alpha |
| adateiso | - | ISO 8601 date format |
| atime | ATIME | Formatted time (12h) |
| atime24 | - | Formatted time (24h) |
| dmy | DMY | Set day-month-year format |
| mdy | MDY | Set month-day-year format |
| dateplus | DATE+ | Add days to date |
| ddate | DDAYS | Days between dates |
| dow | DOW | Day of week |
| hms | →HMS | Decimal to HMS |
| hmsplus | HMS+ | Add HMS times |
| hmsminus | HMS- | Subtract HMS times |
| hr | →HR | HMS to decimal hours |
| clock | CLOCK | Display clock |
| clk12 | CLK12 | 12-hour mode |
| clk24 | CLK24 | 24-hour mode |

## Base Conversion

| Command | HP-41 | Description |
|---------|-------|-------------|
| decbin | - | Decimal to binary |
| bindec | - | Binary to decimal |
| decoct | - | Decimal to octal |
| octdec | - | Octal to decimal |
| dechex | - | Decimal to hex (string in X) |
| hexdec | - | Hex to decimal (alpha→X) |
| dec | DEC | Set decimal mode |
| oct | OCT | Set octal mode |

**Note:** Hex conversion puts string result in X register, output via `stdout`.

## Extended Memory (XM File) Operations

XRPN implements extended memory as structured files with records.

| Command | HP-41 | Description |
|---------|-------|-------------|
| crflas | CRFLAS | Create file (all records same) |
| crfld | CRFLD | Create file (varying records) |
| emdir | EMDIR | List files |
| emdirx | - | Detailed directory |
| emroom | EMROOM | Available memory |
| flsize | FLSIZE | File size |
| open | - | Open/navigate files |
| clp | CLP | Close pointer |
| posfl | POSFL | Position in file |
| posa | POSA | Position absolutely |
| savex | SAVEX | Save X to file |
| saver | SAVER | Save registers |
| saverx | SAVERX | Save registers+X |
| getx | GETX | Get X from file |
| getr | GETR | Get registers |
| getrx | GETRX | Get registers+X |
| getas | GETAS | Get to alpha |
| getp | GETP | Get program |
| savep | SAVEP | Save program |
| getrec | GETREC | Get record |
| insrec | INSREC | Insert record |
| delrec | DELREC | Delete record |
| seekpt | SEEKPT | Seek pointer |
| seekpta | SEEKPTA | Seek pointer absolute |
| rclpt | RCLPT | Recall pointer |
| rclpta | RCLPTA | Recall pointer absolute |
| purfl | PURFL | Purge file |
| reszfl | RESZFL | Resize file |
| size | SIZE | Set register size |
| sizeq | SIZE? | Query size |
| psize | PSIZE | Program size |

## File System Operations (XRPN Extensions)

| Command | Description |
|---------|-------------|
| open | Navigate file system / open files |
| copy | Copy file |
| move | Move file |
| writefile | Write alpha to file |
| getfile | Read file to alpha |
| getfilea | Read file and append to alpha |
| pprgtofile | Export program to text file |
| xmexist? | Check if XM file exists |
| xmfileq | Query current XM file |

## Program Management

| Command | HP-41 | Description |
|---------|-------|-------------|
| lbl "NAME" | LBL "NAME" | Define global label |
| lbl NN | LBL NN | Define numeric label (00-99) |
| page | PAGE | Switch to page |
| pageq | PAGE? | Query current page |
| pagedel | - | Delete page |
| lastpage | - | Get last page index |
| pageswap | - | Swap two pages |
| pcat | PCAT | Catalog programs |
| pclps | PCLPS | Catalog with checksum |
| pack | PACK | Compact program memory |
| load | - | Load program file |
| saveas | - | Save program as |
| cat | CAT | Catalog |

## Display Formatting

| Command | HP-41 | Description |
|---------|-------|-------------|
| fix N | FIX N | N decimal places |
| sci N | SCI N | Scientific, N digits |
| eng N | ENG N | Engineering, N digits |
| fixq | FIX? | Query fix setting |
| dot | . | Radix mark (period) |
| sep | , | Digit separator |
| cf 28/29 | CF 28/29 | Control separators |

## Self-Modification (XRPN Extensions)

| Command | Description |
|---------|-------------|
| cmdadd | Add new command at runtime |
| cmddel | Delete command |
| cmds | List all commands |
| cmdhelp | Display command help |
| rubycmd | Execute Ruby code |
| shellcmd | Execute shell command |
| getweb | Fetch web page content |

## Sound Functions

| Command | HP-41 | Description |
|---------|-------|-------------|
| beep | BEEP | Standard beep |
| tone | TONE | Play tone (X=duration, Y=freq) |
| tonexy | - | Tone with X,Y control |

## Miscellaneous

| Command | HP-41 | Description |
|---------|-------|-------------|
| rand | RAN# | Random 0-1 |
| getkey | GETKEY | Wait for keypress |
| getkeyx | - | Get key without wait |
| clkeys | CLKEYS | Clear key buffer |
| pasn | PASN | Assign key |
| ed | ED | Edit program line |
| help | - | Display help |
| version | - | Show XRPN version |
| error | ERROR | Trigger error handler |
| unerror | - | Clear error state |

## HP-41 RAW File Support (XRPN v2.6+)

| Command | Description |
|---------|-------------|
| rawinfo | Display RAW file info (filename in alpha) |

**RAW File Format:**
- Binary HP-41 program files
- No header/metadata (pure memory dump)
- Structure: labels + bytecodes + strings + end marker
- Can inspect thousands of HP-41 programs from hp41.org

**Usage:**
```
"/path/to/file.raw"
rawinfo
```

**Output:**
- Program labels (global/local/alpha/numeric)
- Text strings (5 encoding formats)
- Hex dump for bytecode analysis

## Regression Testing (XRPN v2.6+)

**Running Tests:**
```bash
ruby tests/run_tests.rb                    # All tests
ruby tests/run_tests.rb tests/specs/FILE   # Specific category
```

**Test Categories (58 total tests):**
1. Basic arithmetic (16 tests)
2. Stack operations (8 tests)
3. Trigonometry (8 tests)
4. Logarithms (6 tests)
5. Registers (10 tests)
6. Alpha strings (5 tests)
7. Base conversion (5 tests)

## Special System Flags

| Flag | Function |
|------|----------|
| 28 | Radix mark (set=comma, clear=period) |
| 29 | Digit separator |
| 31 | Date format (set=DMY, clear=MDY) |
| 44 | Continuous ON mode |

## Configuration Files

**User Config:** `~/.xrpn/conf`
```ruby
$theme = "dark"      # or "light"
# Custom settings
```

**Custom Theme:** `~/.xrpn/theme`
- Override default color scheme
- 256-color terminal support

## Command Execution Modes

1. **File mode:** `xrpn -f program.xrpn`
2. **Execute string:** `xrpn -e "5,3,+,prx"`
3. **Pipe mode:** `echo "1,2,+,stdout,off" | xrpn`
4. **Debug mode:** `xrpn` (interactive)
5. **Load without run:** `xrpn -l program.xrpn`

## Important Implementation Notes

### Stack Lift Behavior
- Most operations lift stack before entering value
- Some operations disable lift (@nolift flag)
- `lastx` preserves previous X value

### Indirect Addressing
- Uses register value as target
- Works with: STO, RCL, SF, CF, FS?, FC?, GTO, XEQ
- Format: `command IND register`

### Number Entry
- Supports scientific notation
- European format: comma decimal separator
- Range: BigDecimal for arbitrary precision

### String Handling
- Alpha register: main string storage
- Registers can store strings (via ASTO)
- ARCL appends numeric registers as strings
- Maximum length varies by implementation

### Error Handling (v2.5+)
- Division by zero: handled gracefully
- Nil registers: default to 0
- Statistics on empty data: returns error
- File operations: error messages vs crashes

## Version History

**v2.6 (Latest):**
- Regression test framework (58 tests, 100% pass rate)
- HP-41 RAW file viewer (RAWINFO command)
- Test infrastructure with YAML specifications

**v2.5:**
- Fixed division by zero crashes
- Fixed nil reference errors
- Memory leak fixes
- Performance optimizations

**v2.4:**
- Fixed file loading via -f switch
