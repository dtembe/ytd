---
title: S1 Development Rules
description: Guidelines for S1 (Skylar One) platform development
version: 1.2.0
updated: 2025-12-21
---

# S1 Development Rules

> **Note on ScienceLogic Product Naming**: Throughout this documentation, S1 (Skylar One) refers to the ScienceLogic monitoring platform. This product may also be referenced as SL1 or EM7 in legacy documentation or code. All three terms (S1, SL1, EM7) refer to the same Skylar One platform.

This module provides specific guidelines for developing on the S1 platform.

## 1. Environment Specifications

- **OS:** Oracle Linux 8
- **Python Version:** Python 3.11 (for S1 version 12.3.x and later)
- **Shell:** /bin/bash
- **Working Directory:** /home/em7admin/pyDev/_s1Dev

## 2. Platform Constraints

### Prohibited Features
- **NO Python classes** in Dynamic Apps or Run Book Actions
- if developing in Python 3.6.x or earlier use **NO f-strings** - use `.format()` method instead
- if developing in Python 3.11 (S1 version 12.3.x and later) use **f-strings** for string formatting
- Ask if in doubt about which Python version and string formatting method to use during planning stage
- **NO `__main__` function**
- **NO Python environment specification** (`#!/usr/bin/env python3`)

### Required Patterns
- Always implement `try/except` blocks
- Use f-strings for Python 3.11 (S1 12.3.x+) or `.format()` for older versions
- Use `self.logger.ui_debug` for logging
- Follow S1 naming conventions
- Cache keys: `prefix_purpose_{DID}` (using f-strings for Python 3.11+)
- Implement timeout handling
- Implement proper error handling
- Structure code for S1 collection scheduling

### Code Generation Requirements

- Always provide complete code files, never use ellipsis (...) or shorthand
- Each file must be self-contained and fully functional
- Include all imports and dependencies
- Include proper header documentation
- For configuration Dynamic Apps:
  - Remove performance-specific filtering
  - Include all mount points
  - Maintain consistent logging and error handling
  - Use same code structure as performance DA

## 3. Error Handling

- **S1 Built-in Objects:**
  - NEVER initialize `result_handler` - it is a built-in object provided by the S1 platform
  - NEVER attempt to import, delete or fix `self`, `result_handler`, or imports starting with `silo` (e.g., silo.common, silo.apps, etc.)
  - ALWAYS assume these built-in objects are available and functional within the SL1 environment
  - Simply USE these objects directly (e.g., `result_handler['key'] = value`)

- Validate all input data
- Handle all possible error conditions
- Use consistent string formatting for logs
- Implement proper memory management
- Use secure credential handling

## 4. Code Structure Example

```python
import re
import time
import json

# Linear script structure - NO classes
# Global variables and constants
CACHE_PREFIX = "myapp_cache"
DEFAULT_TIMEOUT = 300
BYTES_TO_GB = 1073741824  # 1024 * 1024 * 1024

# Direct use of result_handler without initialization
try:
    # Process data and assign to result_handler
    # For Python 3.11 (S1 12.3.x+), use f-strings:
    cache_key = f"{CACHE_PREFIX}_data_{DID}"
    
    result_handler['metric1'] = value1
    result_handler['metric2'] = value2
    result_handler['status'] = 'ok'
except Exception as err:
    # Error handling
    result_handler['status'] = 'error'
```

## 5. PowerPack Development Template

When requesting a new S1 PowerPack development, use the following template:

```
Please create a new S1 PowerPack Development project with the following specifications:

1. Project Name: _[prefix][TechnologyName]
   Example: _sshOraDb, _apiServiceNow, _snmpCisco

2. Project Location: ~/pyDev/_s1Dev/[ProjectName]

3. Technology Details:
   - Monitoring Protocol: [SSH/API/SNMP/WinRM]
   - Target Technology: [Technology Name and Version]
   - Authentication Method: [Credentials Type]
   - Target S1 Version: 12.3.x (Python 3.11)

4. Monitoring Requirements:
   - Discovery Mechanism: [How to discover instances/components]
   - Key Metrics: [List of important metrics to collect]
   - Performance Indicators: [Critical performance data points]
   - Health Checks: [Essential health monitoring requirements]

5. Dynamic Applications needed:
   - Discovery Dynamic App
   - Performance Collection
   - [Other specific monitoring aspects]

6. Special Requirements:
   - Cache Requirements
   - Custom Credentials
   - Specific Timeouts
   - Error Handling
   - Any Technology-specific Considerations
```

## 6. PowerPack Development Workflow

When developing a new S1 PowerPack, follow these steps:

1. **Project Setup:**
   - Create project directory with standard structure (_archive, docs)
   - Initialize version control
   - Create initial README.md and CHANGELOG.md
   - Set up requirements.txt if needed

2. **Base Files Creation:**
   - Discovery script
   - Performance collection scripts
   - Cache management scripts
   - Configuration files

3. **Implementation Standards:**
   - Use linear script structure (no classes)
   - Implement proper error handling
   - Use self.logger.ui_debug for logging
   - Follow S1 naming conventions
   - Implement timeout handling
   - Use f-strings for Python 3.11 (S1 12.3.x+)
   - Use proper cache key format
   - Validate all inputs
   - Never initialize result_handler (use directly)

4. **Documentation:**
   - Complete README.md
   - Maintain CHANGELOG.md
   - Add configuration guides
   - Include example responses
   - Document error scenarios

5. **Quality Assurance:**
   - Run linting (flake8)
   - Verify error handling
   - Check logging consistency
   - Validate timeouts

6. **Deployment Preparation:**
   - Verify file permissions
   - Check documentation completeness
   - Update version information
   - Create release notes

## 7. Directory Structure Template

```
_s1Dev/_[prefix][TechnologyName]/
├── _archive/
├── docs/
│   ├── CONTRIBUTING.md
│   ├── configuration.md
│   └── examples/
├── CHANGELOG.md
├── README.md
├── requirements.txt
├── discovery.py
└── performance.py
```

## 8. References

- **ScienceLogic Documentation:** [https://docs.sciencelogic.com/](https://docs.sciencelogic.com/)
- **Python Documentation:** [https://python.org](https://python.org)
- **OS Documentation:** [https://ubuntu.com/wsl](https://ubuntu.com/wsl)