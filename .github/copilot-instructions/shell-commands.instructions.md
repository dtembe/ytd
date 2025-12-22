---
title: Shell Command Guidelines
description: Guidelines for shell scripting with GitHub Copilot
version: 1.0.0
updated: 2025-03-01
---

# Shell Command Guidelines

This module provides comprehensive guidelines for shell scripting in Linux environments.

## 1. Directory Context

Always verify and change to the working directory before executing commands:

```bash
# ALWAYS verify and change to working directory first
if [[ -d "/path/to/working/dir" ]]; then
  cd "/path/to/working/dir" || exit 1
  ./script.sh
else
  echo "Error: Working directory not found" >&2
  exit 1
fi
```

## 2. File Validation

Always validate file existence before operations:

```bash
pwd  # Verify current directory
[[ -f "./script.sh" ]] && ./script.sh  # Check file existence
```

## 3. Best Practices

- Use absolute paths for critical operations
- Keep commands POSIX-compliant
- Implement proper error handling with exit codes
- Use logging for operations
- Validate command existence
- Implement timeout handling
- Handle special characters properly
- Use environment variables appropriately
- Implement signal handling

## 4. Script Structure

```bash
#!/bin/bash
set -eo pipefail  # Exit on error, fail on pipe errors

# Define constants
readonly CONFIG_FILE="/path/to/config"
readonly LOG_FILE="/path/to/logfile.log"

# Define functions
log_message() {
  local message="$1"
  local timestamp
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[${timestamp}] $message" >> "$LOG_FILE"
}

check_dependencies() {
  for cmd in grep awk sed; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "Error: Required command not found: $cmd" >&2
      exit 1
    fi
  done
}

# Validate environment
check_dependencies

# Main execution logic
if [[ ! -f "$CONFIG_FILE" ]]; then
  log_message "Error: Config file not found"
  exit 1
fi

# Process with proper error handling
log_message "Starting process"
if ! some_command; then
  log_message "Error: Command failed"
  exit 1
fi
log_message "Process completed successfully"
```