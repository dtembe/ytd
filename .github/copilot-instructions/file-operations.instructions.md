---
title: File Operations & Management
description: Guidelines for file handling and backup procedures
version: 1.0.0
updated: 2025-03-01
---

# File Operations & Management

This module provides guidelines for file operations, permissions, and backup procedures.

> **Note on ScienceLogic Product Naming**: Throughout this documentation, S1 (Skylar One) refers to the ScienceLogic monitoring platform (also known as SL1 or EM7). Skylar Automation refers to the automation platform (formerly PowerFlow, also known as PF or SAUTO).

## 1. Directory Structure Context

When working with files in the `/home/em7admin/pyDev/` workspace, consider the following directory structure guidelines:

### S1 Development Files (_s1Dev/)
- All S1-related code should be placed in the `_s1Dev/` directory
- Follow the naming conventions for S1 projects (e.g., `_api`, `_snmp`, `_ssh` prefixes)
- Create `_archive/` subdirectories for backup files within each project folder
- Use `__s1libs/` for shared libraries and utilities
- Use `__s1templates/` for project templates and boilerplate code

### Non-S1 Development Files (_nonS1Dev/)
- All non-S1 related projects should be placed in the `_nonS1Dev/` directory
- Follow standard Python project structure with dedicated folders per project
- Create `_archive/` subdirectories for backup files within each project folder
- Use appropriate subdirectories for different components (e.g., `docs/`, `tests/`, `src/`)

### Copilot Development Files (_copilotDev/)
- All GitHub Copilot enhancement projects should be placed in the `_copilotDev/` directory
- Follow standard project structure with documentation and version control
- Create appropriate subdirectories for different components and modules

### Temporary Development Files (scratchFiles/)
- Use for temporary development and testing files
- Do not store production code in this directory
- Files may be deleted or archived during maintenance

### Skylar Automation Development Files (_sautoDev/)
- All Skylar Automation (formerly PowerFlow) SyncPack projects should be placed in the `_sautoDev/` directory
- Follow SyncPack structure with dedicated folders per project
- Create `_archive/` subdirectories for backup files within each project folder
- Use appropriate subdirectories for steps, configurations, and tests

## 2. Path and Permissions

- Use Linux path separators (`/`)
- Set proper `chmod` permissions
- Set proper `chown` ownership
- Handle symbolic links appropriately
- Implement file locking where needed
- Validate file existence before operations
- Handle special characters in paths
- Use secure temporary file handling

## 3. File Manipulation Examples

```bash
# File existence check
if [[ ! -f "$config_file" ]]; then
  echo "Error: Config file not found: $config_file" >&2
  exit 1
fi

# Directory existence/creation
if [[ ! -d "$log_dir" ]]; then
  mkdir -p "$log_dir" || {
    echo "Error: Failed to create log directory: $log_dir" >&2
    exit 1
  }
fi

# File permissions
chmod 640 "$config_file"  # Read-write for owner, read for group
chown user:group "$config_file"

# Secure temporary file
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT INT TERM
```

## 4. File Backup Procedures

- **Backup Creation:**
  - Create complete file copies
  - Use naming format: `filename_YYYY_MM_DD_XX.ext`
  - Store in `_archive` directory (create if missing)
  - Maintain all formatting and comments
  - Verify backup integrity

- **Example Commands:**
  ```bash
  # Get current date
  current_date=$(date +%Y_%m_%d)
  
  # Create _archive directory if it doesn't exist
  [[ -d "_archive" ]] || mkdir -p "_archive"
  
  # Create backup with proper permissions
  cp -p original.py "_archive/original_${current_date}_00.py"
  
  # Preserve permissions and ownership
  chmod --reference=original.py "_archive/original_${current_date}_00.py"
  chown --reference=original.py "_archive/original_${current_date}_00.py"
  
  # Verify backup integrity
  diff -q original.py "_archive/original_${current_date}_00.py" || {
    echo "Error: Backup verification failed" >&2
    exit 1
  }
  ```

## 5. Project-Specific File Operations

### S1 File Operations

When working with S1 projects in `_s1Dev/`:
```bash
# Example: Create a new S1 project from template
project_name="_apiNewService"
project_path="/home/em7admin/pyDev/_s1Dev/${project_name}"

# Create project directory
mkdir -p "${project_path}"
mkdir -p "${project_path}/_archive"
mkdir -p "${project_path}/docs/examples"

# Copy template files
cp /home/em7admin/pyDev/_s1Dev/__s1templates/discovery_template.py "${project_path}/discovery.py"
cp /home/em7admin/pyDev/_s1Dev/__s1templates/README_template.md "${project_path}/README.md"

# Set permissions
chmod 755 "${project_path}/discovery.py"
```

### Non-S1 File Operations

When working with non-S1 projects in `_nonS1Dev/`:
```bash
# Example: Create a new Python package
project_name="new_utility"
project_path="/home/em7admin/pyDev/_nonS1Dev/${project_name}"

# Create project directory with standard Python structure
mkdir -p "${project_path}/src/${project_name}"
mkdir -p "${project_path}/tests"
mkdir -p "${project_path}/docs"
mkdir -p "${project_path}/_archive"

# Create initial files
touch "${project_path}/README.md"
touch "${project_path}/requirements.txt"
touch "${project_path}/setup.py"
touch "${project_path}/src/${project_name}/__init__.py"
```

### Copilot File Operations

When working with GitHub Copilot projects in `_copilotDev/`:
```bash
# Example: Create a new Copilot enhancement project
project_name="copilot_enhancement"
project_path="/home/em7admin/pyDev/_copilotDev/${project_name}"

# Create project directory
mkdir -p "${project_path}"
mkdir -p "${project_path}/docs"
mkdir -p "${project_path}/_archive"

# Create initial files
touch "${project_path}/README.md"
touch "${project_path}/CHANGELOG.md"
```

### Skylar Automation File Operations

When working with Skylar Automation (formerly PowerFlow) projects in `_sautoDev/`:
```bash
# Example: Create a new Skylar Automation SyncPack project
project_name="my_syncpack"
project_path="/home/em7admin/pyDev/_sautoDev/${project_name}"

# Create project directory with SyncPack structure
mkdir -p "${project_path}/${project_name}/steps"
mkdir -p "${project_path}/${project_name}/utils"
mkdir -p "${project_path}/tests"
mkdir -p "${project_path}/docs"
mkdir -p "${project_path}/_archive"
mkdir -p "${project_path}/apps"
mkdir -p "${project_path}/configs"

# Create initial files
touch "${project_path}/README.md"
touch "${project_path}/CHANGELOG.md"
touch "${project_path}/setup.py"
touch "${project_path}/requirements.txt"
touch "${project_path}/${project_name}/__init__.py"
touch "${project_path}/${project_name}/meta.json"
```

## 6. File Processing Patterns

- **Reading Files:**
  ```bash
  while IFS= read -r line; do
    # Process each line
    echo "Processing: $line"
  done < "$input_file"
  ```

- **Writing Files:**
  ```bash
  {
    echo "# Configuration file generated on $(date)"
    echo "parameter1=value1"
    echo "parameter2=value2"
  } > "$output_file"
  ```

- **Atomic File Operations:**
  ```bash
  # Write to temporary file first, then move atomically
  temp_file=$(mktemp)
  if process_data > "$temp_file"; then
    mv "$temp_file" "$output_file"
  else
    rm -f "$temp_file"
    echo "Error processing data" >&2
    exit 1
  fi
  ```