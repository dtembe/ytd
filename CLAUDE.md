# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **YouTube Downloader Toolkit (ytd)** - a Windows-based command-line utility for downloading multimedia content from YouTube and other video platforms. The toolkit provides a user-friendly interface through batch scripts while leveraging the powerful yt-dlp and FFmpeg backends.

## Core Components

### Executables (not tracked in Git)
- **yt-dlp.exe** - Main YouTube downloader (install via `winget install yt-dlp`)
- **ffmpeg.exe** - Multimedia processing (install via `winget install ffmpeg`)

### Batch Scripts (User Interfaces)
- **yt-dlp_Basic.bat** - Simple one-command download with default settings
- **yt-dlp_Advanced.bat** - Interactive format selection with video/audio combination options
- **yt-dlp_Custom.bat** - Allows custom yt-dlp arguments for advanced users
- **yt-dlp_Transcript.bat** - Transcript-focused downloads (text only, video+subs, audio+subs)
- **yt-dlp_LLM_Workflow.bat** - 6-mode AI processing pipeline
- **yt-dlp_Speaker_Diarization.bat** - Speaker separation workflows
- **yt-dlp_Info.bat** - Displays yt-dlp version and build information
- **yt-dlp_Update.bat** - Updates yt-dlp to the latest version

### Configuration
- **ytd_config.bat** - Centralized configuration (output directory, paths)

All scripts source `ytd_config.bat` for paths. Edit it or set environment variable `YTD_OUTPUT_DIR` to change the output directory.

## Common Development Commands

### Running Downloads
```batch
# Basic download (best quality with transcripts)
yt-dlp_Basic.bat

# Advanced download with format selection and options
yt-dlp_Advanced.bat

# Custom download with your own arguments (includes smart defaults)
yt-dlp_Custom.bat

# Transcript-focused downloads (video/audio/transcripts only)
yt-dlp_Transcript.bat
```

### Maintenance
```batch
# Update yt-dlp to latest version
yt-dlp_Update.bat

# Check system configuration and runtimes
yt-dlp_Info.bat
```

### Direct yt-dlp Usage (PowerShell/Bash)
```bash
# List available formats
./yt-dlp.exe --js-runtimes deno,node -F "VIDEO_URL"

# Download with specific format and transcripts
./yt-dlp.exe --js-runtimes deno,node --extractor-args "youtube:player_client=mweb,web_safari" \
  -o "C:/Users/dtemb/Videos/OBS/%(upload_date)s_%(title)s.%(ext)s" \
  -f "FORMAT_CODE" --write-sub --write-auto-sub --sub-langs en,en-US \
  --convert-subs srt --embed-metadata "VIDEO_URL"

# Download video + audio combination with transcripts
./yt-dlp.exe --js-runtimes deno,node --extractor-args "youtube:player_client=mweb,web_safari" \
  -o "C:/Users/dtemb/Videos/OBS/%(upload_date)s_%(title)s.%(ext)s" \
  -f "VIDEO_FORMAT+AUDIO_FORMAT" --write-sub --write-auto-sub \
  --sub-langs en,en-US --convert-subs srt --embed-metadata "VIDEO_URL"

# Download only transcripts
./yt-dlp.exe --js-runtimes deno,node --extractor-args "youtube:player_client=mweb,web_safari" \
  --skip-download --write-sub --write-auto-sub \
  --sub-langs all --convert-subs srt "VIDEO_URL"

# Update yt-dlp
./yt-dlp.exe -U
```

## Architecture

### Directory Structure
```
C:\tools\ytd\
├── ytd_config.bat            # Centralized configuration
├── yt-dlp_Basic.bat          # Simple download with transcripts
├── yt-dlp_Advanced.bat       # Format selection and options
├── yt-dlp_Custom.bat         # Custom arguments with smart defaults
├── yt-dlp_Transcript.bat     # Transcript-focused downloader
├── yt-dlp_LLM_Workflow.bat   # LLM processing pipeline
├── yt-dlp_Speaker_Diarization.bat  # Speaker separation
├── yt-dlp_Info.bat           # System information checker
├── yt-dlp_Update.bat         # Updater
├── vtt_to_txt.py             # VTT → clean text converter
├── create_clean_transcript.py  # Speaker-labeled transcript creator
├── speaker_diarization.py    # Full speaker analysis
├── rename_downloaded_files.py # Batch filename sanitizer
└── sanitize_filename.py      # Single filename sanitizer

Output Directory (configurable via ytd_config.bat):
Default: C:\Users\<username>\Videos\OBS
```

### Workflow Pattern
1. **User Interface Layer** - Batch scripts provide interactive menus
2. **Download Engine** - yt-dlp handles video extraction and downloading
3. **Processing Layer** - FFmpeg provides format conversion and post-processing
4. **Storage Layer** - Downloads directory with organized file naming

### Key Design Principles
- **JavaScript Runtime Enabled** - Uses Deno (primary) + Node.js (fallback) for full YouTube feature support
- **SABR Resilience** - Configurable player client fallback (`mweb,web_safari`) to work around YouTube SABR enforcement
- **Simplicity First** - No installation required, unpack and run
- **User-Friendly** - Batch scripts abstract complex yt-dlp commands
- **Powerful Backend** - Full yt-dlp and FFmpeg feature support available
- **Consistent Output** - Files saved to OBS directory with date prefixes

## Features and Capabilities

### Supported Platforms
- YouTube and all yt-dlp supported sites (1000+ extractors)
- Full JavaScript runtime support (no deprecated features)
- Playlist support
- Channel downloads
- Subtitle and transcript extraction

### Format Support
- Video: MP4, WebM, MKV, AVI, and more
- Audio: MP3, M4A, OGG, WAV, FLAC, and more
- Quality: 240p to 4K+ depending on source
- Live stream support
- Automatic format merging for best quality

### Advanced Features
- **JavaScript Runtime**: Deno (recommended) + Node.js fallback for YouTube extraction
- **Transcript Downloads**: Automatic and manual subtitles in multiple languages
- **Format Selection**: Interactive format picker (Advanced.bat)
- **Metadata Embedding**: Video info, chapters, thumbnails embedded in files
- **FFmpeg Integration**: Multi-threaded processing, format conversion
- **Smart Defaults**: Best quality + transcripts for basic downloads
- **Error Handling**: Comprehensive error checking and user feedback
- **Directory Management**: Automatic OBS directory check and creation
- **Date-based Naming**: Files prefixed with upload date for organization

## Configuration

### Default Settings
- Output directory: Configured in `ytd_config.bat` (default: `C:\Users\<username>\Videos\OBS`)
- Filename format: `%(upload_date)s_%(title)s.%(ext)s` (date prefix for organization)
- JavaScript runtime: Deno + Node.js (configured via `YTD_JS_FLAGS` in `ytd_config.bat`)
- Player clients: mweb, web_safari (configured via `YTD_PLAYER_CLIENTS` in `ytd_config.bat`)
- Subtitles: Downloaded by default (English + auto-generated, converted to SRT)
- Metadata: Embedded (video info, chapters, thumbnails)
- FFmpeg: Multi-threaded processing enabled

### Customization
- Edit batch scripts to change default paths or options
- Use `yt-dlp_Custom.bat` for one-off custom commands
- yt-dlp respects global configuration files
- JavaScript runtime path can be modified in scripts if needed
- Output directory can be changed by editing `OUTPUT_DIR` variable

## Security Notes

- Downloads are saved to local OBS directory only
- JavaScript runtime (Deno + Node.js) required for full YouTube support
- No network services or external dependencies beyond yt-dlp
- FFmpeg includes extensive codec support for security scanning
- All tools run with user privileges only

## Troubleshooting

### Common Issues
1. **JavaScript Runtime Warning** - Ensure Deno or Node.js is installed (run `yt-dlp_Info.bat` to check)
2. **"URL not supported"** - yt-dlp may need update: run `yt-dlp_Update.bat`
3. **Format selection errors** - Use `yt-dlp_Advanced.bat` to see available formats first
4. **Permission denied** - Ensure write access to `C:\Users\dtemb\Videos\OBS`
5. **FFmpeg errors** - Check that ffmpeg.exe is in the root directory
6. **Missing transcripts** - Video may not have subtitles; try `yt-dlp_Transcript.bat` option 4 to list available languages
7. **"web only has SABR formats"** - YouTube is forcing SABR streaming; scripts use `mweb,web_safari` fallback clients automatically

### Debug Mode
Add `-v` or `--verbose` to yt-dlp commands for detailed logging

### System Check
Run `yt-dlp_Info.bat` to verify:
- yt-dlp version
- Deno and Node.js availability
- FFmpeg installation
- OBS directory access

### Log Files
yt-dlp outputs to console; redirect to file if needed:
```batch
yt-dlp [options] "URL" > download.log 2>&1
```

### JavaScript Runtime Issues
If JavaScript runtime errors persist:
1. Install Deno: `winget install DenoLand.Deno`
2. Or use Node.js: https://nodejs.org/ (v20+)
3. Check with `yt-dlp_Info.bat` for runtime status