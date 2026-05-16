# YouTube Downloader Toolkit — How to Use

## Prerequisites

Install these before using the toolkit:

| Tool | Required? | Install |
|------|-----------|---------|
| **yt-dlp** | Yes | `winget install yt-dlp` |
| **FFmpeg** | Yes | `winget install ffmpeg` |
| **Deno** | Recommended | `winget install DenoLand.Deno` |
| **Node.js** | Fallback | `winget install OpenJS.NodeJS` |
| **Python 3** | For post-processing | `winget install Python.Python.3` |

Place `yt-dlp.exe` and `ffmpeg.exe` in the ytd directory, or ensure they're on your system PATH.

> **Why Deno and Node.js?** YouTube requires a JavaScript runtime to extract video URLs. Deno is the yt-dlp recommended default; Node.js is kept as a fallback. Both are configured in `ytd_config.bat`.

## Verify Your Setup

```
yt-dlp_Info.bat
```

This checks yt-dlp version, Deno/Node.js runtimes, FFmpeg, and your output directory. Run this first if anything isn't working.

## Configuration

All scripts read from `ytd_config.bat`. You can override any setting via system environment variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `YTD_OUTPUT_DIR` | `C:\Users\<you>\Videos\OBS` | Where downloads are saved |
| `YTD_PLAYER_CLIENTS` | `mweb,web_safari` | YouTube client fallbacks for SABR resilience |
| `YTD_JS_FLAGS` | `--js-runtimes deno --js-runtimes node` | JavaScript runtime flags |

---

## Quick Start

### Just want the video?
```
yt-dlp_Basic.bat
```
Paste a URL. It downloads best quality video + English subtitles, auto-sanitizes filenames. Done.

### Just want a transcript for AI?
```
yt-dlp_Transcript.bat → Option 4
```
Downloads English subtitles only (no video), converted to clean text.

### Want everything for analysis?
```
yt-dlp_LLM_Workflow.bat → Option 6
```
Downloads video + transcripts + comments + runs speaker detection + creates analysis template.

---

## Complete Script Reference

### yt-dlp_Basic.bat — One-Click Download

The fastest way to download. No decisions needed after pasting the URL.

**What it does:**
- Best quality video (merged as MKV)
- English subtitles (manual + auto-generated), converted to VTT
- Embedded metadata, chapters, and thumbnail
- No playlist (single video only)
- Auto-sanitizes filenames after download

**Use when:** You just need the video and subtitles, no questions asked.

---

### yt-dlp_Advanced.bat — Format Picker

First shows all available formats for the video, then lets you pick exactly what you want.

**Options after format listing:**

| Option | What you get | Subtitles |
|--------|-------------|-----------|
| **1) Video + Audio (combine)** | Pick specific video and audio format codes from the list | Optional SRT (English) |
| **2) Single format** | One format code (video only, audio only, or combined) | Optional SRT (English) |
| **3) Best quality + transcripts** | Best video + best audio merged as MKV | Choice of VTT, SRT, or TXT (English) |
| **4) Audio only (best)** | Best audio converted to MP3 | SRT subtitles (English) |

**Use when:** You need a specific resolution, want audio-only as MP3, or the default quality isn't right.

---

### yt-dlp_Transcript.bat — Transcript-Focused

Built for getting subtitles in various forms, with optional video or audio.

**Options:**

| Option | What you get | Subtitle languages |
|--------|-------------|-------------------|
| **1) Transcripts only (all formats)** | VTT/SRT/TXT subtitles, no video | All languages |
| **2) Video + transcripts** | MKV video + all subtitle formats | All languages |
| **3) Audio + transcripts** | Audio file + subtitles | All languages |
| **4) Clean TXT only** | English subtitle text only, no video | English only |
| **5) List available languages** | Shows which subtitle languages exist, then loops to option 1 | — |

**Audio sub-options** (options 2 and 3):
- Best audio as MP3
- Best audio in original format
- Pick a specific audio format code

**Use when:** You need transcripts for AI processing, research, or translation.

---

### yt-dlp_Custom.bat — Your Own Arguments

Provides smart defaults (runtimes, SABR fallback, output path, metadata embedding) and lets you add or override any yt-dlp arguments.

- Press **Enter** to use defaults: video + English VTT subtitles + metadata + MKV
- Or type custom arguments like:
  - `--yes-playlist --playlist-start 5 --playlist-end 10` (partial playlist)
  - `--rate-limit 1M` (throttle download speed)
  - `-f "bv[vheight<=720]+ba/b[height<=720]"` (cap at 720p)
  - `--sub-langs es --convert-subs srt` (Spanish subtitles as SRT)

**Use when:** You know what yt-dlp flags you need and the other scripts don't cover it.

---

### yt-dlp_LLM_Workflow.bat — AI Processing Pipeline

Six specialized workflows optimized for feeding content into ChatGPT, Claude, or other LLMs.

**Options:**

| Option | Downloads | Subtitles | Extras |
|--------|-----------|-----------|--------|
| **1) Standard** | Video (MKV) | English TXT | JSON metadata + description |
| **2) Summary Template** | Video (MKV) | English TXT | JSON metadata + auto-generated summary template |
| **3) Research** | Nothing (skip-download) | All languages (TXT + VTT) | JSON metadata + description + annotations |
| **4) Lecture/Academic** | Video (MKV) | English TXT + VTT | Chapters, thumbnail, annotations, metadata |
| **5) Speaker Diarization** | Video (MKV) | English VTT | Filename sanitizing + speaker detection script runs automatically |
| **6) Full Analysis** | Video (MKV) | English VTT | Comments + speaker detection + filename sanitizing + analysis template |

**Option 5 details:** After download, automatically runs `create_clean_transcript.py --speaker` on the VTT file. Produces a `_clean.txt` (plain text) and a speaker-labeled transcript.

**Option 6 details:** The most comprehensive mode. Downloads video + VTT + comments, converts VTT to clean text, runs speaker detection, sanitizes all filenames, and creates a `full_analysis_template.md` with sections for speaker summary, key takeaways, action items, and notes.

**Use when:** Preparing video content for AI summarization, research, or multi-speaker analysis.

---

### yt-dlp_Speaker_Diarization.bat — Speaker Separation

Specialized workflows for identifying who said what in multi-speaker videos.

**Options:**

| Option | What you get | Purpose |
|--------|-------------|---------|
| **1) Basic diarization** | Video + WAV audio + TXT/VTT subtitles | For external tools (Whisper, NeMo, AssemblyAI) |
| **2) Enhanced timestamps** | Video + TXT + VTT + SRT + JSON metadata | Multiple formats for manual/pattern-based analysis |
| **3) Research mode** | Video + all-language subtitles + annotations + comments | Comprehensive data for deep analysis |
| **4) Whisper workflow** | Video + WAV audio + auto-generated `run_whisper_diarization.bat` | Ready-to-run Whisper pipeline with install instructions |

**Option 4** creates a helper batch file with the exact Whisper command and pip install instructions. Run it after installing Whisper and PyTorch.

**Use when:** Processing interviews, meetings, panel discussions, or any video with multiple speakers.

---

### yt-dlp_Update.bat — Updater

Updates yt-dlp to the latest version and shows:
- Version before and after update
- Deno and Node.js runtime status

### yt-dlp_Info.bat — System Check

Verifies your complete setup:
- yt-dlp version
- YouTube extractor availability
- FFmpeg version
- Node.js status
- Deno status
- Output directory existence and contents

---

## Python Post-Processing Scripts

These scripts are called automatically by some batch workflows, but can also be run standalone.

### vtt_to_txt.py — Convert VTT to Clean Text

```batch
python vtt_to_txt.py video.en.vtt              # Clean text (no timestamps)
python vtt_to_txt.py video.en.vtt --transcript  # Timestamped [MM:SS] format
```

Strips all VTT formatting tags, removes duplicate lines from auto-captions, outputs a `.txt` file.

### create_clean_transcript.py — Speaker-Labeled Transcript

```batch
python create_clean_transcript.py video.en.vtt              # Clean text only
python create_clean_transcript.py video.en.vtt --speaker     # With speaker labels
```

With `--speaker`, uses heuristic detection (pause analysis, question patterns, transition words) to label speakers as `SPEAKER_01`, `SPEAKER_02`, etc. Outputs `_clean.txt`.

### speaker_diarization.py — Full Speaker Analysis

```batch
python speaker_diarization.py video.en.vtt
```

Produces two files:
- `_speakers.txt` — Full transcript with speaker labels and timestamps
- `_summary_outline.md` — Text grouped by speaker with role detection (Host, Expert, etc.)

### rename_downloaded_files.py — Batch Filename Sanitizer

```batch
python rename_downloaded_files.py "C:\Users\dtemb\Videos\OBS"
```

Removes special characters from all MKV, MP4, WebM, VTT, TXT, JSON, and description files in a directory. Handles name collisions by appending `_1`, `_2`, etc.

### sanitize_filename.py — Single Filename Sanitizer

```batch
python sanitize_filename.py "some messy filename (2024) [HD].mp4"
```

### Batch Post-Processing Scripts

| Script | Purpose |
|--------|---------|
| `convert_all_vtt_to_txt.bat` | Converts every VTT in your output directory to clean TXT |
| `clean_existing_transcripts.bat` | Runs speaker detection on every VTT in your output directory |
| `sanitize_all_filenames.bat` | Cleans special characters from all filenames in your output directory |

---

## Output Files

Downloads are saved to your configured output directory (default: `C:\Users\<you>\Videos\OBS`).

Files are named with the upload date prefix: `YYYYMMDD_Video_Title.ext`

```
<output_dir>/
├── 20251113_Video_Title.mkv                  # Video (MKV with embedded metadata)
├── 20251113_Video_Title.en.vtt               # Subtitles (timestamps)
├── 20251113_Video_Title.en.txt               # Clean text (for LLM)
├── 20251113_Video_Title.en_clean.txt         # Plain text (no speaker labels)
├── 20251113_Video_Title.en_speakers.txt      # Speaker-labeled transcript
├── 20251113_Video_Title.info.json            # Video metadata
├── 20251113_Video_Title.description          # Video description
├── 20251113_Video_Title.webp                 # Thumbnail
├── 20251113_Video_Title_summary_outline.md   # Summary by speaker
└── full_analysis_template.md                 # Analysis template
```

Not all files are created by every script — the table below shows which scripts produce which files:

| File | Basic | Advanced | Transcript | LLM (opt 1) | LLM (opt 6) | Speaker Diarization |
|------|-------|----------|------------|--------------|--------------|---------------------|
| Video (.mkv/.mp4) | Yes | Yes | Opt 2,3 only | Yes | Yes | Yes |
| Subtitles (.vtt/.srt/.txt) | VTT | VTT or SRT | VTT/SRT/TXT | TXT | VTT | VTT/TXT/SRT |
| Metadata (.json) | — | — | — | Yes | Yes | Yes |
| Description (.description) | — | — | — | Yes | Yes | Yes |
| Comments | — | — | — | — | Yes | Opt 3 only |
| Speaker labels | — | — | — | — | Yes | — |
| Analysis template | — | — | — | — | Yes | — |
| WAV audio | — | — | — | — | — | Opt 1,4 |

---

## Common Workflows

### "I just want the video"
```
yt-dlp_Basic.bat
```

### "Give me the transcript for ChatGPT/Claude"
```
yt-dlp_Transcript.bat → Option 4 (clean TXT, no video download)
```

### "I need a podcast as MP3"
```
yt-dlp_Advanced.bat → Option 4 (audio only, best quality, MP3)
```

### "Analyze this interview/meeting for who said what"
```
yt-dlp_LLM_Workflow.bat → Option 5 (speaker diarization)
```

### "Give me everything for a deep analysis"
```
yt-dlp_LLM_Workflow.bat → Option 6 (full analysis)
```

### "I'm researching — I don't need the video file"
```
yt-dlp_LLM_Workflow.bat → Option 3 (transcripts + metadata only)
```

### "Download a lecture with chapters for study notes"
```
yt-dlp_LLM_Workflow.bat → Option 4 (lecture/academic mode)
```

### "Download a whole playlist"
```
yt-dlp_Custom.bat
Type: --yes-playlist
```

---

## Direct yt-dlp Commands

For use in PowerShell or Git Bash when you don't want the interactive scripts:

```bash
# List all available formats
./yt-dlp.exe --js-runtimes deno --js-runtimes node --extractor-args "youtube:player_client=mweb,web_safari" -F "VIDEO_URL"

# Download best quality with English subtitles
./yt-dlp.exe --js-runtimes deno --js-runtimes node --extractor-args "youtube:player_client=mweb,web_safari" \
  -o "C:/Users/dtemb/Videos/OBS/%(upload_date)s_%(title)s.%(ext)s" \
  --write-sub --write-auto-sub --sub-langs en,en-US --convert-subs vtt \
  --embed-metadata --embed-chapters --embed-thumbnail --merge-output-format mkv "VIDEO_URL"

# Download transcripts only (no video)
./yt-dlp.exe --js-runtimes deno --js-runtimes node --extractor-args "youtube:player_client=mweb,web_safari" \
  --skip-download --write-sub --write-auto-sub --sub-langs en,en-US \
  --convert-subs vtt "VIDEO_URL"

# Download audio only as MP3
./yt-dlp.exe --js-runtimes deno --js-runtimes node --extractor-args "youtube:player_client=mweb,web_safari" \
  -f "ba/bestaudio" --extract-audio --audio-format mp3 --audio-quality 0 "VIDEO_URL"

# Update yt-dlp
./yt-dlp.exe -U
```

---

## Troubleshooting

### "JavaScript runtime not found"
Install Deno: `winget install DenoLand.Deno`, or Node.js: `winget install OpenJS.NodeJS`. Restart your terminal after installing.

### "web only has SABR formats" or downloads fail with low quality
YouTube is forcing SABR streaming on the default web client. The scripts automatically use fallback clients (`mweb`, `web_safari`) to work around this. Make sure yt-dlp is up to date: `yt-dlp_Update.bat`.

### "Permission denied"
Check write access to your output directory. Default: `C:\Users\<you>\Videos\OBS`.

### "No formats found"
The video may be private, age-restricted, or region-locked. Try updating yt-dlp first.

### No subtitles downloaded
Not all videos have subtitles. Check what's available:
```
yt-dlp_Transcript.bat → Option 5 (list available languages)
```

### FFmpeg errors
Ensure `ffmpeg.exe` is in the ytd directory or on your system PATH.

### Subtitles missing for some videos
Some videos require a PO Token for subtitle access via the `mweb` client. The `web_safari` client provides video formats via HLS but may not carry all subtitle tracks. If you consistently need subtitles from affected videos, consider installing the PO Token plugin (see yt-dlp Wiki: PO Token Guide).

---

**Last Updated**: May 2026
