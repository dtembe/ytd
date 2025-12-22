# New Repository Template Files

This repository serves as a standardized template collection for initializing new development repositories. It provides essential configuration files, development workflows, and AI-assisted development guidance that can be copied to any new project to establish consistent development practices.

> **ScienceLogic Product Naming**: This template supports development for S1 (Skylar One), the ScienceLogic monitoring platform (also known as SL1 or EM7), and Skylar Automation, the automation and integration platform (formerly PowerFlow, also known as PF or SAUTO).

## Repository Purpose

This template repository is designed to:
- **Standardize Development Setup**: Provide consistent configuration files across all new repositories
- **Accelerate Project Initialization**: Reduce setup time with pre-configured development tools
- **Enhance AI-Assisted Development**: Include comprehensive instructions for GitHub Copilot and Claude
- **Establish Best Practices**: Enforce consistent coding standards, security practices, and documentation
- **Streamline Git Workflows**: Provide automated sync scripts for daily development workflows

## File Structure Overview

### Core Template Files

> **Important**: Configuration files are prefixed with underscore (`_`) in this repository to allow GitHub upload. You must rename them to dot-prefix (`.`) before use.

| File/Directory | Purpose | Usage |
|----------------|---------|-------|
| `_gitignore` | Standard Git ignore patterns for various project types | Rename to `.gitignore`, copy to new repos, customize as needed |
| `_gitignore.conservative` | More restrictive ignore patterns for sensitive projects | Rename to `.gitignore.conservative`, alternative to standard .gitignore |
| `_gitattributes` | Git line ending and file handling configuration | Rename to `.gitattributes`, copy to new repos for consistent behavior |

### GitHub Configuration

| File/Directory | Purpose | Usage |
|----------------|---------|-------|
| `.github/copilot-instructions.md` | Master GitHub Copilot instruction file | Copy to new repos for AI-assisted development |
| `.github/copilot-instructions/` | Modular instruction files for specific development contexts | Copy relevant modules based on project type |
| `.github/chatmodes/` | Specialized AI interaction modes and prompts | Copy for enhanced AI collaboration workflows |
| `.github/prompts/` | Reusable prompt templates for various development tasks | Copy for consistent AI prompt patterns |

### Development Workflow Scripts

| File | Purpose | Platform | Usage |
|------|---------|----------|-------|
| `gh_repo_sync_work_start.ps1` | Start-of-day Git sync (pull latest changes) | Windows/PowerShell | Run at beginning of work session |
| `gh_repo_sync_work_start.sh` | Start-of-day Git sync (pull latest changes) | Linux/macOS/Bash | Run at beginning of work session |
| `gh_repo_sync_work_end.ps1` | End-of-day Git sync (commit and push changes) | Windows/PowerShell | Run at end of work session |
| `gh_repo_sync_work_end.sh` | End-of-day Git sync (commit and push changes) | Linux/macOS/Bash | Run at end of work session |

### Documentation Files

| File | Purpose | Usage |
|------|---------|-------|
| `README.md` | This file - template documentation | Customize for each new project |

## Quick Start Guide

### 1. Initialize New Repository

```powershell
# Windows PowerShell
# Copy template files to your new repository
Copy-Item "c:\tools\_new-repo-files\*" -Destination "C:\path\to\your\new\repo\" -Recurse -Force

# Rename configuration files (remove underscore prefix, add dot prefix)
cd "C:\path\to\your\new\repo"
Rename-Item -Path "_gitignore" -NewName ".gitignore"
Rename-Item -Path "_gitignore.conservative" -NewName ".gitignore.conservative"
Rename-Item -Path "_gitattributes" -NewName ".gitattributes"

# Initialize git if not already done
git init
```

```bash
# Linux/macOS
# Copy template files to your new repository
cp -r /path/to/_new-repo-files/* /path/to/your/new/repo/

# Rename configuration files (remove underscore prefix, add dot prefix)
cd /path/to/your/new/repo
mv _gitignore .gitignore
mv _gitignore.conservative .gitignore.conservative
mv _gitattributes .gitattributes

# Initialize git if not already done
git init
```

### 2. Configure Daily Workflow

```powershell
# Windows - Set execution policy (run once)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Daily start-of-work sync
.\gh_repo_sync_work_start.ps1

# Daily end-of-work sync
.\gh_repo_sync_work_end.ps1 -Message "Your commit message"
```

```bash
# Linux/macOS - Make scripts executable (run once)
chmod +x gh_repo_sync_work_start.sh gh_repo_sync_work_end.sh

# Daily start-of-work sync
./gh_repo_sync_work_start.sh

# Daily end-of-work sync
./gh_repo_sync_work_end.sh "Your commit message"
```

### 3. Customize for Your Project

1. **Rename Config Files**: Rename `_gitignore` to `.gitignore`, `_gitattributes` to `.gitattributes` (if not done in step 1)
2. **Update CLAUDE.md**: Add project-specific context, architecture notes, and development commands
3. **Modify .gitignore**: Add project-specific ignore patterns
4. **Customize Copilot Instructions**: Select relevant instruction modules from `.github/copilot-instructions/`
5. **Update README.md**: Replace this template with your project's specific documentation

#### Available Copilot Instruction Modules

The `.github/copilot-instructions/` directory contains specialized modules for different development contexts:

- **s1-development.instructions.md**: Core S1 platform development (Python 3.11, f-strings, cache management)
- **s1-agent-development.instructions.md**: Windows PowerShell and Linux SSH agent development
- **s1-skylar-automation-syncpack-development.instructions.md**: Skylar Automation SyncPack and step development
- **shell-commands.instructions.md**: Shell scripting best practices for Linux/Bash environments
- **file-operations.instructions.md**: File handling, backup procedures, and directory structure guidelines
- **security.instructions.md**: Security best practices and credential management
- **documentation.instructions.md**: Documentation standards using Markdown and Mermaid diagrams
- **ai-optimization.instructions.md**: Optimizing prompts for AI efficiency and context handling
- **memory-bank.instructions.md**: Memory bank structure for maintaining project context
- **rule-structure.instructions.md**: Format for creating well-structured development rules
- **unityGameDev.instructions.md**: Unity game development guidelines and best practices

## Included AI Development Features

### GitHub Copilot Integration

The template includes comprehensive GitHub Copilot instructions covering:

- **Core Development Guidelines**: Coding standards, architecture patterns, and best practices
- **S1 Platform Development**: S1 (Skylar One) platform development for version 12.3.x with Python 3.11 and f-strings
- **S1 Agent Development**: Windows PowerShell and Linux low_code framework agent-based monitoring
- **Skylar Automation Development**: SyncPack development using BaseStep pattern and step-based architecture
- **Platform-Specific Rules**: Unity game development, shell scripting guidelines
- **Security Best Practices**: Credential handling, file permissions, and secure coding patterns
- **Documentation Standards**: Consistent documentation formatting and structure
- **Specialized Workflows**: Memory bank management, project setup templates, AI optimization

### Claude AI Context

The `CLAUDE.md` file provides:
- Common development commands for various project types (Python, Node.js, Rust, .NET, C++)
- High-level architecture patterns and project organization guidelines
- Environment setup priorities and debugging workflows
- Performance optimization strategies

## Git Workflow Automation

### Start-of-Day Sync (`gh_repo_sync_work_start`)

Automatically handles:
- ✅ Verifies Git repository and remote origin
- ✅ Detects current branch
- ✅ Pulls latest changes from origin
- ✅ Handles merge conflicts gracefully
- ✅ Cross-platform support (PowerShell/Bash)

### End-of-Day Sync (`gh_repo_sync_work_end`)

Automatically handles:
- ✅ Stages all changes (`git add -A`)
- ✅ Prompts for commit message if not provided
- ✅ Commits changes with meaningful message
- ✅ Pushes to origin branch
- ✅ Handles no-change scenarios gracefully

## Project Type Support

This template is designed to support various project types:

- **Python Projects**: Virtual environments, requirements.txt, pytest testing
- **Node.js Projects**: npm/pnpm package management, development servers
- **Rust Projects**: Cargo build system, continuous compilation
- **.NET Projects**: Visual Studio integration, ClickOnce deployment
- **C++ Projects**: CMake build system, vcpkg package management
- **Unity Game Development**: Unity-specific workflows and best practices
- **S1 Platform Development**: 
  - **S1 PowerPack Development**: Dynamic Applications for monitoring using Python 3.11 and f-strings (S1 12.3.x+)
  - **S1 Windows Agent Development**: PowerShell-based monitoring with native Windows cmdlets
  - **S1 Linux Agent Development**: Low-code framework with SSH-based collection objects
  - **Directory Structure**: `_s1Dev/` for S1-related projects with `__s1libs/` and `__s1templates/`
- **Skylar Automation Development**: 
  - **SyncPack Development**: Step-based automation using BaseStep class and ipaascore modules
  - **Workflow Integration**: Bi-directional integration between S1 and third-party applications
  - **Directory Structure**: `_sautoDev/` for Skylar Automation projects
- **AI-Powered Applications**: Local-first AI integration patterns

## Security and Privacy Features

- **Secure Credential Storage**: Guidelines for Windows Credential Manager, environment variables
- **File Permission Management**: Proper chmod/chown patterns for sensitive files
- **Secret Scanning Protection**: Comprehensive .gitignore patterns to prevent credential leaks
- **Local-First AI Processing**: Patterns for offline AI model usage

## ScienceLogic Development Features

### S1 (Skylar One) Platform Support

- **Version 12.3.x Support**: Python 3.11 with f-string formatting
- **Platform Constraints**: Linear code structure, no classes in Dynamic Apps, proper error handling
- **Agent-Based Monitoring**:
  - **Windows Agent**: PowerShell-based with native cmdlets (Test-Connection, Test-NetConnection, etc.)
  - **Linux Agent**: Low-code framework with SSH collection objects
- **Pre-built PowerPacks**: Reference implementations for DHCP, DNS, Hyper-V, IIS, MSSQL, Windows Base, and more
- **Directory Structure**: Organized with `_s1Dev/` for S1 projects, `_nonS1Dev/` for other projects

### Skylar Automation (formerly PowerFlow) Support

- **SyncPack Development**: Step-based architecture using BaseStep class
- **Integration Framework**: Bi-directional integration between S1 and third-party systems
- **Development Tools**: SDK support, pytest fixtures, iscli command-line interface
- **Directory Structure**: `_sautoDev/` for Skylar Automation projects with proper SyncPack structure

### Critical Development Notes

- **⚠️ PowerShell Agent Scripts**: NO blank lines at end of scripts - causes "Empty pipe element" parser errors
- **S1 Built-in Objects**: Never initialize `result_handler`, `self`, or `silo.*` imports - they're platform-provided
- **String Formatting**: Use f-strings for Python 3.11 (S1 12.3.x+), `.format()` for older versions
- **Cache Keys**: Format as `prefix_purpose_{DID}` using f-strings

## Maintenance and Updates

This template repository is continuously improved based on:
- Development workflow feedback
- New technology adoption
- Security best practice updates
- AI development tool evolution

### Contributing Improvements

When you discover improvements or new patterns:
1. Update the relevant template files in this repository
2. Document the changes in your project's CHANGELOG.md
3. Consider contributing back to this template for future projects

## Getting Help

- **AI Assistance**: The included Copilot and Claude instructions provide context-aware development help
- **Workflow Issues**: Check the Git sync script comments for troubleshooting steps
- **Configuration Problems**: Review the VS Code settings and .gitignore patterns

### ScienceLogic Documentation References

- **S1 Platform**: [https://docs.sciencelogic.com/](https://docs.sciencelogic.com/)
- **S1 PowerShell Agent**: [https://docs.sciencelogic.com/latest/Content/Web_Vendor_Specific_Monitoring/Windows_PowerShell/chapter_06_agent_with_ps.htm](https://docs.sciencelogic.com/latest/Content/Web_Vendor_Specific_Monitoring/Windows_PowerShell/chapter_06_agent_with_ps.htm)
- **S1 Low-Code Development**: [https://docs.sciencelogic.com/dev-docs/](https://docs.sciencelogic.com/dev-docs/)
- **Skylar Automation**: [https://docs.sciencelogic.com/latest/Content/Web_Content_Dev_and_Integration/PowerFlow_landing_page.htm](https://docs.sciencelogic.com/latest/Content/Web_Content_Dev_and_Integration/PowerFlow_landing_page.htm)

---

**Note**: This README.md should be customized for each new project. Replace this content with project-specific information while maintaining the established patterns and workflows.