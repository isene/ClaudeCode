#!/bin/bash

# Create 8-minute version by removing silence from Symphony of the North
# Uses sox silence detection and removal

echo "=============================================================="
echo "Creating 8-Minute Version for Suno Upload"
echo "=============================================================="
echo ""

# Source file
SOURCE="Symphony_of_the_North_PROFESSIONAL.mp3"

if [ ! -f "$SOURCE" ]; then
    echo "Error: Source file not found: $SOURCE"
    exit 1
fi

echo "Source file: $SOURCE"
soxi "$SOURCE" | grep Duration
echo ""

# Create temp directory
mkdir -p temp_8min
cd temp_8min

echo "Step 1: Converting MP3 to WAV for processing..."
sox "../$SOURCE" symphony_full.wav

echo ""
echo "Step 2: Removing silence (threshold: 1%, min duration: 1 second)..."
echo "  This removes silent sections within and between movements..."

# Remove silence:
# - above-periods: Keep audio if there's sound for at least 0.3 seconds
# - below-periods: Remove silence if it lasts at least 1 second
# - threshold: 1% = very quiet passages kept, true silence removed
sox symphony_full.wav symphony_no_silence.wav \
    silence -l 1 0.3 1% -1 1.0 1%

echo ""
echo "Step 3: Checking new duration..."
NEW_DURATION=$(soxi -D symphony_no_silence.wav)
NEW_MINUTES=$(echo "$NEW_DURATION / 60" | bc)
NEW_SECONDS=$(echo "$NEW_DURATION % 60" | bc)

echo "  Original: 9:01"
echo "  New duration: ${NEW_MINUTES}m ${NEW_SECONDS}s"

# Check if still over 8 minutes
if (( $(echo "$NEW_DURATION > 480" | bc -l) )); then
    echo ""
    echo "  ! Still over 8 minutes (${NEW_MINUTES}m ${NEW_SECONDS}s)"
    echo "  Applying time compression to fit exactly 8:00..."

    # Calculate tempo factor to compress to exactly 480 seconds (8 minutes)
    TEMPO_FACTOR=$(echo "scale=4; $NEW_DURATION / 480" | bc)

    echo "  Tempo factor: ${TEMPO_FACTOR}x (${TEMPO_FACTOR} = subtle speedup)"

    sox symphony_no_silence.wav symphony_8min.wav tempo $TEMPO_FACTOR
else
    echo "  ✓ Under 8 minutes! No tempo adjustment needed."
    cp symphony_no_silence.wav symphony_8min.wav
fi

echo ""
echo "Step 4: Final normalization..."
sox symphony_8min.wav symphony_8min_normalized.wav norm -1

echo ""
echo "Step 5: Converting to MP3 (320kbps for Suno)..."
lame -b 320 symphony_8min_normalized.wav ../Symphony_of_the_North_8MIN.mp3 2>/dev/null

cd ..
rm -rf temp_8min

echo ""
echo "=============================================================="
echo "COMPLETE!"
echo "=============================================================="
echo ""
echo "Created: Symphony_of_the_North_8MIN.mp3"
echo ""

soxi Symphony_of_the_North_8MIN.mp3

FINAL_DURATION=$(soxi -D Symphony_of_the_North_8MIN.mp3)
FINAL_MINUTES=$(echo "$FINAL_DURATION / 60" | bc)
FINAL_SECONDS=$(echo "$FINAL_DURATION % 60" | bc)

echo ""
echo "Final duration: ${FINAL_MINUTES}:${FINAL_SECONDS} (exactly 8:00 or under)"
echo "File size: $(ls -lh Symphony_of_the_North_8MIN.mp3 | awk '{print $5}')"
echo ""
echo "Ready to upload to Suno!"
echo ""
