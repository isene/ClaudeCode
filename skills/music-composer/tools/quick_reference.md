# Music Composer - Quick Reference

## Common Commands

### Compile LilyPond
```bash
lilypond piece.ly
```

### Full Workflow (compile + audio + PDF)
```bash
~/.claude/skills/music-composer/scripts/compose_piece.sh /path/to/project
```

### Audio Only
```bash
~/.claude/skills/music-composer/scripts/produce_audio.sh /path/to/project
```

### Create 8-Minute Version
```bash
cd /path/to/project
~/.claude/skills/music-composer/scripts/create_8min_version.sh
```

## MIDI Instruments

Must include in each staff:
```lilypond
\new Staff \with {
  instrumentName = "Display Name"
  midiInstrument = "midi-name"
} { ... }
```

### Common MIDI Instruments

**Strings:**
- `"violin"` - Violin
- `"viola"` - Viola
- `"cello"` - Cello
- `"contrabass"` - Contrabass

**Woodwinds:**
- `"flute"` - Flute
- `"piccolo"` - Piccolo
- `"oboe"` - Oboe
- `"clarinet"` - Clarinet
- `"bassoon"` - Bassoon

**Brass:**
- `"trumpet"` - Trumpet
- `"french horn"` - French Horn
- `"trombone"` - Trombone
- `"tuba"` - Tuba

**Percussion:**
- `"timpani"` - Timpani

**Other:**
- `"orchestral harp"` - Harp
- `"acoustic grand"` - Piano

## Typical Ranges

**Violin:** G3 - E7
**Viola:** C3 - E6
**Cello:** C2 - C6
**Contrabass:** E1 - G4
**Flute:** C4 - C7
**Oboe:** Bb3 - A6
**Trumpet:** F#3 - D6
**French Horn:** B1 - F5
**Trombone:** E2 - F5

## Keys in LilyPond

```lilypond
\key c \major     % C major
\key d \major     % D major
\key g \major     % G major
\key a \minor     % A minor
\key d \minor     % D minor
\key fis \minor   % F# minor
```

## Time Signatures

```lilypond
\time 4/4    % Common time
\time 3/4    % Waltz time
\time 6/8    % Compound time
\time 5/4    % Asymmetric
```

## Dynamics

```lilypond
\ppp  % Pianississimo
\pp   % Pianissimo
\p    % Piano
\mp   % Mezzo-piano
\mf   % Mezzo-forte
\f    % Forte
\ff   % Fortissimo
\fff  % Fortississimo
```

## Articulations

```lilypond
c4-. % Staccato
c4-> % Accent
c4-^ % Marcato
c4-_ % Tenuto
c4\trill % Trill
```

## Crescendo/Diminuendo

```lilypond
c4\< d e f\!  % Crescendo
c4\> d e f\!  % Diminuendo
```

## Common Tempo Markings

- Largo: 40-60 BPM (very slow)
- Adagio: 55-65 BPM (slow)
- Andante: 73-77 BPM (walking pace)
- Moderato: 86-97 BPM (moderate)
- Allegro: 120-156 BPM (fast)
- Presto: 168-200 BPM (very fast)

## File Structure

```
Project/
├── piece_name.ly          # LilyPond source
├── piece_name.pdf         # Generated score
├── piece_name.midi        # Generated MIDI
├── Project_PROFESSIONAL.mp3  # Final audio
└── Project_8MIN.mp3       # 8-minute version (if created)
```

## Troubleshooting

**Problem:** MIDI sounds like piano
**Solution:** Add `midiInstrument = "instrument"` to all staves

**Problem:** Compilation errors
**Solution:** Check for unmatched braces `{ }`, missing `|` bar lines

**Problem:** Audio too quiet
**Solution:** Increase gain: `fluidsynth -g 1.5 ...`

**Problem:** Score too crowded
**Solution:** Adjust `base-shortest-duration` in layout block
