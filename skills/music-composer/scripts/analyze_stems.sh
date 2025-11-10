#!/bin/bash

# Analyze Audio Stems for Transcription
# Uses aubio tools to extract pitch, tempo, and onset information

set -e

show_usage() {
    cat << EOF
Analyze Stems - Audio Analysis for Transcription

Usage: $0 <stems_directory>

This script analyzes audio stems (separated instrument tracks) and extracts:
- Pitch information (notes detected)
- Tempo
- Onset times (when notes start)

Input:
  stems_directory   Directory containing stem WAV files

Output:
  Creates analysis/ subdirectory with:
  - [stem]_notes.txt    - Detected pitches and timings
  - [stem]_onset.txt    - Note onset times
  - tempo.txt           - Detected tempo
  - analysis_summary.txt - Overview of findings

Example:
  $0 ~/Claude/Music/MyPiece/stems

Expected stem files:
  - strings.wav
  - brass.wav
  - woodwinds.wav
  - percussion.wav
  (or any WAV files in the directory)

EOF
}

if [ $# -lt 1 ]; then
    show_usage
    exit 1
fi

STEMS_DIR="$1"

if [ ! -d "$STEMS_DIR" ]; then
    echo "Error: Directory not found: $STEMS_DIR"
    exit 1
fi

# Check for aubio tools
if ! command -v aubionotes &> /dev/null; then
    echo "Error: aubio-tools not installed"
    echo "Install with: sudo apt install aubio-tools"
    exit 1
fi

echo "=============================================================="
echo "ANALYZING AUDIO STEMS FOR TRANSCRIPTION"
echo "=============================================================="
echo ""
echo "Stems directory: $STEMS_DIR"
echo ""

cd "$STEMS_DIR"

# Create analysis directory
mkdir -p analysis
cd analysis

echo "Step 1: Detecting tempo from first available WAV..."
echo "------------------------------------------------------------"

FIRST_WAV=$(find .. -maxdepth 1 -name "*.wav" | head -1)

if [ -z "$FIRST_WAV" ]; then
    echo "Error: No WAV files found in $STEMS_DIR"
    exit 1
fi

aubiotempo -i "$FIRST_WAV" > tempo.txt 2>/dev/null
TEMPO=$(cat tempo.txt | head -1 | awk '{print $1}')

echo "Detected tempo: ${TEMPO} BPM"
echo ""

echo "Step 2: Analyzing pitch and rhythm for each stem..."
echo "------------------------------------------------------------"

STEM_COUNT=0

for wav_file in ../*.wav; do
    if [ -f "$wav_file" ]; then
        STEM_COUNT=$((STEM_COUNT + 1))
        basename=$(basename "$wav_file" .wav)

        echo "  [$STEM_COUNT] Analyzing: $basename"

        # Extract notes (pitch + timing)
        aubionotes -i "$wav_file" -o "${basename}_notes.txt" 2>/dev/null

        # Extract onsets (when notes start)
        aubioonset -i "$wav_file" -o "${basename}_onset.txt" 2>/dev/null

        # Count detected notes
        NOTE_COUNT=$(wc -l < "${basename}_notes.txt")
        echo "      Detected notes: $NOTE_COUNT"
    fi
done

echo ""
echo "Step 3: Creating analysis summary..."
echo "------------------------------------------------------------"

cat > analysis_summary.txt << EOF
AUDIO STEM ANALYSIS SUMMARY
Generated: $(date)

==============================================================
TEMPO
==============================================================
Detected: ${TEMPO} BPM
Source: $FIRST_WAV

==============================================================
STEMS ANALYZED
==============================================================

EOF

for wav_file in ../*.wav; do
    if [ -f "$wav_file" ]; then
        basename=$(basename "$wav_file" .wav)
        NOTE_COUNT=$(wc -l < "${basename}_notes.txt")
        ONSET_COUNT=$(wc -l < "${basename}_onset.txt")
        DURATION=$(soxi -D "$wav_file" 2>/dev/null)

        cat >> analysis_summary.txt << STEM_EOF
Stem: $basename
  File: $(basename "$wav_file")
  Duration: ${DURATION}s
  Notes detected: $NOTE_COUNT
  Onsets detected: $ONSET_COUNT
  Output files:
    - ${basename}_notes.txt
    - ${basename}_onset.txt

STEM_EOF
    fi
done

cat >> analysis_summary.txt << EOF

==============================================================
NEXT STEPS FOR TRANSCRIPTION
==============================================================

1. Review each *_notes.txt file for detected pitches
   Format: time(s) pitch(MIDI) velocity

2. Use detected tempo ($TEMPO BPM) as starting point

3. Manually create LilyPond notation based on:
   - Detected pitches (may need correction)
   - Onset times for rhythm
   - Musical context and phrasing

4. Remember: aubio provides approximations
   - Expect 70-80% accuracy
   - Manual refinement essential
   - Use as guide, not final truth

5. Compare rendered audio with original stems
   - Iterate until match

==============================================================
FILES IN THIS DIRECTORY
==============================================================

$(ls -1)

==============================================================
EOF

echo ""
echo "✓ Analysis complete"
echo ""
echo "=============================================================="
echo "RESULTS"
echo "=============================================================="
echo ""

cat analysis_summary.txt

echo ""
echo "All analysis files saved to: $STEMS_DIR/analysis/"
echo ""
echo "Next: Review *_notes.txt files to begin transcription"
echo ""
