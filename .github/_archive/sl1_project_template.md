---
title: SL1 Project Template
description: Standard project structure and guidelines for SL1 development
version: 1.0.0
updated: 2024-04-08
---

# SL1 Project Template

## Project Structure

```
_[prefix][TechnologyName]/          # Main project directory (e.g., _apiServiceName)
├── _archive/                       # For archived/backup files
├── docs/                          # Project documentation
│   ├── configuration.md           # Configuration guide
│   ├── examples/                  # Example responses/outputs
│   └── troubleshooting.md        # Common issues and solutions
├── tests/                        # Test files
│   ├── __init__.py
│   ├── test_discovery.py
│   └── test_performance.py
├── cache/                        # Cache management scripts
│   ├── cache_producer.py
│   └── cache_consumer.py
├── CHANGELOG.md                  # Version history
├── README.md                     # Project documentation
└── requirements.txt              # Dependencies
```

## File Templates

### 1. Script Header Template
```python
"""
@fileoverview: Brief description of the script's purpose
@module: sl1-development
@author: Developer Name
@created: YYYY-MM-DD
@last_modified: YYYY-MM-DD
@version: 1.0.0
"""

import os
import sys
import time
import json

# Global constants
CACHE_PREFIX = "prefix_purpose"
DEFAULT_TIMEOUT = 300

# No classes for Dynamic Apps or Run Book Actions
# Linear script structure
```

### 2. Function Template
```python
def function_name(param1, param2):
    """
    Function description.
    
    Args:
        param1: Description
        param2: Description
        
    Returns:
        Description of return value
        
    Raises:
        Exception types and conditions
    """
    try:
        # Input validation
        if not param1:
            self.logger.ui_debug("Invalid param1: {}".format(param1))
            return None
            
        # Main logic
        result = process_data(param1, param2)
        
        # Success logging
        self.logger.ui_debug("Successfully processed: {}".format(param1))
        return result
        
    except Exception as e:
        self.logger.ui_debug("Error in function_name: {}".format(str(e)))
        return None
```

## Development Guidelines

### 1. Code Standards
- NO Python classes in Dynamic Apps/Run Book Actions
- NO f-strings (use `.format()` method)
- NO `__main__` function
- NO `#!/usr/bin/env python3` specification
- Always implement try/except blocks
- Use proper logging with `self.logger.ui_debug`
- Follow SL1 naming conventions

### 2. Cache Management
- Use standardized cache key format:
  ```python
  cache_key = "{}_purpose_{}".format(PREFIX, identifier)
  ```
- Implement proper cache timeouts
- Validate cached data before use

### 3. Error Handling
- Validate all inputs
- Use consistent error logging
- Implement proper timeouts
- Handle all possible error conditions
- Return appropriate error responses

### 4. Testing Requirements
- Create unit tests for all functions
- Test error conditions
- Validate timeout handling
- Test cache operations
- Mock external dependencies

### 5. Documentation
- Update CHANGELOG.md for all changes
- Maintain comprehensive README.md
- Document configuration options
- Include usage examples
- Document error scenarios

### 6. Security
- Never hardcode credentials
- Validate all inputs
- Use secure credential handling
- Implement proper access controls
- Follow security best practices

## Getting Started

1. Create project directory with prefix:
   ```bash
   mkdir _[prefix][TechnologyName]
   cd _[prefix][TechnologyName]
   ```

2. Initialize directory structure:
   ```bash
   mkdir -p _archive docs/{examples,} tests cache
   touch README.md CHANGELOG.md requirements.txt
   ```

3. Initialize git repository:
   ```bash
   git init
   git add .
   git commit -m "Initial project structure"
   ```

4. Follow the file templates and guidelines above for development

## Quality Checklist

- [ ] Project structure follows template
- [ ] All required directories present
- [ ] Documentation files created
- [ ] Git repository initialized
- [ ] Code follows SL1 standards
- [ ] Error handling implemented
- [ ] Logging implemented
- [ ] Tests created
- [ ] Security practices followed