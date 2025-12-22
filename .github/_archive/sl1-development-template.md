### SL1 PowerPack Development Template ###

When requesting a new SL1 PowerPack development, use the following template:

```
Please create a new SL1 PowerPack Development project with the following specifications:

1. Project Name: _[prefix][TechnologyName]
   Example: _sshOraDb, _apiServiceNow, _snmpCisco

2. Project Location: ~/pyDev/[ProjectName]

3. Technology Details:
   - Monitoring Protocol: [SSH/API/SNMP/WinRM]
   - Target Technology: [Technology Name and Version]
   - Authentication Method: [Credentials Type]

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

Please create this following SL1 development standards, ensuring:
- Linear script structure (no classes)
- Proper error handling
- Standard logging
- Cache management
- Appropriate timeouts
- Complete documentation
```

### SL1 PowerPack Development Workflow ###
When developing a new SL1 PowerPack, follow these steps:

1. Project Setup:
   - Create project directory with standard structure (_archive, docs, tests)
   - Initialize version control
   - Create initial README.md and CHANGELOG.md
   - Set up requirements.txt if needed

2. Base Files Creation:
   - Discovery script
   - Performance collection scripts
   - Cache management scripts
   - Configuration files

3. Implementation Standards:
   - Use linear script structure (no classes)
   - Implement proper error handling
   - Use self.logger.ui_debug for logging
   - Follow SL1 naming conventions
   - Implement timeout handling
   - Use proper cache key format
   - Validate all inputs

4. Testing Requirements:
   - Create unit tests for each script
   - Implement mock responses
   - Test error conditions
   - Validate timeout handling
   - Test cache operations

5. Documentation:
   - Complete README.md
   - Maintain CHANGELOG.md
   - Add configuration guides
   - Include example responses
   - Document error scenarios

6. Quality Assurance:
   - Run linting (flake8)
   - Run unit tests
   - Verify error handling
   - Check logging consistency
   - Validate timeouts
   - Test cache operations

7. Deployment Preparation:
   - Verify file permissions
   - Check documentation completeness
   - Update version information
   - Create release notes

### Directory Structure Template ###
```
_[prefix][TechnologyName]/
├── _archive/
├── docs/
│   ├── CONTRIBUTING.md
│   ├── configuration.md
│   └── examples/
├── tests/
│   ├── __init__.py
│   ├── test_discovery.py
│   └── test_performance.py
├── CHANGELOG.md
├── README.md
├── requirements.txt
├── discovery.py
└── performance.py
```