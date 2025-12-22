### General Rules ###
- Always start responses with 'Thinking ....,' followed by a newline.
- Always end responses with 'Thank you, Sir' followed by a newline.
- When any tasks require current date, ensure that as the FIRST STEP, the current date is first obtained by running the appropriate terminal command so that the value is known before performing any follow up tasks. For example: when backing-up a file, there is a requirement to append the date to the backup file, so it is expected that the current date is verified in the terminal using the command: date +%Y_%m_%d for Linux/Mac, or cmd /c date /t for Windows.
- ALWAYS update the Changelog.md under [Unreleased] when making changes, and update the version number (bundleVersion) in ProjectSettings.asset when releasing a new version.
- When asked to commit staged changes, verify that all changes in the staged files are properly reflected in the changelog before committing.

- When releasing:
  - Review [Unreleased] changes to determine the version bump (features → minor, fixes → patch, breaking → major).
  - Move the changes to a new version section with the release date.
  - Update the bundleVersion in ProjectSettings.asset.
  - Commit using the message "release: Version X.Y.Z" and create a git tag.

###Memory Retrieval:
   - Always begin your chat by saying only "Remembering..." and retrieve all relevant information from your knowledge graph
   - Always refer to your knowledge graph as your "memory"

### Environment Specifications ###
- **Operating System**: Oracle Linux 8 
- **Shell Environment**:
  - Use bash or sh for all shell operations.
  - NEVER use PowerShell commands.
  - Always use a proper shebang (#!/bin/bash) in shell scripts.
  - Implement proper error handling in shell scripts.
- **Python Environment**:
  - Use system Python3 as default.
  - Validate the Python environment before executing scripts.
  - Implement virtual environments when required.
  - Use proper path handling for Linux environments.

### Shell Command Guidelines ###
- ALWAYS change to the working directory before executing commands:
  ```bash
  # Correct way
  cd /path/to/working/directory && ./script.sh
  # Or use absolute paths
  /path/to/working/directory/script.sh
  ```
- NEVER execute commands without ensuring the proper directory context.
- VERIFY the working directory before execution:
  ```bash
  pwd  # Verify current directory
  [[ -f "./script.sh" ]] && ./script.sh  # Check file existence before executing
  ```
- Use absolute paths for critical operations and automation:
  ```bash
  /usr/bin/python3 /full/path/to/script.py
  ```
- Keep commands POSIX-compliant whenever possible.
- Use proper error handling with exit codes.
- Implement logging for shell operations.
- Validate command existence before execution.
- Implement timeout handling for long-running commands.
- Ensure proper file permissions and ownership.
- Handle special characters with proper escaping.
- Use environment variables appropriately.
- Implement signal handling.
- Validate all required files exist in the working directory before executing.
- Validate directories before executing commands:
  ```bash
  if [[ -d "/path/to/working/dir" ]]; then
    cd "/path/to/working/dir" || exit 1
    ./script.sh
  else
    echo "Error: Working directory not found" >&2
    exit 1
  fi
  ```

### SL1 Development Specific Rules ###
CRITICAL RULES for SL1 Development:
- DO NOT use Python classes in Dynamic Applications or Run Book Actions; use a linear script structure.
- DO NOT use f-strings (Python 3.6+ feature) – use the .format() method instead.
- DO NOT use a __main__ function in Dynamic Applications or Run Book Actions.
- Always implement proper error handling with try/except blocks.
- Always use proper logging with self.logger.ui_debug.
- Always follow SL1 naming conventions for variables and functions.
- Use the cache key naming format: 'prefix_purpose_{}' with .format(DID).
- NEVER use the Python environment specification (#!/usr/bin/env python3).
- Implement timeout handling for all external operations.
- Use consistent string formatting for all log messages.
- Handle all possible error conditions.
- Validate all input data before processing.
- Implement proper memory management.
- Use secure practices for credential handling.
- Refer to Python documentation at https://docs.python.org/3/
- Refer to OS documentation for Ubuntu 24.04 LTS on Windows 10 x86_64, at https://learn.microsoft.com/en-us/windows/wsl/ and https://ubuntu.com/wsl
- Refer to the SL1 Development Guide for detailed information on the development process and best practices.

### File Operations and Management ###
- Use Linux path separators (forward slash /).
- Implement proper file permissions (chmod).
- Use appropriate user/group ownership (chown).
- Handle symbolic links appropriately.
- Implement robust error handling for all file operations.
- Use file locking mechanisms when needed.
- Validate file existence before performing operations.
- Handle file path special characters.
- Implement proper backup procedures.
- Use appropriate temporary file handling.

### File Backup Rules ###
When creating backup files:
1. ALWAYS create a complete copy of the entire source file.
2. Use the following naming convention:
   - Append the date in the format: YYYY_MM_DD_XX.
   - XX starts at 00 and increments if the file exists.
   - Example: filename_2024_03_14_00.py, filename_2024_03_14_01.py.
3. NEVER use placeholders like "# rest of the code is same".
4. Place backup files in the _archive directory (if it exists).
5. Maintain all comments, formatting, and whitespace from the original file.
6. Include the complete file header and all imports.
7. Verify that the backup file is an exact copy before proceeding with changes.
8. Set the appropriate Linux file permissions and ownership.
9. Use proper Linux commands for file operations:
   ```bash
   cp -p original.py _archive/original_$(date +%Y_%m_%d)_00.py
   chmod --reference=original.py _archive/original_*.py
   chown --reference=original.py _archive/original_*.py
   ```

Example backup process:
1. Original file: getCerts.py
2. Backup file: _archive/getCerts_2024_03_14_00.py
3. If getCerts_2024_03_14_00.py exists, create getCerts_2024_03_14_01.py.
4. Copy the ENTIRE content of the original file to the backup using appropriate Linux commands.
5. Verify the file permissions and ownership.
6. Only then proceed with modifications to the original file.

### Security Best Practices ###
- Implement proper file permissions (chmod).
- Use appropriate user/group permissions.
- Handle sensitive data securely.
- Implement proper credential management.
- Use secure temporary file handling.
- Validate input data.
- Implement proper logging.
- Use appropriate environment variables.
- Handle errors appropriately.
- Implement timeout handling.