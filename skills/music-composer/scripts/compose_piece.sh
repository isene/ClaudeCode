#!/bin/bash

# Compose Piece - Main Workflow Script
# Handles complete composition workflow from LilyPond to final MP3

set -e

SKILL_DIR="$HOME/.claude/skills/music-composer"

show_usage() {
    cat << EOF
Compose Piece - Music Composition Workflow

Usage: $0 <project_dir> [options]

Arguments:
  project_dir       Directory containing LilyPond files

Options:
  --compile-only    Only compile LilyPond to PDF/MIDI
  --audio-only      Only produce audio (skip LilyPond compilation)
  --8min            Create 8-minute version for Suno
  --help            Show this help

Workflow:
  1. Compiles all .ly files to PDF and MIDI
  2. Adds proper MIDI instrument assignments
  3. Renders high-quality audio with FluidSynth
  4. Applies professional mastering
  5. Creates complete score PDF
  6. Exports final MP3

Example:
  $0 /home/geir/Claude/MyPiece
  $0 /home/geir/Claude/MyPiece --8min

EOF
}

if [ $# -lt 1 ]; then
    show_usage
    exit 1
fi

PROJECT_DIR="$1"
COMPILE_ONLY=false
AUDIO_ONLY=false
CREATE_8MIN=false

# Parse options
shift
while [ $# -gt 0 ]; do
    case "$1" in
        --compile-only) COMPILE_ONLY=true ;;
        --audio-only) AUDIO_ONLY=true ;;
        --8min) CREATE_8MIN=true ;;
        --help) show_usage; exit 0 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory not found: $PROJECT_DIR"
    exit 1
fi

PROJECT_NAME=$(basename "$PROJECT_DIR")

echo "=============================================================="
echo "MUSIC COMPOSITION WORKFLOW"
echo "=============================================================="
echo ""
echo "Project: $PROJECT_NAME"
echo "Directory: $PROJECT_DIR"
echo ""

cd "$PROJECT_DIR"

# Step 1: Compile LilyPond files
if [ "$AUDIO_ONLY" = false ]; then
    echo "Step 1: Compiling LilyPond files..."
    echo "------------------------------------------------------------"

    for ly_file in *.ly; do
        if [ -f "$ly_file" ]; then
            echo "  Compiling: $ly_file"
            lilypond "$ly_file" 2>&1 | grep -E "(Success|Error)" || true
        fi
    done

    echo ""
    echo "✓ LilyPond compilation complete"
    echo ""

    # Add MIDI instruments
    if ls symphony_movement*.ly 1> /dev/null 2>&1; then
        echo "Step 2: Adding MIDI instruments..."
        echo "------------------------------------------------------------"
        "$SKILL_DIR/scripts/add_midi_instruments.sh" 2>&1 | tail -5
        echo ""
        echo "✓ MIDI instruments added"
        echo ""
    fi

    if [ "$COMPILE_ONLY" = true ]; then
        echo "Compile-only mode. Stopping here."
        exit 0
    fi
fi

# Step 3: Produce audio
echo "Step 3: Producing audio..."
echo "------------------------------------------------------------"
"$SKILL_DIR/scripts/produce_audio.sh" "$PROJECT_DIR" 2>&1 | grep -v "^sox WARN"
echo ""

# Step 4: Create 8-minute version if requested
if [ "$CREATE_8MIN" = true ]; then
    echo "Step 4: Creating 8-minute version for Suno..."
    echo "------------------------------------------------------------"

    MAIN_MP3=$(find . -name "*_PROFESSIONAL.mp3" | head -1)

    if [ -n "$MAIN_MP3" ]; then
        # Copy and adapt 8min script
        cp "$SKILL_DIR/scripts/create_8min_version.sh" .

        # Update script to use found MP3
        sed -i "s/SOURCE=\".*\"/SOURCE=\"$(basename $MAIN_MP3)\"/" create_8min_version.sh

        ./create_8min_version.sh
        echo ""
        echo "✓ 8-minute version created"
    else
        echo "! No professional MP3 found, skipping 8-minute version"
    fi
fi

echo ""
echo "=============================================================="
echo "COMPOSITION WORKFLOW COMPLETE!"
echo "=============================================================="
echo ""
echo "Output files in: $PROJECT_DIR"
echo ""
ls -lh *.pdf *.mp3 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
echo ""
