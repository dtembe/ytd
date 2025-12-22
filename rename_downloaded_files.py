#!/usr/bin/env python3
"""
Rename downloaded files to sanitize filenames
"""

import os
import re
import sys
import glob
from pathlib import Path

def sanitize_filename(filename):
    """Sanitize a filename by removing special characters."""
    # Split into name and extension
    if '.' in filename:
        name_part, ext_part = filename.rsplit('.', 1)
    else:
        name_part, ext_part = filename, ''

    # Remove or replace special characters
    # Keep letters, numbers, spaces, hyphens, and underscores
    sanitized = re.sub(r'[^\w\s\-_]', '', name_part)

    # Replace multiple spaces/hyphens with single underscore
    sanitized = re.sub(r'[\s\-]+', '_', sanitized.strip())

    # Remove leading/trailing underscores
    sanitized = sanitized.strip('_')

    # Rejoin with extension
    if ext_part:
        return f"{sanitized}.{ext_part}"
    else:
        return sanitized

def rename_files_in_directory(directory):
    """Rename all files in directory to have sanitized names."""
    directory = Path(directory)

    # Get all files
    files_to_rename = []
    for ext in ['*.mkv', '*.mp4', '*.webm', '*.vtt', '*.txt', '*.json', '*.description']:
        files_to_rename.extend(directory.glob(ext))

    renamed_files = []

    for file_path in files_to_rename:
        old_name = file_path.name
        new_name = sanitize_filename(old_name)

        if new_name != old_name:
            new_path = file_path.parent / new_name

            # Check if new file already exists
            if new_path.exists():
                base, ext = os.path.splitext(new_name)
                counter = 1
                while new_path.exists():
                    new_name = f"{base}_{counter}{ext}"
                    new_path = file_path.parent / new_name
                    counter += 1

            try:
                file_path.rename(new_path)
                renamed_files.append((old_name, new_name))
                print(f"Renamed: {old_name}")
                print(f"  To: {new_name}")
                print()
            except Exception as e:
                print(f"Error renaming {old_name}: {e}")

    return renamed_files

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python rename_downloaded_files.py <directory>")
        sys.exit(1)

    directory = sys.argv[1]

    if not os.path.exists(directory):
        print(f"Error: Directory {directory} not found")
        sys.exit(1)

    print(f"Sanitizing filenames in: {directory}")
    print("=" * 50)

    renamed = rename_files_in_directory(directory)

    if renamed:
        print(f"\nRenamed {len(renamed)} file(s)")
    else:
        print("\nNo files needed renaming")