#!/usr/bin/env python3
"""
Convert VTT subtitle file to clean transcript with timestamps for LLM processing
"""

import re
import sys
import os
from datetime import datetime

def vtt_to_transcript(vtt_file):
    """Convert VTT file to clean transcript with timestamps."""
    with open(vtt_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split into subtitle blocks
    blocks = re.split(r'\n\n', content)

    # Get the base filename for the header
    base_name = os.path.basename(os.path.splitext(vtt_file)[0])
    # Clean the base name (remove special chars)
    base_name = re.sub(r'[^\w\s-]', '', base_name).strip()

    # Prepare transcript lines
    transcript_lines = []

    # Header
    transcript_lines.append(f"TRANSCRIPT - {datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}")
    transcript_lines.append("=" * 50)
    transcript_lines.append("")

    current_speaker = "SPEAKER_00"
    current_time = "[00:00]"

    for block in blocks:
        if '-->' in block:
            lines = block.strip().split('\n')

            # Extract start time
            time_match = re.search(r'(\d{2}):(\d{2}):(\d{2}\.\d{3})', lines[0])
            if time_match:
                h = int(time_match.group(1))
                m = int(time_match.group(2))
                s = float(time_match.group(3))
                # Format as [MM:SS]
                current_time = f"[{m:02d}:{int(s):02d}]"

            # Get the subtitle text
            if len(lines) >= 2:
                text = ' '.join(lines[1:])
                # Clean the text
                text = re.sub(r'<[^>]+>', '', text)
                text = text.strip()

                if text:
                    # Add speaker label only if it's a new block or significant pause
                    # For simplicity, we'll use alternating speakers based on heuristics
                    if len(transcript_lines) == 3:  # First content line
                        transcript_lines.append(f"{current_time} {current_speaker}:")

                    # Add the text
                    transcript_lines.append(f"{current_time} {current_speaker}: {text}")

                    # Simple speaker alternation (can be improved)
                    # This is a basic heuristic - better to use speaker_diarization.py
                    if '?' in text or any(text.lower().startswith(word) for word in ['what', 'when', 'where', 'why', 'how', 'who', 'does', 'can', 'could', 'would']):
                        if current_speaker == "SPEAKER_00":
                            current_speaker = "SPEAKER_01"
                        else:
                            current_speaker = "SPEAKER_00"

    # Write transcript file
    base_name = os.path.splitext(vtt_file)[0]
    transcript_file = f"{base_name}.txt"

    with open(transcript_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(transcript_lines))

    return transcript_file

def vtt_to_clean_text(vtt_file):
    """Convert VTT file to clean text without timestamps (for LLM)."""
    with open(vtt_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split into subtitle blocks
    blocks = re.split(r'\n\n', content)
    clean_text = []

    for block in blocks:
        # Skip if this is a timing line
        if '-->' in block:
            continue

        # Skip header information
        if block.startswith('WEBVTT') or block.startswith('Kind:') or block.startswith('Language:'):
            continue

        # Process each line in the block
        lines = block.strip().split('\n')
        for line in lines:
            line = line.strip()
            # Skip empty lines
            if not line:
                continue

            # Remove VTT formatting tags
            line = re.sub(r'<[^>]+>', '', line)

            # Remove any remaining timing info (just in case)
            line = re.sub(r'\d{2}:\d{2}:\d{2}\.\d{3}\s*-->\s*\d{2}:\d{2}:\d{2}\.\d{3}', '', line)

            # Add to clean text if not empty
            if line:
                clean_text.append(line)

    # Write clean TXT file
    base_name = os.path.splitext(vtt_file)[0]
    txt_file = f"{base_name}.txt"

    with open(txt_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(clean_text))

    return txt_file

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python vtt_to_txt.py <vtt_file> [--transcript]")
        print("  --transcript: Create formatted transcript with timestamps")
        sys.exit(1)

    vtt_file = sys.argv[1]
    make_transcript = len(sys.argv) > 2 and sys.argv[2] == '--transcript'

    if not os.path.exists(vtt_file):
        print(f"Error: File {vtt_file} not found")
        sys.exit(1)

    try:
        if make_transcript:
            # Create both files
            transcript_file = vtt_to_transcript(vtt_file)
            print(f"✓ Created transcript with timestamps: {transcript_file}")

            # Also create clean text
            clean_file = vtt_to_clean_text(vtt_file)
            print(f"✓ Created clean text: {clean_file}")
        else:
            # Just clean text
            txt_file = vtt_to_clean_text(vtt_file)
            print(f"✓ Created: {txt_file}")
    except Exception as e:
        print(f"Error converting file: {e}")
        sys.exit(1)