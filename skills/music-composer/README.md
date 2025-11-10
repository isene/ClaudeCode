# Music Composer Skill

Professional orchestral composition skill for Claude Code.

## Overview

This skill provides complete orchestral music composition capabilities:
- Compose from scratch based on text descriptions
- Professional LilyPond notation
- High-quality audio production
- Iterative refinement workflow
- Export for Suno and other platforms

## Directory Structure

```
music-composer/
├── skill.md                    # Main skill definition (Claude reads this)
├── README.md                   # This file
├── scripts/                    # Automation scripts
│   ├── compose_piece.sh        # Main workflow orchestrator
│   ├── produce_audio.sh        # Audio production pipeline
│   ├── add_midi_instruments.sh # MIDI instrument fixer
│   └── create_8min_version.sh  # 8-minute version for Suno
├── templates/                  # LilyPond templates
│   └── basic_piece.ly          # Basic composition template
├── tools/                      # Helper tools and references
│   └── quick_reference.md      # Quick command reference
└── examples/                   # Example compositions
    └── (link to Symphony of the North)
```

## Quick Start

### Activate the Skill

In Claude Code, simply say:
- "Create music"
- "Compose a piece"
- "Use music-composer skill"

### Workflow

1. **Describe what you want:**
   - Mood, style, instrumentation
   - Duration, key, tempo
   - Specific inspirations

2. **Claude composes:**
   - Writes LilyPond notation
   - Compiles to scores and MIDI
   - Produces professional audio

3. **You review:**
   - Listen to MP3
   - Read PDF score
   - Provide feedback

4. **Iterate:**
   - Request changes
   - Claude modifies and regenerates
   - Repeat until satisfied

5. **Export:**
   - Final score PDF
   - Professional MP3
   - 8-minute version for Suno

## Scripts

### Main Workflow
```bash
~/.claude/skills/music-composer/scripts/compose_piece.sh /path/to/project
```
Runs complete workflow: compile → MIDI → audio → MP3

### Audio Production Only
```bash
~/.claude/skills/music-composer/scripts/produce_audio.sh /path/to/project
```
Skips LilyPond compilation, just produces audio from existing MIDI

### 8-Minute Version
```bash
cd /path/to/project
~/.claude/skills/music-composer/scripts/create_8min_version.sh
```
Creates Suno-ready 8-minute version

## Templates

Basic composition template available at:
`~/.claude/skills/music-composer/templates/basic_piece.ly`

Shows structure for:
- Headers and metadata
- Instrument definition with MIDI
- Proper layout settings
- Score and MIDI generation

## Requirements

Installed via:
```bash
sudo apt install lilypond fluidsynth fluid-soundfont-gm sox lame poppler-utils
```

## Examples

Symphony of the North is the reference example:
- Location: `/home/geir/Claude/SymphonyOfNorth/`
- 4-movement symphony
- Full orchestra
- Professional score and audio
- Demonstrates complete workflow

## Technical Details

**LilyPond:** Music notation and compilation
**FluidSynth:** High-quality MIDI synthesis
**SoX:** Audio processing and mastering
**LAME:** MP3 encoding
**Python:** Automation scripts

**Quality:**
- FluidR3_GM soundfont (professional samples)
- Cathedral reverb
- Professional mastering chain
- 320kbps MP3 output

## Support

- Full skill definition: `skill.md`
- Quick reference: `tools/quick_reference.md`
- Example: `/home/geir/Claude/SymphonyOfNorth/`

## Version

1.0.0 - Initial release with complete composition workflow

## Credits

Created for Geir Isene with Claude Code (Anthropic)
Based on Symphony of the North composition workflow
