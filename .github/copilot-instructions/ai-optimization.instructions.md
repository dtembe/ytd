---
title: AI Context Optimization
description: Guidelines for optimizing prompts for AI efficiency
version: 1.0.0
updated: 2025-03-01
---

# AI Context Optimization

This module provides guidelines for creating efficient AI prompts that maximize performance and token usage.

## 1. Prompt Efficiency Guidelines

- Keep instructions concise and precise
- Use clear, deterministic language
- Avoid redundant information
- Maintain high information density with minimal tokens
- Focus on machine-actionable instructions

## 2. Token Efficiency

- Limit examples to essential patterns only
- Use hierarchical structure for quick parsing
- Remove redundant information across sections
- Maintain high information density with minimal tokens
- Focus on machine-actionable instructions over human explanations

## 3. Effective Examples

- ✅ **Good:** "Extract phone numbers using regex pattern \d{3}-\d{3}-\d{4}"
- ❌ **Bad:** "Please try to find phone numbers in the text by looking for patterns that might represent phone numbers in various formats"

- ✅ **Good:** "Return JSON with keys: name, age, email"
- ❌ **Bad:** "Could you please format the response as a JSON object that includes the user's name, their age, and their email address?"

- ✅ **Good:** "Code a function that validates emails using RFC 5322"
- ❌ **Bad:** "I would like you to create a function that can check if an email is valid according to the standard specifications"

## 4. Command Clarity

- Use imperative language
- Specify formats explicitly
- Define expected outputs precisely
- Include validation criteria
- Provide constraints upfront

Examples:

- ✅ **Good:** "Generate a PostgreSQL query to find users who joined after 2023-01-01, limit 10"
- ❌ **Bad:** "Can you help me find users who joined recently?"

- ✅ **Good:** "Debug error: TypeError: cannot read property 'id' of undefined at line 23"
- ❌ **Bad:** "My code isn't working, can you help me figure out why?"

## 5. Structure Optimization

- Use numbered lists for sequential instructions
- Use bulleted lists for options or alternatives
- Use tables for structured data
- Use code blocks with language specifiers
- Use headers for logical sections

## 6. Critical Practices

- NEVER include verbose explanations or redundant context that increases AI token overhead
- Keep instructions as short and to the point as possible WITHOUT sacrificing clarity
- Use specialized modules rather than generic instructions
- Combine only relevant instruction modules for specific tasks
- Test prompts with minimal token usage to ensure efficiency

## 7. Project Directory-Specific Context Handling

### S1 Development Context (_s1Dev/)
When working in the S1 development context:
- Explicitly state the project is for S1 PowerPack development
- Focus on S1 platform constraints and requirements
- Reference S1 naming conventions and file structures
- Refer to `__s1libs/` for standard libraries
- Use templates from `__s1templates/` for boilerplate code
- Example prompt improvement:
  - ❌ **Bad:** "Create a script to monitor disk space"
  - ✅ **Good:** "Create an S1 Dynamic Application with SSH collection to monitor disk space for AIX systems to be stored in /home/em7admin/pyDev/_s1Dev/_sshAixFs/"

### Non-S1 Development Context (_nonS1Dev/)
When working in non-S1 development context:
- Explicitly state the project is not for S1 platform
- Focus on general Python best practices
- Reference standard project structures
- Indicate the specific non-S1 subfolder for the project
- Example prompt improvement:
  - ❌ **Bad:** "Create a log monitoring script"
  - ✅ **Good:** "Create a standalone log monitoring Python application under /home/em7admin/pyDev/_nonS1Dev/logMon/ with standard package structure"

### Copilot Development Context (_copilotDev/)
When working on GitHub Copilot enhancement projects:
- Explicitly state the project is for GitHub Copilot enhancement
- Focus on AI interaction patterns and information exchange
- Reference relevant documentation standards
- Specify the appropriate directory under _copilotDev/
- Example prompt improvement:
  - ❌ **Bad:** "Create a system for transferring context"
  - ✅ **Good:** "Create a GitHub Copilot handoff system under /home/em7admin/pyDev/_copilotDev/ to maintain context between development sessions"

### Skylar Automation Development Context (_sautoDev/)
When working on Skylar Automation (formerly PowerFlow) SyncPack projects:
- Explicitly state the project is for Skylar Automation SyncPack development
- Focus on step-based architecture and workflow automation
- Reference BaseStep class and SyncPack structure
- Specify the appropriate directory under _sautoDev/
- Example prompt improvement:
  - ❌ **Bad:** "Create an integration with ServiceNow"
  - ✅ **Good:** "Create a Skylar Automation SyncPack under /home/em7admin/pyDev/_sautoDev/servicenow_integration/ with steps for incident creation, updates, and closure using BaseStep pattern"

### Scratch Files Context (scratchFiles/)
When working with temporary development files:
- Explicitly state the file is temporary or for testing
- Indicate that the file will be placed in the scratch directory
- Example prompt improvement:
  - ❌ **Bad:** "Write a test script for this functionality"
  - ✅ **Good:** "Create a temporary test script in /home/em7admin/pyDev/scratchFiles/ to validate the JSON parsing function"

## 8. Path Reference Optimization
When referencing file paths in prompts:
- Use absolute paths for clarity
- Group related files by directory
- Use consistent path formats
- Example path reference:
  - ❌ **Bad:** "Create files in the project folder"
  - ✅ **Good:** "Create the following files under /home/em7admin/pyDev/_s1Dev/_apiNewService/:"

## 9. Context Switching Efficiency
When switching between project contexts:
- Explicitly state the context change
- Provide clear directory transitions
- Summarize context-specific constraints
- Example context switch:
  - ✅ **Good:** "Switching from S1 development to non-S1 context. The following files should be created under /home/em7admin/pyDev/_nonS1Dev/new_project/ using standard Python project structure..."