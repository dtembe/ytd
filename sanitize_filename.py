#!/usr/bin/env python3
"""
Sanitize filename by removing special characters
Replaces with underscores and hyphens only
"""

import sys
import re

def sanitize_filename(filename):
    """Sanitize a filename by removing special characters."""
    # Remove or replace special characters
    # Keep letters, numbers, spaces, hyphens, and underscores
    sanitized = re.sub(r'[^\w\s\-_]', '', filename)

    # Replace multiple spaces with single space
    sanitized = re.sub(r'\s+', ' ', sanitized)

    # Replace spaces with underscores for filenames (but keep spaces in content)
    # For the base filename part, replace spaces with underscores
    if '.' in filename:
        name_part, ext_part = filename.rsplit('.', 1)
        name_part = re.sub(r'[-\s]+', '_', name_part.strip())
        return f"{name_part}.{ext_part}"
    else:
        return re.sub(r'[-\s]+', '_', sanitized.strip())

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python sanitize_filename.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]
    print(sanitize_filename(filename))