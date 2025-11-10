#!/usr/bin/env python3
"""
HyperList to PDF Converter
Converts .hl files to PDF with proper syntax coloring matching the TUI and Vim plugin
Uses tokenizer approach to avoid nested HTML tags
"""

import re
from reportlab.lib import colors
from reportlab.lib.pagesizes import landscape, A4
from reportlab.lib.units import cm
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_LEFT
import sys

# HyperList color scheme (matching TUI "normal" theme - adjusted for readability)
HL_COLORS = {
    "red": "#CC0000",        # Dark red - properties/dates
    "green": "#00AA00",      # Dark green - qualifiers/checkboxes
    "blue": "#0000CC",       # Dark blue - operators
    "magenta": "#AA00AA",    # Dark magenta - references
    "cyan": "#00AAAA",       # Dark cyan - parentheses/quotes
    "yellow": "#AA8800",     # Dark yellow - substitutions
    "orange": "#CC5500",     # Dark orange - tags
}


def escape_html(text):
    """Escape HTML special characters"""
    return (text.replace('&', '&amp;')
                .replace('<', '&lt;')
                .replace('>', '&gt;')
                .replace('"', '&quot;'))


def get_indent_level(line):
    """Calculate indentation level from tabs or *"""
    indent = 0
    for char in line:
        if char == '\t' or char == '*':
            indent += 1
        else:
            break
    return indent


class ColoredSegment:
    """Represents a colored segment of text"""
    def __init__(self, text, color=None, bold=False, italic=False, underline=False):
        self.text = text
        self.color = color
        self.bold = bold
        self.italic = italic
        self.underline = underline

    def to_html(self):
        """Convert to HTML with styling"""
        result = escape_html(self.text)

        if self.bold:
            result = f'<b>{result}</b>'
        if self.italic:
            result = f'<i>{result}</i>'
        if self.underline:
            result = f'<u>{result}</u>'
        if self.color:
            result = f'<font color="{self.color}">{result}</font>'

        return result


def tokenize_hyperlist(text):
    """
    Tokenize HyperList text into segments with colors
    Returns list of ColoredSegment objects
    """
    segments = []
    i = 0

    while i < len(text):
        matched = False

        # 1. Checkboxes [X], [O], [-], [ ], [_]
        if text[i:i+3] in ['[X]', '[x]', '[O]', '[-]', '[ ]', '[_]']:
            segments.append(ColoredSegment(text[i:i+3], HL_COLORS["green"], bold=(text[i:i+3] == '[O]')))
            i += 3
            matched = True

        # 2. Properties (Name: with space after colon)
        elif i == 0 or text[i-1] in ' \t':
            prop_match = re.match(r'([a-zA-Z][a-zA-Z0-9_\-() ./=]+):\s', text[i:])
            if prop_match and len(prop_match.group(1)) >= 2 and not prop_match.group(1).isupper():
                prop_text = prop_match.group()
                segments.append(ColoredSegment(prop_text, HL_COLORS["red"]))
                i += len(prop_text)
                matched = True

        # 3. Operators (ALL-CAPS: with or without space)
        if not matched and (i == 0 or text[i-1] in ' \t'):
            op_match = re.match(r'([A-Z][A-Z_\-() /=]*):\s*', text[i:])
            if op_match:
                op_text = op_match.group()
                segments.append(ColoredSegment(op_text, HL_COLORS["blue"]))
                i += len(op_text)
                matched = True

        # 4. Qualifiers [...] (but not checkboxes)
        if not matched and text[i] == '[':
            qual_match = re.match(r'\[([^\]]+)\]', text[i:])
            if qual_match and qual_match.group() not in ['[X]', '[x]', '[O]', '[-]', '[ ]', '[_]']:
                qual_text = qual_match.group()
                segments.append(ColoredSegment(qual_text, HL_COLORS["green"]))
                i += len(qual_text)
                matched = True

        # 5. Parentheses (...)
        if not matched and text[i] == '(':
            paren_match = re.match(r'\(([^)]*)\)', text[i:])
            if paren_match:
                paren_text = paren_match.group()
                segments.append(ColoredSegment(paren_text, HL_COLORS["cyan"]))
                i += len(paren_text)
                matched = True

        # 6. Quoted strings "..."
        if not matched and text[i] == '"':
            quote_match = re.match(r'"([^"]*)"', text[i:])
            if quote_match:
                quote_text = quote_match.group()
                segments.append(ColoredSegment(quote_text, HL_COLORS["cyan"]))
                i += len(quote_text)
                matched = True

        # 7. References <...> or <<...>>
        if not matched and text[i] == '<':
            ref_match = re.match(r'<{1,2}([^>]+)>{1,2}', text[i:])
            if ref_match:
                ref_text = ref_match.group()
                segments.append(ColoredSegment(ref_text, HL_COLORS["magenta"]))
                i += len(ref_text)
                matched = True

        # 8. Hash tags #tag
        if not matched and text[i] == '#':
            tag_match = re.match(r'#([a-zA-Z0-9.:_/&?%=+\-*]+)', text[i:])
            if tag_match:
                tag_text = tag_match.group()
                segments.append(ColoredSegment(tag_text, HL_COLORS["orange"]))
                i += len(tag_text)
                matched = True

        # 9. Text formatting *bold*, /italic/, _underline_
        if not matched and text[i] in '*/_' and (i == 0 or text[i-1] in ' \t'):
            if text[i] == '*':
                fmt_match = re.match(r'\*([^*]+)\*(\s|$)', text[i:])
                if fmt_match:
                    segments.append(ColoredSegment(fmt_match.group(1), bold=True))
                    i += len(fmt_match.group(1)) + 2
                    matched = True
            elif text[i] == '/':
                fmt_match = re.match(r'/([^/]+)/(\s|$)', text[i:])
                if fmt_match:
                    segments.append(ColoredSegment(fmt_match.group(1), italic=True))
                    i += len(fmt_match.group(1)) + 2
                    matched = True
            elif text[i] == '_':
                fmt_match = re.match(r'_([^_]+)_(\s|$)', text[i:])
                if fmt_match:
                    segments.append(ColoredSegment(fmt_match.group(1), underline=True))
                    i += len(fmt_match.group(1)) + 2
                    matched = True

        # 10. Semicolons
        if not matched and text[i] == ';':
            segments.append(ColoredSegment(';', HL_COLORS["green"]))
            i += 1
            matched = True

        # 11. Special keywords
        if not matched:
            keyword_match = re.match(r'\b(SKIP|END|EXAMPLE)\b', text[i:])
            if keyword_match:
                keyword_text = keyword_match.group()
                color = HL_COLORS["blue"] if keyword_text == "EXAMPLE" else HL_COLORS["magenta"]
                segments.append(ColoredSegment(keyword_text, color))
                i += len(keyword_text)
                matched = True

        # 12. Multi-line indicator + at start
        if not matched and i == 0 and text[i:i+2] == '+ ':
            segments.append(ColoredSegment('+', HL_COLORS["red"]))
            i += 1
            matched = True

        # 13. State/transition markers | and /
        if not matched and i == 0 and text[i:i+2] in ['| ', '/ ']:
            segments.append(ColoredSegment(text[i], HL_COLORS["green"]))
            i += 1
            matched = True

        # Default: regular text
        if not matched:
            segments.append(ColoredSegment(text[i]))
            i += 1

    return segments


def segments_to_html(segments):
    """Convert list of ColoredSegments to HTML"""
    return ''.join(seg.to_html() for seg in segments)


def parse_hyperlist(filepath):
    """Parse HyperList file and return structured items"""
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    items = []
    for i, line in enumerate(lines, 1):
        # Skip config lines
        if re.match(r'^\(\(.+\)\)$', line.strip()):
            continue

        # Calculate indent
        indent = get_indent_level(line)

        # Remove leading tabs/stars but keep the rest
        text = line.lstrip('\t*').rstrip('\n')

        items.append({
            'line_num': i,
            'indent': indent,
            'text': text,
            'is_empty': text.strip() == ''
        })

    return items


def find_page_breaks(items, max_lines_per_page=45):
    """
    Find intelligent page break points that preserve context
    Avoid breaking within a closely related group of items
    """
    breaks = []
    current_line = 0

    i = 0
    while i < len(items):
        # If we're approaching page limit, find a good break point
        if current_line >= max_lines_per_page - 5:
            # Look ahead to find a good break (lower indent level or empty line)
            best_break = i
            for j in range(i, min(i + 10, len(items))):
                if items[j]['is_empty']:
                    best_break = j + 1
                    break
                elif j > i and items[j]['indent'] == 0:
                    best_break = j
                    break
                elif j > i and items[j]['indent'] < items[j-1]['indent']:
                    best_break = j
                    break

            breaks.append(best_break)
            current_line = 0
            i = best_break
        else:
            current_line += 1
            i += 1

    return breaks


def create_pdf(filepath, output_path):
    """Create PDF from HyperList file"""
    # Parse the HyperList
    items = parse_hyperlist(filepath)

    # Setup PDF
    doc = SimpleDocTemplate(
        output_path,
        pagesize=landscape(A4),
        leftMargin=1*cm,
        rightMargin=1*cm,
        topMargin=1*cm,
        bottomMargin=1*cm
    )

    # Styles
    styles = getSampleStyleSheet()
    mono_style = ParagraphStyle(
        'HyperList',
        parent=styles['Code'],
        fontName='Courier',
        fontSize=9,
        leading=11,
        leftIndent=0,
        spaceAfter=0,
        alignment=TA_LEFT
    )

    # Build story
    story = []
    page_breaks = find_page_breaks(items)

    for i, item in enumerate(items):
        if item['is_empty']:
            story.append(Spacer(1, 0.3*cm))
            continue

        # Calculate indent in spaces (each level = 2 spaces for monospace alignment)
        indent_spaces = '&nbsp;' * (item['indent'] * 2)

        # Apply syntax highlighting using tokenizer
        segments = tokenize_hyperlist(item['text'])
        colored_text = segments_to_html(segments)

        # Create paragraph with indent
        para = Paragraph(indent_spaces + colored_text, mono_style)
        story.append(para)

        # Add page break if this is a break point
        if i + 1 in page_breaks:
            story.append(PageBreak())

    # Build PDF
    doc.build(story)
    print(f"PDF created: {output_path}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python generate_hyperlist_pdf.py <input.hl> [output.pdf]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else input_file.replace('.hl', '.pdf')

    create_pdf(input_file, output_file)
