# YouTube Downloader Toolkit - How to Use

## Overview
This is a comprehensive YouTube downloader optimized for LLM processing, speaker diarization, and transcript analysis. All downloads are saved to `C:\Users\dtemb\Videos\OBS`.

## Quick Start

### 1. Basic Download (Most Common)
```batch
yt-dlp_Basic.bat
```
- Downloads video in MKV format
- Includes transcripts (automatically converted to TXT for LLM)
- Best quality video + audio
- Embedded metadata and chapters

### 2. For Multi-Speaker Videos (Interviews, Meetings, Lectures)
```batch
yt-dlp_LLM_Workflow.bat
```
- Select option **5** for speaker diarization
- Select option **6** for full analysis
- Creates speaker-labeled transcripts
- Generates summary templates by speaker

### 3. Format Selection (Advanced Users)
```batch
yt-dlp_Advanced.bat
```
- Shows all available formats
- Lets you select specific video/audio quality
- Options for transcript formats

### 4. Custom Downloads
```batch
yt-dlp_Custom.bat
```
- Add your own yt-dlp arguments
- Smart defaults included if you press Enter

## What You Get

### File Types Created:
1. **Video** - `.mkv` (high quality, with embedded metadata)
2. **Transcript** - `.vtt` (timestamps, for speaker analysis)
3. **Transcript** - `.txt` (clean text, perfect for LLM input)
4. **Metadata** - `.json` (complete video information)
5. **Description** - `.description` (video description)
6. **Comments** - When available

### Speaker Diarization Files:
- `_speakers.txt` - Speaker-labeled transcript
- `_summary_outline.md` - Summary structure by speaker
- `full_analysis_template.md` - Complete analysis template

## Script Details

### yt-dlp_Basic.bat
**Use for:** Quick, reliable downloads
- Downloads best quality video (MKV)
- English transcripts (VTT → auto-converted to TXT)
- No user interaction needed after URL

### yt-dlp_LLM_Workflow.bat
**Use for:** Videos you want to analyze with AI

**Options:**
1. **Standard** - Basic download for LLM
2. **Summary Template** - Auto-generates markdown template
3. **Research** - Transcripts only + metadata
4. **Lecture/Academic** - Chapters + full data
5. **Speaker Diarization** - ⭐ **BEST for multi-speaker videos**
6. **Full Analysis** - Everything + speaker detection

### yt-dlp_Advanced.bat
**Use for:** When you need specific formats
- Interactive format picker
- Best quality options
- Audio-only downloads (MP3)
- Custom transcript options

### yt-dlp_Speaker_Diarization.bat
**Use for:** Professional speaker separation
- Creates WAV audio for external tools
- Whisper diarization scripts
- Multiple analysis approaches

### yt-dlp_Transcript.bat
**Use for:** Transcript-focused downloads
- Option 4: Clean TXT only (best for LLM)
- Option 1: All transcript formats
- Video/audio options available

## LLM Processing Workflow

### For Single Speaker Videos:
1. Use `yt-dlp_Basic.bat`
2. Use the `.txt` file directly for LLM input
3. Reference `.json` for video metadata

### For Multi-Speaker Videos:
1. Use `yt-dlp_LLM_Workflow.bat` → Option 5 or 6
2. Use `_speakers.txt` for accurate summaries
3. Use `_summary_outline.md` for structured output

### Creating Summaries:
1. **Quick Summary**: Use the `.txt` file
2. **Speaker-Aware**: Use `_speakers.txt`
3. **Structured**: Use the generated templates

## File Locations

```
C:\Users\dtemb\Videos\OBS\
├── YYYYMMDD_Video_Title.mkv              # Video
├── YYYYMMDD_Video_Title.en.vtt           # Transcript (timestamps)
├── YYYYMMDD_Video_Title.en.txt           # Clean text (LLM)
├── YYYYMMDD_Video_Title.info.json        # Metadata
├── YYYYMMDD_Video_Title.en.speakers.txt  # Speaker-labeled (if used)
├── YYYYMMDD_Video_Title_summary_outline.md # Summary by speaker
└── full_analysis_template.md             # Analysis template
```

## Troubleshooting

### Common Errors:
1. **"JavaScript runtime not found"** → Run `yt-dlp_Info.bat` to check Node.js
2. **"Permission denied"** → Check write access to `C:\Users\dtemb\Videos\OBS`
3. **"No formats found"** → Video might be private/region-restricted

### System Check:
```batch
yt-dlp_Info.bat
```
This will show:
- yt-dlp version
- Node.js status
- FFmpeg availability
- Directory permissions

### Update yt-dlp:
```batch
yt-dlp_Update.bat
```

## Pro Tips

### For Researchers:
- Use option 6 (Full Analysis) for comprehensive data
- Comments are included when available
- JSON metadata has all video details

### For Content Creators:
- Use option 4 (Lecture mode) for educational content
- Chapters are embedded in video
- All transcript formats preserved

### For Meeting Analysis:
- Use option 5 (Speaker diarization)
- Python script identifies speaker changes
- Creates structured summary by speaker

### For Podcast Transcription:
- Use `yt-dlp_Advanced.bat` → Option 4 (Audio only)
- Downloads as MP3 with transcripts
- Perfect for audio-only content

## Python Scripts Available

### vtt_to_txt.py
Converts VTT files to clean TXT for LLM:
```batch
python vtt_to_txt.py video.vtt
```

### speaker_diarization.py
Analyzes VTT to identify speakers:
```batch
python speaker_diarization.py video.vtt
```

### convert_all_vtt_to_txt.bat
Converts ALL VTT files in OBS directory to TXT:
```batch
convert_all_vtt_to_txt.bat
```

## Advanced Usage

### Custom Arguments:
Use `yt-dlp_Custom.bat` with arguments like:
- `--playlist-start 5 --playlist-end 10` (partial playlist)
- `--rate-limit 1M` (limit download speed)
- `--embed-thumbnail` (embed thumbnail in video)

### Playlist Downloads:
Add `--yes-playlist` to custom arguments for full playlists

### Audio Only:
Use `yt-dlp_Advanced.bat` → Option 4 for MP3 extraction

## Remember

- **All downloads go to**: `C:\Users\dtemb\Videos\OBS`
- **Best for LLM**: `.txt` files
- **Speaker analysis**: Use options 5 or 6
- **Update regularly**: `yt-dlp_Update.bat`
- **Check system**: `yt-dlp_Info.bat`

## Contact/Issues

If you encounter issues:
1. Check `yt-dlp_Info.bat` first
2. Update yt-dlp: `yt-dlp_Update.bat`
3. Ensure Node.js is installed for YouTube features
4. Verify OBS directory exists and is writable

---

**Last Updated**: December 2024
**Version**: Uses yt-dlp 2025.12.08 with Node.js runtime support