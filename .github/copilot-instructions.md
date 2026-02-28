# GitHub Copilot Instructions — ytd

## Project Overview
ytd is a Windows batch toolkit for downloading YouTube videos/audio and extracting transcripts, optimized for LLM/AI workflows. Built on yt-dlp + FFmpeg.

## Architecture
- **Batch scripts** (yt-dlp_*.bat) — User-facing download workflows
- **Python scripts** (*.py) — Post-processing: VTT→TXT conversion, speaker detection, filename sanitization
- **Config** (ytd_config.bat) — Centralized output directory and path configuration
- All scripts source ytd_config.bat for paths — never hardcode directories

## Coding Rules
- Batch scripts use CALL "%~dp0ytd_config.bat" to load config
- Python scripts use only stdlib (no pip dependencies)
- Filenames are sanitized to remove special characters
- Use %YTD_HOME% for script paths, %YTD_OUTPUT_DIR% for output directory

## Key Patterns
- yt-dlp always uses --js-runtimes node for full YouTube support
- Output format: %(upload_date)s_%(title)s.%(ext)s
- Subtitles: --write-sub --write-auto-sub --sub-langs en,en-US
- Video container: MKV (--merge-output-format mkv)

## Available Instruction Modules
- [Shell Commands](./copilot-instructions/shell-commands.instructions.md)
- [File Operations](./copilot-instructions/file-operations.instructions.md)
- [Security](./copilot-instructions/security.instructions.md)
- [Documentation](./copilot-instructions/documentation.instructions.md)
- [AI Optimization](./copilot-instructions/ai-optimization.instructions.md)
