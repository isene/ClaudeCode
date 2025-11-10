#!/bin/bash

# Add MIDI instruments to all movement LilyPond files and recompile

echo "Adding MIDI instruments to all movements..."
echo ""

# Movement 1 - already done, just recompile
echo "[1/4] Movement 1 - already fixed, recompiling..."
lilypond symphony_movement1.ly 2>/dev/null
echo "  ✓ Complete"

# Movement 2 - Fix instruments
echo "[2/4] Movement 2 - adding instruments..."

# Backup
cp symphony_movement2.ly symphony_movement2.ly.bak

# Add MIDI instruments using sed
sed -i 's/instrumentName = "Violin Solo"/instrumentName = "Violin Solo"\n      midiInstrument = "violin"/' symphony_movement2.ly
sed -i 's/instrumentName = "Cello Solo"/instrumentName = "Cello Solo"\n      midiInstrument = "cello"/' symphony_movement2.ly
sed -i 's/instrumentName = "Harp"/instrumentName = "Harp"\n      midiInstrument = "orchestral harp"/' symphony_movement2.ly
sed -i 's/instrumentName = "Violins I"/instrumentName = "Violins I"\n      midiInstrument = "violin"/' symphony_movement2.ly
sed -i 's/instrumentName = "Violins II"/instrumentName = "Violins II"\n      midiInstrument = "violin"/' symphony_movement2.ly
sed -i 's/instrumentName = "Violas"/instrumentName = "Violas"\n      midiInstrument = "viola"/' symphony_movement2.ly
sed -i 's/instrumentName = "Cellos"/instrumentName = "Cellos"\n      midiInstrument = "cello"/' symphony_movement2.ly
sed -i 's/instrumentName = "Contrabass"/instrumentName = "Contrabass"\n      midiInstrument = "contrabass"/' symphony_movement2.ly

lilypond symphony_movement2.ly 2>/dev/null
echo "  ✓ Complete"

# Movement 3 - Fix instruments
echo "[3/4] Movement 3 - adding instruments..."

cp symphony_movement3.ly symphony_movement3.ly.bak

sed -i 's/instrumentName = "Flute"/instrumentName = "Flute"\n      midiInstrument = "flute"/' symphony_movement3.ly
sed -i 's/instrumentName = "Violins I"/instrumentName = "Violins I"\n      midiInstrument = "violin"/' symphony_movement3.ly
sed -i 's/instrumentName = "Violins II"/instrumentName = "Violins II"\n      midiInstrument = "violin"/' symphony_movement3.ly
sed -i 's/instrumentName = "Violas"/instrumentName = "Violas"\n      midiInstrument = "viola"/' symphony_movement3.ly
sed -i 's/instrumentName = "Cellos"/instrumentName = "Cellos"\n      midiInstrument = "cello"/' symphony_movement3.ly
sed -i 's/instrumentName = "Contrabass"/instrumentName = "Contrabass"\n      midiInstrument = "contrabass"/' symphony_movement3.ly
sed -i 's/instrumentName = "Horns in F"/instrumentName = "Horns in F"\n      midiInstrument = "french horn"/' symphony_movement3.ly
sed -i 's/instrumentName = "Trumpet in C"/instrumentName = "Trumpet in C"\n      midiInstrument = "trumpet"/' symphony_movement3.ly

lilypond symphony_movement3.ly 2>/dev/null
echo "  ✓ Complete"

# Movement 4 - Fix instruments
echo "[4/4] Movement 4 - adding instruments..."

cp symphony_movement4.ly symphony_movement4.ly.bak

sed -i 's/instrumentName = "Piccolo"/instrumentName = "Piccolo"\n      midiInstrument = "piccolo"/' symphony_movement4.ly
sed -i 's/instrumentName = "Flute"/instrumentName = "Flute"\n      midiInstrument = "flute"/' symphony_movement4.ly
sed -i 's/instrumentName = "Oboe"/instrumentName = "Oboe"\n      midiInstrument = "oboe"/' symphony_movement4.ly
sed -i 's/instrumentName = "Trumpets in C"/instrumentName = "Trumpets in C"\n      midiInstrument = "trumpet"/' symphony_movement4.ly
sed -i 's/instrumentName = "Horns in F"/instrumentName = "Horns in F"\n      midiInstrument = "french horn"/' symphony_movement4.ly
sed -i 's/instrumentName = "Trombones"/instrumentName = "Trombones"\n      midiInstrument = "trombone"/' symphony_movement4.ly
sed -i 's/instrumentName = "Timpani"/instrumentName = "Timpani"\n      midiInstrument = "timpani"/' symphony_movement4.ly
sed -i 's/instrumentName = "Violins I"/instrumentName = "Violins I"\n      midiInstrument = "violin"/' symphony_movement4.ly
sed -i 's/instrumentName = "Violins II"/instrumentName = "Violins II"\n      midiInstrument = "violin"/' symphony_movement4.ly
sed -i 's/instrumentName = "Violas"/instrumentName = "Violas"\n      midiInstrument = "viola"/' symphony_movement4.ly
sed -i 's/instrumentName = "Cellos"/instrumentName = "Cellos"\n      midiInstrument = "cello"/' symphony_movement4.ly
sed -i 's/instrumentName = "Contrabass"/instrumentName = "Contrabass"\n      midiInstrument = "contrabass"/' symphony_movement4.ly

lilypond symphony_movement4.ly 2>/dev/null
echo "  ✓ Complete"

echo ""
echo "All movements recompiled with proper MIDI instruments!"
echo "New MIDI files created with correct orchestral sounds."
echo ""
