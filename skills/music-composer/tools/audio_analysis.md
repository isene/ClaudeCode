# Audio Analysis for Transcription

## Overview

Tools for analyzing audio and extracting musical information for transcription to score.

**Installed Tools:**
- `aubio-tools` - Command-line audio analysis
- `sonic-visualiser` - Visual audio analysis (GUI)

## Aubio Tools

### Extract Notes (Pitch + Timing)

```bash
aubionotes -i input.wav -o notes.txt
```

**Output format:** `time(s) pitch(MIDI) velocity`

Example:
```
0.348980 69 0.815842
0.488435 71 0.823529
0.627891 72 0.801471
```

**MIDI to Note Conversion:**
- 60 = C4 (Middle C)
- 69 = A4 (440 Hz)
- Each semitone = +1

### Extract Tempo

```bash
aubiotempo -i input.wav
```

**Output:** BPM value

Example:
```
120.000000
```

### Extract Onset Times

```bash
aubioonset -i input.wav -o onset.txt
```

**Output:** Time stamps when notes start

Example:
```
0.348980
0.488435
0.627891
```

### Analyze Pitch Track

```bash
aubiopitch -i input.wav -o pitch.txt
```

**Output:** Continuous pitch contour

## Sonic Visualiser

Visual analysis tool with spectrogram, waveform, and plugin support.

### Launch

```bash
sonic-visualiser input.wav
```

### Useful Features

**Waveform View:**
- See overall structure
- Identify sections
- Find silence/pauses

**Spectrogram:**
- Visual representation of frequencies
- Identify harmonic content
- See melody lines

**Add Layers:**
- Melodic Range Spectrogram
- Peak Frequency Spectrogram
- Notes (via vamp plugins)

## Automated Stem Analysis

For analyzing multiple stems at once:

```bash
~/.claude/skills/music-composer/scripts/analyze_stems.sh /path/to/stems/
```

Creates `analysis/` directory with:
- `[stem]_notes.txt` - Detected pitches per stem
- `[stem]_onset.txt` - Note onsets per stem
- `tempo.txt` - Detected tempo
- `analysis_summary.txt` - Overview

## Working with Stems

### Best Practice Workflow

1. **Export stems from Suno** (or other source):
   - strings.wav
   - brass.wav
   - woodwinds.wav
   - percussion.wav

2. **Analyze each stem:**
   ```bash
   cd ~/Claude/Music/MyPiece
   mkdir stems
   # Copy stems to stems/
   ~/.claude/skills/music-composer/scripts/analyze_stems.sh stems/
   ```

3. **Review analysis:**
   ```bash
   cd stems/analysis
   cat analysis_summary.txt
   cat strings_notes.txt
   ```

4. **Transcribe to LilyPond:**
   - Use detected pitches as guide
   - Use onset times for rhythm
   - Manually refine and correct
   - Add dynamics, articulations
   - Ensure musical sense

## MIDI Note Numbers

Common orchestral ranges in MIDI numbers:

**Strings:**
- Violin: 55 (G3) - 103 (G7)
- Viola: 48 (C3) - 91 (G6)
- Cello: 36 (C2) - 84 (C6)
- Contrabass: 28 (E1) - 67 (G4)

**Woodwinds:**
- Flute: 60 (C4) - 96 (C7)
- Oboe: 58 (Bb3) - 93 (A6)
- Clarinet: 50 (D3) - 94 (Bb6)

**Brass:**
- Trumpet: 55 (G3) - 82 (Bb5)
- Horn: 34 (Bb1) - 77 (F5)
- Trombone: 40 (E2) - 72 (C5)

## Converting MIDI to LilyPond Pitch

Quick reference:

```
MIDI 60 (C4)  = c'    (Middle C)
MIDI 61 (C#4) = cis'
MIDI 62 (D4)  = d'
MIDI 69 (A4)  = a'    (440 Hz)
MIDI 72 (C5)  = c''
MIDI 84 (C6)  = c'''
```

**LilyPond octaves:**
- `c` = C3 (below middle C)
- `c'` = C4 (middle C)
- `c''` = C5
- `c'''` = C6

## Limitations to Keep in Mind

**Aubio accuracy:**
- ~70-80% for single melodic lines
- ~50-60% for polyphonic music
- Better with stems than mixed audio
- Struggles with:
  - Complex harmonies
  - Fast passages
  - Subtle ornaments
  - Reverb-heavy audio

**Always verify and refine:**
- Use aubio as starting point
- Listen carefully and correct
- Consider musical context
- Make idiomatic for instruments

## Example: Transcribing String Stem

```bash
# 1. Extract notes
aubionotes -i strings.wav -o strings_notes.txt

# 2. Review detected notes
head strings_notes.txt
# 0.348980 69 0.815842  <- time=0.35s, A4, velocity=0.82
# 0.488435 71 0.823529  <- time=0.49s, B4, velocity=0.82

# 3. Convert to LilyPond
# MIDI 69 = A4 = a'
# MIDI 71 = B4 = b'

# 4. Determine rhythm from timing
# 0.488 - 0.349 = 0.139s apart
# At 120 BPM: quarter note = 0.5s
# 0.139s ≈ sixteenth note

# 5. Write LilyPond
\relative c'' {
  a'16 b ...
}

# 6. Compile and compare with original
```

## Tips for Better Results

**Prepare audio:**
- Use highest quality stems available
- Normalize volume if too quiet
- Remove excess silence at start/end

**Analysis strategy:**
- Start with simplest stem (melody)
- Analyze complex stems last
- Cross-reference between stems

**Transcription approach:**
- Focus on main themes first
- Add harmony and inner voices later
- Don't trust aubio blindly - use ears!

**Verification:**
- Compile and render frequently
- A/B compare with original
- Iterate until satisfied
