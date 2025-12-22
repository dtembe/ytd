# GitHub Copilot AI-Developed Code Instructions

This document provides clear and unambiguous guidelines for AI-generated code using GitHub Copilot. The instructions are structured for clarity and consistency.

> **Note on ScienceLogic Product Naming**: Throughout this documentation, S1 (Skylar One) refers to the ScienceLogic monitoring platform. This product may also be referenced as SL1 or EM7 in legacy documentation or code. All three terms (S1, SL1, EM7) refer to the same Skylar One platform.
```generic 
# Project Overview

This project is a web application that allows users to manage their tasks and to-do lists. It is built using React and Node.js, and uses MongoDB for data storage.

## Folder Structure

- `/src`: Contains the source code for the frontend.
- `/server`: Contains the source code for the Node.js backend.
- `/docs`: Contains documentation for the project, including API specifications and user guides.

## Libraries and Frameworks

- React and Tailwind CSS for the frontend.
- Node.js and Express for the backend.
- MongoDB for data storage.

## Coding Standards

- Use semicolons at the end of each statement.
- Use single quotes for strings.
- Use function based components in React.
- Use arrow functions for callbacks.

## UI guidelines

- A toggle is provided to switch between light and dark mode.
- Application should have a modern and clean design.

```

## Core Commands
- **Build**: Open the solution in your IDE and build using standard commands (e.g., F6 or Build menu).
- **Test**: Place all unit and integration tests in a `tests/` folder. Use your chosen test framework (e.g., MSTest, PyTest, NUnit).
- **Deploy**: Follow your project’s deployment pipeline. Use a standardized packaging or deployment mechanism (e.g., ClickOnce, Docker, CI/CD).
- **Docs**: Maintain documentation in a `docs/` directory with user, developer, and release notes.
- **Package Management**: Use a dependency manager (NuGet, pip, npm, etc.) and lock dependency versions.

## Architecture Guidelines
- **Modular Codebase**: Organize code into logical modules or packages for maintainability.
- **Shared Code**: Centralize reusable components in a shared module or library folder.
- **Security**: Store credentials securely (e.g., OS keychain, vault) and enforce TLS for all communications.
- **Async & Caching**: Prefer async-first patterns, caching strategies, and proper error handling.
- **UI**: Implement UI components following platform-specific design guidelines.
- **Logging**: Use structured logging with rotation and centralized monitoring support.

## Style & Coding Rules
- **Imports**: Use explicit imports and avoid unnecessary wildcards.
- **Naming**: PascalCase for classes, camelCase for variables, ALL_CAPS for constants.
- **Typing**: Use explicit typing wherever possible.
- **Error Handling**: Wrap external calls in try/catch (or equivalent) and sanitize error messages.
- **Secrets**: Never hard-code or log credentials or tokens.
- **Testing**: Cover all core modules and automate test runs in CI pipelines.
- **Docs**: Keep inline documentation and a changelog (`Changelog.md`).

## Repository & Agent Rules
- Do not commit sensitive files or credentials.
- Follow [GitHub Copilot AI-Developed Code Instructions](./copilot-instructions/) for memory bank, changelog, and release process.
- Use platform-appropriate shell commands (e.g., PowerShell, Bash).

## Using This Guide

This is the main instructions file for GitHub Copilot. For specific development tasks, refer to the relevant instruction modules below. GitHub Copilot will automatically reference these modules when needed based on your development context.

### Available Instruction Modules
It is required that you use these modules as appropriate - and the project work demands. 

- [Shell Command Guidelines](./copilot-instructions/shell-commands.instructions.md) - Shell scripting best practices
- [S1 Development Rules](./copilot-instructions/s1-development.instructions.md) - S1 (Skylar One) platform development guidelines
- [S1 Agent Development Rules](./copilot-instructions/s1-agent-development.instructions.md) - S1 Windows and Linux Agent development guidelines
- [File Operations & Management](./copilot-instructions/file-operations.instructions.md) - File handling and backup procedures
- [Security Best Practices](./copilot-instructions/security.instructions.md) - Security guidelines for development
- [Documentation Standards](./copilot-instructions/documentation.instructions.md) - Documentation formatting and structure
- [Rule Structure Format](./copilot-instructions/rule-structure.instructions.md) - Format for rule creation
- [AI Context Optimization](./copilot-instructions/ai-optimization.instructions.md) - Optimize interactions with AI
- [Memory Bank Structure](./copilot-instructions/memory-bank.instructions.md) - Structure for maintaining project memory
- [S1 Skylar Automation SyncPack Development Rules](./copilot-instructions/s1-skylar-automation-syncpack-development.instructions.md) - S1 Skylar Automation (formerly PowerFlow) SyncPack development guidelines
- [Unity Game Development ](./copilot-instructions/unityGameDev.instructions.md) - Unity game development guidelines


