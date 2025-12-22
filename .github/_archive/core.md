---
title: Core Instructions
description: Essential guidelines for AI-generated code
version: 1.0.0
updated: 2025-03-01
---

# GitHub Copilot Modular Instructions

## Usage Guide

This is a modular instruction system to optimize GitHub Copilot's performance by loading only relevant instructions for specific tasks.

### How to Use

1. **Loading Instructions:**

   ```bash
   # Load core instructions only
   cat .github/copilot-instructions/core.md | copilot

   # Load shell development instructions
   cat .github/copilot-instructions/core.md .github/copilot-instructions/shell-commands.md | copilot

   # Load documentation instructions
   cat .github/copilot-instructions/core.md .github/copilot-instructions/documentation.md | copilot

   # Load SL1 development instructions
   cat .github/copilot-instructions/core.md .github/copilot-instructions/sl1-development.md | copilot

   # Combine multiple instruction sets
   cat .github/copilot-instructions/core.md .github/copilot-instructions/file-operations.md .github/copilot-instructions/security.md | copilot
   ```

2. **Available Modules:**

   - `core.md` - Essential instructions (always include)
   - `shell-commands.md` - Shell scripting guidelines
   - `sl1-development.md` - SL1 platform development rules
   - `file-operations.md` - File handling and backups
   - `security.md` - Security best practices
   - `documentation.md` - Documentation standards
   - `rule-structure.md` - Rule format standards
   - `ai-optimization.md` - AI context optimization

3. **Helper Script:**

   You can use the provided `load_copilot.sh` helper script:
   ```bash
   # Usage: ./load_copilot.sh [module1] [module2] ...
   ./load_copilot.sh shell security
   ```

---

# Core Instructions

This document provides essential guidelines for AI-generated code using GitHub Copilot. These core instructions should be included in every prompt.

## 1. General Response Protocol

- **Response Format:**
  - **Start:** Responses must begin with:
    ```
    Thinking ....,
    ```
  - **End:** Responses must conclude with:
    ```
    Thank you, Sir
    ```

## 2. Date Verification

- If a task requires the current date (e.g., for file backups), obtain it as the **first step**:
  - **Linux/Mac:**
    ```bash
    date +%Y_%m_%d
    ```
  - **Windows:**
    ```cmd
    cmd /c date /t
    ```

## 3. Changelog and Version Management

- **Changelog Updates:**
  - Always update `Changelog.md` under `[Unreleased]` when making changes.
- **Version Bumping:**
  - Update `bundleVersion` in `ProjectSettings.asset` when releasing a new version.
- **Staged Changes:**
  - Ensure all modifications are reflected in the changelog before committing.

## 4. Release Process

- **Review `[Unreleased]`** to determine the version bump:
  - **Features** → Minor update
  - **Fixes** → Patch update
  - **Breaking Changes** → Major update
- **Release Steps:**
  1. Move documented changes to a new version section with the release date.
  2. Update `bundleVersion`.
  3. Commit using:
     ```
     release: Version X.Y.Z
     ```
  4. Create a Git tag.

## 5. Memory Retrieval Protocol

- **Start every session with:**
  ```
  Remembering...
  ```
  - Retrieve all relevant data from the knowledge graph (referred to as "memory").

## 6. Environment Specifications

- **OS:** Oracle Linux 8
- **Shell Environment:**
  - Use `bash` or `sh` (**no PowerShell**).
  - Always include proper shebang: `#!/bin/bash`
  - Implement robust error handling.
  - Validate environment before execution.
- **Python Environment:**
  - Use system Python3 as default.
  - Validate environment before execution.
  - Implement virtual environments when required.
  - Use proper path handling for Linux environments.
  - NEVER use Python environment specification (`#!/usr/bin/env python3`).