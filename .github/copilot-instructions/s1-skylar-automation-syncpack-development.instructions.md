---
title: S1 Skylar Automation SyncPack Development Rules
description: Guidelines for developing S1 Skylar Automation SyncPacks
version: 1.1.0
updated: 2025-12-21
---

# S1 Skylar Automation SyncPack Development Rules

> **Note on ScienceLogic Product Naming**: 
> - **S1 (Skylar One)** refers to the ScienceLogic monitoring platform. This product may also be referenced as SL1 or EM7 in legacy documentation or code. All three terms (S1, SL1, EM7) refer to the same Skylar One platform.
> - **Skylar Automation** (formerly PowerFlow) is the automation and integration platform. This product may also be referenced as PF, PowerFlow, SAUTO, or Skylar Automation.

This module provides specific guidelines for developing S1 Skylar Automation SyncPacks. It combines general S1 development practices with Skylar Automation-specific requirements.

## 1. Introduction to Skylar Automation

S1 Skylar Automation (formerly PowerFlow, also known as PF or SAUTO) enables intelligent, bi-directional integration between S1 and third-party applications. It uses workflows composed of reusable "steps" to automate tasks and share data.

- **Workflows (Applications):** Define the sequence of operations.
- **Steps:** Standardized, reusable Python code snippets performing specific actions (e.g., API calls, data transformation).
- **SyncPacks:** Bundles containing applications, steps, and configuration objects for distribution and deployment.
- **Configuration Objects:** Store credentials, endpoints, and other parameters needed by steps and applications.

## 2. Environment Specifications

- **OS:** Skylar Automation runs in Docker containers, typically based on Linux. Development can be done on various OS but testing often utilizes the SDK or a deployed Skylar Automation instance.
- **Python Version:** Check the specific Skylar Automation version documentation, but it generally uses a modern Python 3 version (Python 3.11 for current versions).
- **Shell:** `/bin/bash` is common within containers and the SDK.
- **Working Directory:** `/home/em7admin/pyDev/_sautoDev` is the designated root for Skylar Automation SyncPack projects. Each SyncPack should reside in its own subdirectory (e.g., `/home/em7admin/pyDev/_sautoDev/my_syncpack`).

## 3. Prerequisites for Development

Based on ScienceLogic documentation:
- A deployed and accessible Skylar Automation system (for deployment/testing) OR the Skylar Automation SyncPack SDK (for local development/testing).
- SSH/console access to the Skylar Automation system or SDK environment to use `iscli`.
- Proficiency in Python.
- A Python IDE for development.
- An API testing tool (e.g., Postman, cURL).
- A source-code editor.

## 4. Tools for Skylar Automation Development

- **`iscli` (Skylar Automation Command Line Interface):** Included with Skylar Automation. Used to upload applications, steps, and configuration objects.
- **Skylar Automation API:** Allows programmatic interaction with Skylar Automation.
- **`ipaascore.BaseStep` class:** A Python class included with Skylar Automation, providing pre-defined methods and attributes for step development (logging, accessing configuration, etc.). **Steps MUST inherit from this class.**
- **Base Steps SyncPack:** Contains common, reusable steps provided by ScienceLogic.
- **Skylar Automation SyncPack Cookiecutter:** (Requires access via CSM) Template for creating SyncPack structure.
- **Skylar Automation SyncPack SDK:** (Requires access via CSM) Functional environment for local development and testing without a full Skylar Automation system.
- **Skylar Automation SyncPack Pytest Fixtures:** (Requires access via CSM, included in SDK) Allows unit testing of individual steps.

## 5. Core Concepts & Development Workflow

### 5.1. Project Setup

- Create a dedicated directory for your SyncPack within `/home/em7admin/pyDev/_sautoDev/`, e.g., `_sautoDev/my_syncpack/`.
- Use the Skylar Automation SyncPack Cookiecutter (if available) or manually create the standard structure (see Section 8).
- Initialize version control (Git).
- Create `README.md`, `CHANGELOG.md`, `setup.py`.
- Create `meta.json` within the main package directory (e.g., `my_syncpack/meta.json`) to store core metadata (name, version, dependencies, etc.). See Section 8.

### 5.2. Creating Steps

- Steps are Python classes inheriting from `ipaascore.BaseStep`.
- Place step code in the appropriate directory within your SyncPack structure (e.g., `my_syncpack/steps/`).
- **Key `BaseStep` features:**
    - `self.logger`: Logger instance. Use `self.logger.info()`, `self.log.debug()`, `self.log.error()`, etc. (Note: Different from `self.logger.ui_debug` used in SL1 DAs).
    - `self.config`: Access configuration objects linked to the application run.
    - `self.step_variables`: Dictionary to pass data between steps in an application.
    - `self.get_credential(cred_id)`: Retrieve credential details.
    - `self.get_input(variable_name)`: Get input variables for the step.
    - `self.set_output(variable_name, value)`: Set output variables for the next step.
- Implement the `execute()` method, which contains the core logic of the step.
- Include robust `try/except` blocks for error handling.
- Define step parameters in `__init__` using `self.new_step_parameter()` or `self.add_step_parameter_from_object()`, specifying types with `ipaascore.parameter_types`.
- Define input and output schemas for the step (usually in the step's definition file or decorator).
- Handle step execution errors by raising exceptions from `ipaascommon.ipaas_exceptions`.
- **Reference Example:** Examine the steps within `/home/em7admin/pyDev/_pfDev/_pfemail2sl1event` for practical implementation patterns (e.g., interacting with APIs, handling data).
- Place shared helper functions in a `util` subdirectory (e.g., `my_syncpack/util/`) and import them into steps as needed.

### 5.3. Creating Applications

- Applications define the workflow, linking steps together and managing data flow.
- Typically created and configured via the Skylar Automation UI.
- Can also be defined in JSON/YAML format and uploaded via `iscli`.
- Configure input parameters, step variable mappings, and configuration object links.

### 5.4. Creating SyncPacks

- A SyncPack bundles applications, steps, configurations (structure/definitions, not values), and metadata.
- Define dependencies and metadata in `setup.py` and potentially other configuration files.
- Centralize core metadata (name, version, description, dependencies (`requires_dist`), tags, `requires_is_version`) in `meta.json` within the package directory.
- Use the PowerFlow SyncPack SDK or `iscli` commands to build and package the SyncPack (often into a `.whl` or `.zip` file).
- Configure `setup.py` to dynamically read metadata from `meta.json`.

### 5.5. Using the Skylar Automation SyncPack SDK

- Provides a local environment to:
    - Develop steps iteratively.
    - Run applications locally.
    - Test steps using Pytest fixtures.
    - Build the SyncPack package.
- Refer to the SDK documentation for specific commands and usage.

## 6. Code Structure Example (Step)

```python
# Example Step: /home/em7admin/pyDev/_sautoDev/my_syncpack/steps/my_api_step.py

import requests
from ipaascore.BaseStep import BaseStep # Import BaseStep

class MyApiStep(BaseStep): # Inherit from BaseStep
    """
    A step to fetch data from a sample API.
    """
    def __init__(self, config=None, step_vars=None):
        """
        Initialize the step.
        """
        super().__init__(config, step_vars)
        # Access configuration defined in PowerFlow UI/Config Object
        self.api_endpoint = self.config.get("api_endpoint", "https://api.example.com/data")
        self.timeout = self.config.get("timeout", 30)

    def execute(self):
        """
        Core logic for the step.
        """
        self.log.info("Starting API data fetch.") # Use self.log

        # Get input from previous step or application start
        item_id = self.get_input("item_id")
        if not item_id:
            self.log.error("Missing required input: item_id")
            # Set an error state or raise an exception depending on desired workflow
            self.set_output("status", "error")
            self.set_output("error_message", "Missing item_id input")
            return # Or raise StepException(...)

        target_url = f"{self.api_endpoint}/{item_id}"
        self.log.debug(f"Target URL: {target_url}")

        try:
            response = requests.get(target_url, timeout=self.timeout)
            response.raise_for_status() # Raise HTTPError for bad responses (4xx or 5xx)

            api_data = response.json()
            self.log.info(f"Successfully fetched data for item {item_id}.")

            # Set output for the next step
            self.set_output("api_response", api_data)
            self.set_output("status", "success")

        except requests.exceptions.RequestException as e:
            self.log.error(f"API request failed: {e}")
            self.set_output("status", "error")
            self.set_output("error_message", str(e))
        except Exception as e:
            self.log.error(f"An unexpected error occurred: {e}", exc_info=True)
            self.set_output("status", "error")
            self.set_output("error_message", f"Unexpected error: {str(e)}")

        self.log.info("API data fetch step finished.")

# Note: Additional metadata (inputs, outputs, description) is often defined
# elsewhere, e.g., in a YAML file or using decorators, depending on the
# specific PowerFlow version and SDK practices.
```

## 7. Testing

- Use the Skylar Automation SyncPack Pytest Fixtures (if available via SDK) for unit testing individual steps.
- Utilize `pytest` framework, leveraging fixtures (e.g., `syncpack_step_runner` often defined in `conftest.py`) and parameterization (`@pytest.mark.parametrize`) for efficient testing.
- Mock external dependencies (like APIs) during testing.
- Test application workflows using the SDK or a deployed Skylar Automation instance.

## 8. Directory Structure Template (Example)

```
/home/em7admin/pyDev/_sautoDev/my_syncpack/
├── my_syncpack/              # Main package directory
│   ├── __init__.py
│   ├── steps/                # Directory for step code
│   │   ├── __init__.py
│   │   ├── my_api_step.py
│   │   └── data_transform_step.py
│   ├── utils/                # Optional utilities shared by steps
│   │   └── __init__.py
│   └── info.py               # SyncPack metadata (optional structure)
│   └── meta.json             # Core SyncPack metadata (used by setup.py)
├── docs/
│   └── README.md
├── tests/                    # Pytest tests
│   └── test_my_api_step.py
│   ├── conftest.py           # Pytest fixtures
├── apps/                     # Application definitions (e.g., JSON/YAML)
│   └── my_workflow_app.json
├── configs/                  # Configuration object definitions (structure)
│   └── api_config.json
├── CHANGELOG.md
├── MANIFEST.in               # If needed for packaging
├── README.md
├── requirements.txt          # Python dependencies
└── setup.py                  # Package setup and metadata
```

## 9. Best Practices

- **Logging:** Use `self.logger` extensively with appropriate levels (DEBUG, INFO, WARNING, ERROR).
- **Error Handling:** Implement comprehensive `try/except` blocks. Provide clear error messages in step outputs. Consider using custom exception classes.
- **Configuration:** Define connection details, API keys, and other parameters in Skylar Automation Configuration Objects, accessed via `self.config`. Avoid hardcoding sensitive information.
- **Credentials:** Use Skylar Automation Credential Management. Access credentials securely using `self.get_credential()`.
- **Modularity:** Keep steps focused on a single task. Use utility functions/classes for shared logic.
- **Code Reuse:** Place shared helper functions in a `util` subdirectory within the package.
- **Data Handling:** Clearly define input/output schemas. Use `self.step_variables` for passing data between steps.
- **Metadata:** Centralize SyncPack metadata in `meta.json` and read it dynamically in `setup.py`.
- **Idempotency:** Design steps to be idempotent where possible (running them multiple times with the same input yields the same result).
- **Naming Conventions:** Follow Python PEP 8 and any ScienceLogic-specific naming guidelines.

## 10. References

- **Testing:** Employ `pytest` with fixtures and parameterization for robust step testing.
- **ScienceLogic Skylar Automation Documentation:** [https://docs.sciencelogic.com/latest/Content/Web_Content_Dev_and_Integration/PowerFlow_landing_page.htm](https://docs.sciencelogic.com/latest/Content/Web_Content_Dev_and_Integration/PowerFlow_landing_page.htm) (Note: Documentation may still reference "PowerFlow" - this is the same as Skylar Automation)
- **Python Documentation:** [https://docs.python.org/3/](https://docs.python.org/3/)
- **Requests Library:** [https://requests.readthedocs.io/en/latest/](https://requests.readthedocs.io/en/latest/)
- **Existing SyncPack Example:** `/home/em7admin/pyDev/_sautoDev/_pfemail2s1event/`
- **Template SyncPack Example:** `/home/em7admin/pyDev/_sautoDev/_sautoSlpsdTemplateSyncPack/`