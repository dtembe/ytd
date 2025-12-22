#!/usr/bin/env python3
"""
Speaker Diarization Post-Processor
Analyzes YouTube transcripts to identify potential speaker changes and label them.
"""

import re
import sys
import os
from datetime import timedelta
from typing import List, Dict, Tuple

def load_vtt_transcript(vtt_file: str) -> List[Tuple[timedelta, str]]:
    """Load VTT transcript and extract timestamps with text."""
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

                    # Extract and clean text (combine all lines after timestamp)
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

                    # Combine text parts and remove duplicates
                    if text_parts:
                        combined_text = ' '.join(text_parts)
                        # Remove repeated phrases (simple heuristic)
                        sentences = combined_text.split('. ')
                        cleaned_sentences = []
                        for sentence in sentences:
                            sentence = sentence.strip()
                            if sentence and sentence not in cleaned_sentences:
                                cleaned_sentences.append(sentence)
                        final_text = '. '.join(cleaned_sentences)

                        if final_text:
                            entries.append((timestamp, final_text))

    return entries

def identify_speakers(entries: List[Tuple[timedelta, str]]) -> List[Dict]:
    """Identify speaker changes based on linguistic patterns."""
    speakers = []
    current_speaker = "Speaker 1"
    speaker_count = 1

    # Patterns that might indicate speaker changes
    change_patterns = [
        r'^\b(?:I|I\'m|I have|I think|I believe|In my)\b',
        r'^\b(?:We|We\'re|We have|We think)\b',
        r'^\b(?:So|Now|Well|Okay|Right)\b',
        r'^\b(?:Question|Answer|Thanks|Thank you)\b',
        r'^\b(?:First|Second|Third|Finally)\b',
        r'^\["\']',  # Direct quotes
    ]

    # Patterns that might indicate Q&A
    qa_patterns = [
        r'\?',
        r'^\b(?:What|When|Where|Why|How|Who|Which)\b',
        r'^\b(?:Does|Do|Did|Can|Could|Would|Should|Will|Are|Is)\b',
    ]

    for i, (timestamp, text) in enumerate(entries):
        text_clean = text.strip()

        # Check for speaker change indicators
        speaker_change = False
        reason = ""

        # Long pause (check timestamp gap)
        if i > 0:
            time_diff = timestamp - entries[i-1][0]
            if time_diff > timedelta(seconds=3):
                speaker_change = True
                reason = f"Pause ({time_diff.total_seconds():.1f}s)"

        # Linguistic patterns
        for pattern in change_patterns:
            if re.search(pattern, text_clean, re.IGNORECASE):
                speaker_change = True
                reason = f"Pattern: {pattern[:20]}..."
                break

        # Question/Answer patterns
        for pattern in qa_patterns:
            if re.search(pattern, text_clean, re.IGNORECASE):
                if '?' in text_clean:
                    speaker_change = True
                    reason = "Question detected"
                    break

        # Chapter breaks (if available)
        if any(phrase in text_clean.lower() for phrase in ['chapter', 'section', 'part', 'next']):
            speaker_change = True
            reason = "Chapter marker"

        # Change speaker if indicated
        if speaker_change and i > 0:  # Don't change for first entry
            speaker_count += 1
            if speaker_count > 4:  # Limit to reasonable number
                current_speaker = f"Speaker {speaker_count % 4 + 1}"
            else:
                current_speaker = f"Speaker {speaker_count}"

        speakers.append({
            'timestamp': timestamp,
            'text': text_clean,
            'speaker': current_speaker,
            'confidence': 'high' if speaker_change else 'low',
            'reason': reason if speaker_change else 'continuation'
        })

    return speakers

def detect_speaker_roles(speakers: List[Dict]) -> Dict[str, str]:
    """Attempt to identify speaker roles based on content patterns."""
    roles = {}

    for speaker_id in set(s['speaker'] for s in speakers):
        speaker_text = ' '.join([s['text'] for s in speakers if s['speaker'] == speaker_id])
        words = speaker_text.split()

        # Count indicators
        questions = len(re.findall(r'\?', speaker_text))
        first_person = len(re.findall(r'\b(?:I|I\'m|I have|my|we|we\'ve)\b', speaker_text, re.IGNORECASE))
        second_person = len(re.findall(r'\b(?:you|your|you\'re)\b', speaker_text, re.IGNORECASE))
        technical_terms = len(re.findall(r'\b(?:algorithm|data|model|code|API|system|AI|machine learning|neural network)\b', speaker_text, re.IGNORECASE))
        career_terms = len(re.findall(r'\b(?:career|job|opportunity|skill|experience|resume|interview)\b', speaker_text, re.IGNORECASE))
        greeting_terms = len(re.findall(r'\b(?:hello|hi|welcome|introduce|thank you|thanks)\b', speaker_text, re.IGNORECASE))

        # Determine role based on patterns
        if greeting_terms > 2:  # Host/introducer
            roles[speaker_id] = "Host/Introducer"
        elif questions > len(words) * 0.02 and second_person > len(words) * 0.02:  # Many questions, addressing "you"
            roles[speaker_id] = "Interviewer/Moderator"
        elif career_terms > len(words) * 0.02:  # Career-focused content
            if first_person > len(words) * 0.05:
                roles[speaker_id] = "Career Advisor/Speaker"
            else:
                roles[speaker_id] = "Career Expert"
        elif technical_terms > len(words) * 0.01:  # Technical content
            roles[speaker_id] = "Technical Expert/Professor"
        elif first_person > len(words) * 0.08:  # Very high first person usage
            roles[speaker_id] = "Main Speaker/Presentor"
        elif len(words) > 1000:  # Long segments
            roles[speaker_id] = "Primary Speaker"
        else:
            roles[speaker_id] = "Guest/Participant"

    return roles

def create_speaker_labeled_transcript(speakers: List[Dict], roles: Dict[str, str], output_file: str):
    """Create a transcript with speaker labels in the requested format."""

    with open(output_file, 'w', encoding='utf-8') as f:
        from datetime import datetime

        # Header
        f.write(f"TRANSCRIPT - {datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}\n")
        f.write("=" * 50)
        f.write("\n\n")

        current_speaker = None
        current_text = []

        for entry in speakers:
            # Format timestamp as [MM:SS]
            total_seconds = int(entry['timestamp'].total_seconds())
            minutes = total_seconds // 60
            seconds = total_seconds % 60
            timestamp_str = f"[{minutes:02d}:{seconds:02d}]"

            # Check if speaker changed
            if entry['speaker'] != current_speaker:
                # Write previous speaker's accumulated text
                if current_text and current_speaker:
                    # Combine all text for this speaker
                    full_text = ' '.join(current_text)
                    f.write(f"{timestamp_str} {current_speaker}: {full_text}\n")
                    current_text = []

                current_speaker = entry['speaker']

            # Add text to current accumulation
            current_text.append(entry['text'])

        # Write the last speaker's text
        if current_text and current_speaker:
            total_seconds = int(speakers[-1]['timestamp'].total_seconds())
            minutes = total_seconds // 60
            seconds = total_seconds % 60
            timestamp_str = f"[{minutes:02d}:{seconds:02d}]"
            full_text = ' '.join(current_text)
            f.write(f"{timestamp_str} {current_speaker}: {full_text}\n")

def create_summary_outline(speakers: List[Dict], roles: Dict[str, str], output_file: str):
    """Create a summary outline based on speaker segments."""

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Summary Outline\n\n")

        # Group by speaker
        speaker_points = {}

        for entry in speakers:
            speaker = entry['speaker']
            if speaker not in speaker_points:
                speaker_points[speaker] = []

            # Extract key points (simple heuristic)
            text = entry['text']
            if any(word in text.lower() for word in ['important', 'key', 'main', 'primary', 'critical']):
                speaker_points[speaker].append(f"- KEY POINT: {text[:200]}...")
            elif len(text.split()) > 10:  # Substantial contribution
                speaker_points[speaker].append(f"- {text[:200]}...")

        # Write summary
        for speaker, points in speaker_points.items():
            role = roles.get(speaker, "Speaker")
            f.write(f"## {speaker} ({role})\n\n")

            # Limit points to avoid too much content
            for point in points[:5]:
                f.write(f"{point}\n")

            f.write("\n")

def main():
    if len(sys.argv) != 2:
        print("Usage: python speaker_diarization.py <vtt_file>")
        sys.exit(1)

    vtt_file = sys.argv[1]

    if not os.path.exists(vtt_file):
        print(f"Error: File {vtt_file} not found")
        sys.exit(1)

    print(f"Processing {vtt_file} for speaker diarization...")

    # Load and process transcript
    entries = load_vtt_transcript(vtt_file)
    print(f"Loaded {len(entries)} transcript entries")

    # Identify speakers
    speakers = identify_speakers(entries)
    unique_speakers = len(set(s['speaker'] for s in speakers))
    print(f"Identified {unique_speakers} potential speakers")

    # Detect speaker roles
    roles = detect_speaker_roles(speakers)

    # Output files
    base_name = os.path.splitext(vtt_file)[0]
    speaker_file = f"{base_name}_speakers.txt"
    summary_file = f"{base_name}_summary_outline.md"

    # Create outputs
    create_speaker_labeled_transcript(speakers, roles, speaker_file)
    create_summary_outline(speakers, roles, summary_file)

    print(f"\nCreated speaker-labeled transcript: {speaker_file}")
    print(f"Created summary outline: {summary_file}")

    # Print speaker summary
    print("\nIdentified Speakers:")
    for speaker, role in roles.items():
        print(f"- {speaker}: {role}")

if __name__ == "__main__":
    main()