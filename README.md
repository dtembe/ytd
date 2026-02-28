# ytd — YouTube Downloader Toolkit

A Windows batch toolkit for downloading YouTube videos and transcripts, with built-in transcript processing optimized for LLM/AI workflows.

Built on [yt-dlp](https://github.com/yt-dlp/yt-dlp) and [FFmpeg](https://ffmpeg.org/).

## What It Does

- **Download videos** in best quality (MKV) with one command
- **Extract transcripts** (VTT/SRT/TXT) from any YouTube video
- **Generate LLM-ready text** — clean, stripped transcripts perfect for pasting into ChatGPT, Claude, etc.
- **Speaker detection** — heuristic-based speaker labeling from subtitle timestamps
- **Batch processing** — convert/clean entire directories of downloaded files

## Prerequisites

| Tool | Required | Install |
|------|----------|---------|
| **yt-dlp** | Yes | `winget install yt-dlp` or [download](https://github.com/yt-dlp/yt-dlp/releases) |
| **FFmpeg** | Yes | `winget install ffmpeg` or [download](https://ffmpeg.org/download.html) |
| **Node.js** | Yes | `winget install OpenJS.NodeJS` or [download](https://nodejs.org/) |
| **Python 3** | Yes | `winget install Python.Python.3` or [download](https://python.org/) |

> Place `yt-dlp.exe` and `ffmpeg.exe` in the ytd directory, or ensure they're on your system PATH.

## Quick Start

### 1. Basic Download (most common)
```
yt-dlp_Basic.bat
```
Paste a URL → downloads best quality MKV + English subtitles → auto-sanitizes filenames.

### 2. Get a Transcript for AI
```
yt-dlp_Transcript.bat
```
Select **Option 4** for clean TXT only — no video download needed.

### 3. Full LLM Workflow
```
yt-dlp_LLM_Workflow.bat
```
Downloads video + creates clean `.txt`, speaker-labeled `_clean.txt`, and metadata `.json` files ready for AI processing.

### 4. Check Your Setup
```
yt-dlp_Info.bat
```
Verifies yt-dlp, FFmpeg, Node.js, and output directory.

## Scripts Reference

### Download Scripts

| Script | Purpose |
|--------|---------|
| `yt-dlp_Basic.bat` | One-click best quality download + subtitles |
| `yt-dlp_Advanced.bat` | Interactive format picker, audio-only, custom quality |
| `yt-dlp_Custom.bat` | Pass your own yt-dlp flags with smart defaults |
| `yt-dlp_Transcript.bat` | Transcript-focused: text only, video+subs, audio+subs, list languages |
| `yt-dlp_LLM_Workflow.bat` | 6-mode AI pipeline: standard, summary, research, lecture, speaker, full analysis |
| `yt-dlp_Speaker_Diarization.bat` | Speaker separation workflows with Whisper integration |
| `yt-dlp_Update.bat` | Update yt-dlp to latest version |
| `yt-dlp_Info.bat` | System diagnostics |

### Post-Processing Scripts

| Script | Purpose |
|--------|---------|
| `convert_all_vtt_to_txt.bat` | Batch convert all VTT files → clean TXT |
| `clean_existing_transcripts.bat` | Process VTT files with speaker detection |
| `sanitize_all_filenames.bat` | Remove special characters from all filenames |

### Python Utilities

| Script | Purpose | Usage |
|--------|---------|-------|
| `vtt_to_txt.py` | Convert VTT → clean text | `python vtt_to_txt.py video.vtt` |
| `create_clean_transcript.py` | VTT → speaker-labeled transcript | `python create_clean_transcript.py video.vtt --speaker` |
| `speaker_diarization.py` | Full speaker analysis with role detection | `python speaker_diarization.py video.vtt` |
| `rename_downloaded_files.py` | Sanitize filenames in a directory | `python rename_downloaded_files.py <dir>` |
| `sanitize_filename.py` | Sanitize a single filename | `python sanitize_filename.py "file name.txt"` |

## Configuration

All scripts read from `ytd_config.bat`. Edit it to change your output directory:

```batch
REM Default: C:\Users\<you>\Videos\OBS
SET "YTD_OUTPUT_DIR=D:\My\Custom\Path"
```

Or set the environment variable `YTD_OUTPUT_DIR` system-wide and it will be used automatically.

## Output Files

Downloads are saved to your configured output directory with this structure:

```
<output_dir>/
├── 20260228_Video_Title.mkv              # Video
├── 20260228_Video_Title.en.vtt           # Subtitle (timestamps)
├── 20260228_Video_Title.en.txt           # Clean text (for LLM)
├── 20260228_Video_Title.en_clean.txt     # Pure text (no speakers)
├── 20260228_Video_Title.en_speakers.txt  # Speaker-labeled
├── 20260228_Video_Title_summary_outline.md  # Summary by speaker
├── 20260228_Video_Title.info.json        # Video metadata
└── 20260228_Video_Title.description      # Video description
```

## Common Workflows

### Researcher: Get transcript for analysis
```
yt-dlp_Transcript.bat → Option 4 (clean TXT)
```

### Content Creator: Archive a video with all metadata
```
yt-dlp_LLM_Workflow.bat → Option 6 (full analysis)
```

### Meeting/Interview: Identify who said what
```
yt-dlp_LLM_Workflow.bat → Option 5 (speaker diarization)
```

### Podcast: Audio only
```
yt-dlp_Advanced.bat → Option 4 (audio best quality, MP3)
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "JavaScript runtime not found" | Install Node.js, then run `yt-dlp_Info.bat` to verify |
| Download fails | Run `yt-dlp_Update.bat` — YouTube changes frequently |
| "Permission denied" | Check write access to your output directory |
| No subtitles found | Video may not have captions — try `yt-dlp_Transcript.bat` → Option 5 to list languages |
| FFmpeg errors | Ensure `ffmpeg.exe` is in the ytd directory or on PATH |

## License

This toolkit wraps open-source tools:
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) — Unlicense
- [FFmpeg](https://ffmpeg.org/) — LGPL/GPL
