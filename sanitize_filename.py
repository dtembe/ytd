#!/usr/bin/env python3
"""
Sanitize filename by removing special characters.
For batch operations on directories, use rename_downloaded_files.py instead.
"""

import sys
import re


def sanitize_filename(filename):
    """Sanitize a filename by removing special characters."""
    if '.' in filename:
        name_part, ext_part = filename.rsplit('.', 1)
        name_part = re.sub(r'[^\w\s\-_]', '', name_part)
        name_part = re.sub(r'[-\s]+', '_', name_part.strip())
        return f"{name_part}.{ext_part}"
    else:
        sanitized = re.sub(r'[^\w\s\-_]', '', filename)
        return re.sub(r'[-\s]+', '_', sanitized.strip())

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python sanitize_filename.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]
    print(sanitize_filename(filename))