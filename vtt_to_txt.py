#!/usr/bin/env python3
"""
Convert VTT subtitle file to clean text for LLM processing.

This is a lightweight wrapper. For speaker detection, use create_clean_transcript.py instead.
"""

import re
import sys
import os


def vtt_to_clean_text(vtt_file):
    """Convert VTT file to clean text without timestamps (for LLM)."""
    with open(vtt_file, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    clean_text = []

    for line in lines:
        line = line.strip()
        # Skip VTT headers, timing lines, empty lines
        if not line or line.startswith('WEBVTT') or line.startswith('Kind:') or line.startswith('Language:'):
            continue
        if '-->' in line:
            continue
        if re.match(r'^\d+$', line):
            continue
        # Remove VTT formatting tags
        line = re.sub(r'<[^>]+>', '', line)
        # Remove inline timestamps
        line = re.sub(r'\d{2}:\d{2}:\d{2}\.\d{3}\s*-->\s*\d{2}:\d{2}:\d{2}\.\d{3}', '', line)
        line = line.strip()
        if line:
            clean_text.append(line)

    # Write clean TXT file
    base_name = os.path.splitext(vtt_file)[0]
    txt_file = f"{base_name}.txt"

    with open(txt_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(clean_text))

    return txt_file


def vtt_to_transcript(vtt_file):
    """Convert VTT file to transcript with timestamps."""
    with open(vtt_file, 'r', encoding='utf-8') as f:
        content = f.read()

    blocks = re.split(r'\n\n', content)
    transcript_lines = []
    transcript_lines.append(f"TRANSCRIPT")
    transcript_lines.append("=" * 50)
    transcript_lines.append("")

    for block in blocks:
        if '-->' in block:
            lines = block.strip().split('\n')
            time_match = re.search(r'(\d{2}):(\d{2}):(\d{2}\.\d{3})', lines[0])
            if time_match and len(lines) >= 2:
                m = int(time_match.group(2))
                s = float(time_match.group(3))
                timestamp = f"[{m:02d}:{int(s):02d}]"
                text = ' '.join(lines[1:])
                text = re.sub(r'<[^>]+>', '', text).strip()
                if text:
                    transcript_lines.append(f"{timestamp} {text}")

    base_name = os.path.splitext(vtt_file)[0]
    transcript_file = f"{base_name}.txt"

    with open(transcript_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(transcript_lines))

    return transcript_file


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python vtt_to_txt.py <vtt_file> [--transcript]")
        print("  --transcript: Create formatted transcript with timestamps")
        print("  (default): Create clean text for LLM input")
        sys.exit(1)

    vtt_file = sys.argv[1]
    make_transcript = len(sys.argv) > 2 and sys.argv[2] == '--transcript'

    if not os.path.exists(vtt_file):
        print(f"Error: File {vtt_file} not found")
        sys.exit(1)

    try:
        if make_transcript:
            transcript_file = vtt_to_transcript(vtt_file)
            print(f"Created transcript: {transcript_file}")
        txt_file = vtt_to_clean_text(vtt_file)
        print(f"Created clean text: {txt_file}")
    except Exception as e:
        print(f"Error converting file: {e}")
        sys.exit(1)