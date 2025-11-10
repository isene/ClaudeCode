#!/bin/bash

# Symphony Audio Production Pipeline
# Usage: produce_audio.sh <symphony_output_dir>

if [ $# -lt 1 ]; then
    echo "Usage: $0 <symphony_output_dir>"
    exit 1
fi

OUTPUT_DIR="$1"
SCORES_DIR="$OUTPUT_DIR/scores"
AUDIO_DIR="$OUTPUT_DIR/audio"

echo "=============================================================="
echo "SYMPHONY AUDIO PRODUCTION"
echo "=============================================================="
echo ""
echo "Output directory: $OUTPUT_DIR"
echo ""

# Check for required tools
command -v fluidsynth >/dev/null 2>&1 || { echo "Error: fluidsynth not found."; exit 1; }
command -v sox >/dev/null 2>&1 || { echo "Error: sox not found."; exit 1; }
command -v lame >/dev/null 2>&1 || { echo "Error: lame not found."; exit 1; }

# Set soundfont
SOUNDFONT="/usr/share/sounds/sf2/FluidR3_GM.sf2"
if [ ! -f "$SOUNDFONT" ]; then
    SOUNDFONT="/usr/share/sounds/sf2/default.sf2"
fi

if [ ! -f "$SOUNDFONT" ]; then
    echo "Error: No soundfont found."
    exit 1
fi

echo "Using soundfont: $SOUNDFONT"
echo ""

# Create temp directory
mkdir -p "$AUDIO_DIR/temp"
cd "$AUDIO_DIR/temp"

echo "=============================================================="
echo "STEP 1: Rendering MIDI to WAV with FluidSynth"
echo "=============================================================="
echo ""

# Find all MIDI files
MIDI_FILES=($(find "$SCORES_DIR" -name "symphony_movement*.midi" | sort))
MOVEMENT_COUNT=${#MIDI_FILES[@]}

echo "Found $MOVEMENT_COUNT movements"
echo ""

for i in "${!MIDI_FILES[@]}"; do
    mov_num=$((i+1))
    midi_file="${MIDI_FILES[$i]}"
    echo "[$mov_num/$MOVEMENT_COUNT] Movement $mov_num..."
    fluidsynth -ni -g 1.2 -F "mov${mov_num}_raw.wav" "$SOUNDFONT" "$midi_file" 2>/dev/null
    echo "  ✓ Complete"
done

echo ""
echo "=============================================================="
echo "STEP 2: Adding Reverb"
echo "=============================================================="
echo ""

for i in $(seq 1 $MOVEMENT_COUNT); do
    echo "Movement $i: Adding reverb..."
    sox "mov${i}_raw.wav" "mov${i}_reverb.wav" reverb 50 50 100 100 0 0
done

echo ""
echo "=============================================================="
echo "STEP 3: Mastering"
echo "=============================================================="
echo ""

for i in $(seq 1 $MOVEMENT_COUNT); do
    echo "Movement $i: Mastering..."
    sox "mov${i}_reverb.wav" "mov${i}_master.wav" \
        highpass 30 \
        compand 0.3,1 6:-70,-60,-20 -5 -90 0.2 \
        norm -1
done

echo ""
echo "=============================================================="
echo "STEP 4: Combining Movements"
echo "=============================================================="
echo ""

# Create silence
sox -n -r 44100 -c 2 silence.wav trim 0.0 3.0

# Build combination command
COMBINE_CMD="sox"
for i in $(seq 1 $MOVEMENT_COUNT); do
    COMBINE_CMD="$COMBINE_CMD mov${i}_master.wav"
    if [ $i -lt $MOVEMENT_COUNT ]; then
        COMBINE_CMD="$COMBINE_CMD silence.wav"
    fi
done
COMBINE_CMD="$COMBINE_CMD ../symphony_combined.wav"

eval $COMBINE_CMD

echo ""
echo "=============================================================="
echo "STEP 5: Final Mastering and MP3 Export"
echo "=============================================================="
echo ""

echo "Final mastering..."
sox ../symphony_combined.wav ../symphony_final.wav \
    norm -0.5 \
    compand 0.05,0.2 6:-70,-60,-20 -3 -90 0.1

echo "Converting to MP3..."
# Get symphony name from directory
SYMPHONY_NAME=$(basename "$OUTPUT_DIR")
lame -b 320 --preset insane ../symphony_final.wav "../../${SYMPHONY_NAME}_PROFESSIONAL.mp3" 2>/dev/null

echo ""
echo "=============================================================="
echo "STEP 6: Cleanup"
echo "=============================================================="
echo ""

cd ../..
rm -rf "$AUDIO_DIR/temp"

echo "✓ Temporary files removed"

echo ""
echo "=============================================================="
echo "AUDIO PRODUCTION COMPLETE!"
echo "=============================================================="
echo ""
echo "Created: ${SYMPHONY_NAME}_PROFESSIONAL.mp3"
echo ""

ls -lh "${SYMPHONY_NAME}_PROFESSIONAL.mp3"

echo ""
