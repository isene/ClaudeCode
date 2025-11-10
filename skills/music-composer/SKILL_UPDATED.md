# Music Composer Skill - Updated with Audio Analysis

## New Capabilities Added

### Audio-to-Score Transcription Support

The skill now includes tools and workflows for transcribing audio back to sheet music.

## What Was Added

### 1. Installed Tools
- ✓ `aubio-tools` - Command-line audio analysis
  - `aubionotes` - Extract pitch and timing
  - `aubiotempo` - Detect tempo
  - `aubioonset` - Find note start times
  - `aubiopitch` - Track pitch contour

- ✓ `sonic-visualiser` - Visual audio analysis (GUI)
  - Spectrogram view
  - Waveform analysis
  - Plugin support

### 2. New Script
**`analyze_stems.sh`** - Automated stem analysis

Location: `~/.claude/skills/music-composer/scripts/analyze_stems.sh`

Usage:
```bash
~/.claude/skills/music-composer/scripts/analyze_stems.sh /path/to/stems/
```

Creates analysis directory with:
- `[stem]_notes.txt` - Detected pitches per stem
- `[stem]_onset.txt` - Note onset times
- `tempo.txt` - Detected tempo
- `analysis_summary.txt` - Overview report

### 3. Documentation
**`audio_analysis.md`** - Complete guide to audio transcription

Location: `~/.claude/skills/music-composer/tools/audio_analysis.md`

Includes:
- aubio command reference
- MIDI to LilyPond conversion
- Instrument ranges in MIDI numbers
- Step-by-step transcription workflow
- Tips and best practices

### 4. Updated Skill Definition
`skill.md` now includes:
- Phase 5: Audio-to-Score Transcription workflow
- Audio analysis commands
- Best practices for working with stems
- Limitations and expectations

## How to Use for Transcription

### When You Have Suno Stems

1. **Export stems from Suno:**
   - strings.wav
   - brass.wav
   - woodwinds.wav
   - percussion.wav

2. **Place in project:**
   ```bash
   mkdir -p ~/Claude/Music/MyPiece/stems
   # Copy stems to stems/
   ```

3. **Analyze stems:**
   ```bash
   ~/.claude/skills/music-composer/scripts/analyze_stems.sh \
       ~/Claude/Music/MyPiece/stems
   ```

4. **Review results:**
   ```bash
   cd ~/Claude/Music/MyPiece/stems/analysis
   cat analysis_summary.txt
   cat strings_notes.txt
   ```

5. **Tell Claude:**
   "I have analyzed stems in ~/Claude/Music/MyPiece/stems/analysis.
   Please transcribe to LilyPond score."

6. **Claude will:**
   - Read aubio analysis files
   - Parse detected pitches and timings
   - Create LilyPond notation
   - Manually refine (aubio ~70% accurate)
   - Compile and render
   - Compare with original stems
   - Iterate until match

## Important Notes

### Expectations
- aubio gives ~70-80% accuracy for single lines
- ~50-60% for polyphonic music
- Manual refinement always required
- Best used as starting point, not final truth

### Best Results
- Use stems (separated instruments) not mixed audio
- Higher quality audio = better detection
- Simple melodies easier than complex harmonies
- Manual transcription by ear often faster/better

### When to Use Each Approach

**Use aubio analysis when:**
- You have clean stems
- Want starting point for complex piece
- Need tempo/structure verification
- Have long piece to transcribe

**Transcribe by ear when:**
- Short piece (under 2 minutes)
- Simple melody line
- Mixed audio (no stems)
- Faster to just listen and write

## Examples

### Command Examples

```bash
# Analyze single stem
aubionotes -i strings.wav -o strings_notes.txt
aubiotempo -i strings.wav

# Visual analysis
sonic-visualiser strings.wav

# Batch analyze all stems
~/.claude/skills/music-composer/scripts/analyze_stems.sh stems/
```

### aubio Output Example

```
# strings_notes.txt
0.348980 69 0.815842  # A4 at 0.35s
0.488435 71 0.823529  # B4 at 0.49s
0.627891 72 0.801471  # C5 at 0.63s
```

Converts to LilyPond:
```lilypond
\relative c'' {
  a'8 b c  % rhythm determined from timing gaps
}
```

## Updated Skill Structure

```
music-composer/
├── skill.md                       # Updated with transcription workflow
├── scripts/
│   ├── compose_piece.sh
│   ├── produce_audio.sh
│   ├── add_midi_instruments.sh
│   ├── create_8min_version.sh
│   └── analyze_stems.sh          # NEW
├── tools/
│   ├── quick_reference.md
│   └── audio_analysis.md         # NEW
└── ...
```

## Ready to Use

The skill is fully updated and ready for audio transcription workflows.

When you get stems from Suno, just say:
"I have Suno stems ready for transcription"

And I'll guide you through the analysis and transcription process!
