\version "2.24.0"

\header {
  title = "{{TITLE}}"
  composer = "{{COMPOSER}}"
  tagline = ##f
}

\paper {
  #(set-paper-size "a4")
}

\layout {
  \context {
    \Score
    \override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/16)
  }
}

\score {
  \new StaffGroup <<
    \new Staff \with {
      instrumentName = "Violins"
      midiInstrument = "violin"
    } {
      \clef treble
      \key c \major
      \time 4/4
      \tempo "Moderato" 4 = 100

      \relative c'' {
        % Your music here
        c4 d e f | g1 |
      }
    }
  >>

  \layout { }
  \midi { }
}
