#!/usr/bin/env python3
"""
Create clean transcripts with speaker detection from VTT files
Combines VTT parsing, cleaning, and speaker identification
"""

import re
import sys
import os
from datetime import datetime, timedelta
from typing import List, Dict, Tuple

def parse_and_clean_vtt(vtt_file: str) -> List[Dict]:
    """Parse VTT file and clean the content."""
    entries = []

    with open(vtt_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Parse VTT format
    blocks = re.split(r'\n\n', content)

    for block in blocks:
        if '-->' in block:
            lines = block.strip().split('\n')
            if len(lines) >= 2:
                # Extract timestamp
                time_match = re.search(r'(\d{2}):(\d{2}):(\d{2}\.\d{3})', lines[0])
                if time_match:
                    h = int(time_match.group(1))
                    m = int(time_match.group(2))
                    s = float(time_match.group(3))
                    timestamp = timedelta(hours=h, minutes=m, seconds=int(s), microseconds=int((s - int(s)) * 1000000))

                    # Extract and clean text
                    text_parts = []
                    for line in lines[1:]:
                        # Remove VTT timestamps like <00:00:04.640>
                        text = re.sub(r'<\d{2}:\d{2}:\d{2}\.\d{3}>', '', line)
                        # Remove <c> tags and their closing tags
                        text = re.sub(r'</?c[^>]*>', '', text)
                        # Remove any other HTML-like tags
                        text = re.sub(r'<[^>]+>', '', text)
                        # Clean up text
                        text = text.strip()
                        if text:
                            text_parts.append(text)

                    if text_parts:
                        # Combine text parts and clean up
                        combined_text = ' '.join(text_parts)
                        # Remove immediate repetitions (common in auto-captions)
                        words = combined_text.split()
                        cleaned_words = []
                        for i, word in enumerate(words):
                            if i == 0 or word != words[i-1]:
                                cleaned_words.append(word)
                        final_text = ' '.join(cleaned_words)

                        entries.append({
                            'timestamp': timestamp,
                            'text': final_text
                        })

    return entries

def detect_speakers_simple(entries: List[Dict]) -> List[Dict]:
    """Simple speaker detection based on timing and content."""
    speakers = []
    current_speaker = "SPEAKER_00"
    speaker_count = 1

    for i, entry in enumerate(entries):
        text = entry['text'].lower()

        # Check for speaker change indicators
        change_speaker = False

        # Long pause (if we could detect it)
        if i > 0:
            time_diff = entry['timestamp'] - entries[i-1]['timestamp']
            if time_diff > timedelta(seconds=2):
                change_speaker = True

        # Question/Answer patterns
        if '?' in text and any(word in text for word in ['what', 'when', 'where', 'why', 'how', 'who', 'does', 'can', 'could', 'would', 'are', 'is']):
            change_speaker = True

        # Greetings and transitions
        if any(word in text for word in ['hello', 'hi', 'thanks', 'thank you', 'okay', 'so', 'well', 'now', 'first', 'second', 'third']):
            change_speaker = True

        # Change speaker if indicated
        if change_speaker and i > 0:
            speaker_count += 1
            if speaker_count > 10:  # Limit to reasonable number
                current_speaker = f"SPEAKER_{(speaker_count - 1) % 10:02d}"
            else:
                current_speaker = f"SPEAKER_{(speaker_count - 1):02d}"

        speakers.append({
            'timestamp': entry['timestamp'],
            'text': entry['text'],
            'speaker': current_speaker
        })

    return speakers

def create_transcript_file(entries: List[Dict], output_file: str):
    """Create the clean transcript file in the requested format."""
    with open(output_file, 'w', encoding='utf-8') as f:
        # Header
        f.write(f"TRANSCRIPT - {datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}\n")
        f.write("=" * 50)
        f.write("\n\n")

        current_speaker = None
        current_text = []

        for entry in entries:
            # Format timestamp as [MM:SS]
            total_seconds = int(entry['timestamp'].total_seconds())
            minutes = total_seconds // 60
            seconds = total_seconds % 60
            timestamp_str = f"[{minutes:02d}:{seconds:02d}]"

            # Check if speaker changed
            if entry['speaker'] != current_speaker:
                # Write previous speaker's accumulated text
                if current_text and current_speaker:
                    # Combine all text for this speaker segment
                    full_text = ' '.join(current_text)
                    f.write(f"{timestamp_str} {current_speaker}: {full_text}\n")
                    current_text = []

                current_speaker = entry['speaker']

            # Add text to current accumulation
            current_text.append(entry['text'])

        # Write the last speaker's text
        if current_text and current_speaker:
            total_seconds = int(entries[-1]['timestamp'].total_seconds())
            minutes = total_seconds // 60
            seconds = total_seconds % 60
            timestamp_str = f"[{minutes:02d}:{seconds:02d}]"
            full_text = ' '.join(current_text)
            f.write(f"{timestamp_str} {current_speaker}: {full_text}\n")

def create_clean_text_file(entries: List[Dict], output_file: str):
    """Create a clean text file without speaker labels or timestamps."""
    with open(output_file, 'w', encoding='utf-8') as f:
        for entry in entries:
            f.write(f"{entry['text']} ")

def main():
    if len(sys.argv) < 2:
        print("Usage: python create_clean_transcript.py <vtt_file> [--speaker]")
        print("  --speaker: Create transcript with speaker labels")
        sys.exit(1)

    vtt_file = sys.argv[1]
    create_speaker_transcript = len(sys.argv) > 2 and sys.argv[2] == '--speaker'

    if not os.path.exists(vtt_file):
        print(f"Error: File {vtt_file} not found")
        sys.exit(1)

    try:
        print(f"Processing {vtt_file}...")

        # Parse and clean VTT
        entries = parse_and_clean_vtt(vtt_file)
        print(f"Parsed {len(entries)} entries")

        if create_speaker_transcript:
            # Detect speakers
            speakers = detect_speakers_simple(entries)
            unique_speakers = len(set(s['speaker'] for s in speakers))
            print(f"Detected {unique_speakers} speakers")

            # Create speaker-labeled transcript
            base_name = os.path.splitext(vtt_file)[0]
            transcript_file = f"{base_name}.txt"
            create_transcript_file(speakers, transcript_file)
            print(f"✓ Created transcript with speakers: {transcript_file}")

        # Always create clean text file
        base_name = os.path.splitext(vtt_file)[0]
        clean_file = f"{base_name}_clean.txt"
        create_clean_text_file(entries, clean_file)
        print(f"✓ Created clean text: {clean_file}")

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()