@ECHO OFF
SETLOCAL

REM Load configuration
CALL "%~dp0ytd_config.bat"
SET "OUTPUT_DIR=%YTD_OUTPUT_DIR%"

REM Check if OBS directory exists
IF NOT EXIST "%OUTPUT_DIR%" (
    ECHO ERROR: OBS directory not found: %OUTPUT_DIR%
    ECHO Please ensure the directory exists or update the script.
    PAUSE
    EXIT /B 1
)

ECHO ======================================================================================================================
ECHO.
ECHO YouTube Downloader - Speaker Diarization Workflow
ECHO Output Directory: %OUTPUT_DIR%
ECHO.
ECHO This workflow downloads video and creates speaker-separated transcripts
ECHO Requires: FFmpeg (installed) + OpenAI Whisper or similar
ECHO.
SET /P URL="[Enter video URL] "

REM Check if URL is provided
IF "%URL%"=="" (
    ECHO ERROR: No URL provided
    PAUSE
    EXIT /B 1
)

ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Diarization Options:
ECHO 1) Download video + audio (for external diarization)
ECHO 2) Download with enhanced timestamps (basic speaker hints)
ECHO 3) Research mode (multiple transcript formats for analysis)
ECHO 4) Full workflow (download + prepare for Whisper diarization)
ECHO.
SET /P option="Select diarization approach: "

if "%option%"=="1" goto basicDiarization
if "%option%"=="2" goto enhancedTimestamps
if "%option%"=="3" goto researchMode
if "%option%"=="4" goto whisperWorkflow
ECHO.
ECHO Unknown value - please enter 1, 2, 3, or 4
ECHO.
ECHO ======================================================================================================================
goto option

:basicDiarization
ECHO.
ECHO Downloading video and high-quality audio for diarization...
ECHO ======================================================================================================================
ECHO.
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs txt,vtt ^
       --embed-metadata ^
       --embed-chapters ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       --extract-audio ^
       --audio-format wav ^
       --audio-quality 0 ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ✓ Files ready for diarization!
    ECHO.
    ECHO Use tools like:
    ECHO - OpenAI Whisper (pip install openai-whisper)
    ECHO - NVIDIA NeMo
    ECHO - Google Speech-to-Text
    ECHO - AssemblyAI
    ECHO.
    ECHO Example Whisper command:
    ECHO whisper audio.wav --language en --model large-v2 --diarize
)
goto finish

:enhancedTimestamps
ECHO.
ECHO Downloading with enhanced transcript analysis...
ECHO ======================================================================================================================
ECHO.
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs txt,vtt,srt ^
       --embed-metadata ^
       --embed-chapters ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ✓ Enhanced transcripts downloaded!
    ECHO.
    ECHO Files for speaker analysis:
    ECHO - VTT file: Has precise timestamps
    ECHO - SRT file: Sequential text blocks
    ECHO - TXT file: Clean text
    ECHO - JSON metadata: Video chapters and info
    ECHO.
    ECHO Speaker hints to look for:
    ECHO - Chapter changes often indicate speaker changes
    ECHO - Pauses in transcripts
    ECHO - Question/answer patterns
    ECHO - "I", "you", "we" usage patterns
)
goto finish

:researchMode
ECHO.
ECHO Research mode: All transcript formats for analysis...
ECHO ======================================================================================================================
ECHO.
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs txt,vtt,srt ^
       --embed-metadata ^
       --embed-chapters ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       --write-annotations ^
       --write-comments ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ✓ Research data downloaded!
    ECHO.
    ECHO Advanced analysis options:
    ECHO - Multiple language transcripts
    ECHO - Comments (may reveal speaker roles)
    ECHO - Annotations
    ECHO - Chapter metadata
    ECHO.
    ECHO Use these for pattern recognition and
    ECHO manual speaker identification.
)
goto finish

:whisperWorkflow
ECHO.
ECHO Full Whisper diarization workflow...
ECHO ======================================================================================================================
ECHO.
ECHO Step 1: Extracting audio for Whisper processing...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs txt,vtt ^
       --embed-metadata ^
       --embed-chapters ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       --extract-audio ^
       --audio-format wav ^
       --audio-quality 0 ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO Step 2: Creating Whisper diarization script...

    REM Find the downloaded audio file
    FOR %%F IN ("%OUTPUT_DIR%\*.wav") DO (
        SET AUDIO_FILE=%%F
        goto foundAudio
    )

    :foundAudio
    ECHO Found audio: !AUDIO_FILE!

    REM Create Whisper batch file
    ECHO @ECHO OFF > "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO Running Whisper with speaker diarization... >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO. >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO Prerequisites: >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO 1. pip install openai-whisper >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO 2. pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO 3. pip install diarization-toolkit >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO. >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO whisper "!AUDIO_FILE!" --language en --model large-v2 --diarize --output_dir "%OUTPUT_DIR%" >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO. >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO ECHO Diarization complete! Check for .txt and .srt files with speaker labels. >> "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO PAUSE >> "%OUTPUT_DIR%\run_whisper_diarization.bat"

    ECHO.
    ECHO ✓ Whisper diarization script created!
    ECHO.
    ECHO Run: "%OUTPUT_DIR%\run_whisper_diarization.bat"
    ECHO.
    ECHO This will:
    ECHO 1. Install Whisper and dependencies
    ECHO 2. Process audio with speaker diarization
    ECHO 3. Output speaker-labeled transcripts
)
goto finish

:finish
REM Check download result
IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO ✓ Diarization workflow completed!
    ECHO Files saved to: %OUTPUT_DIR%
    ECHO.
    ECHO Next steps:
    ECHO 1. Run Whisper for automatic speaker diarization
    ECHO 2. Use the speaker-labeled transcript for summaries
    ECHO 3. Identify speakers by context and patterns
    ECHO.
) ELSE (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO ✗ Workflow failed with error code %ERRORLEVEL%
    ECHO Please check the URL and try again.
    ECHO.
)
ECHO ======================================================================================================================
PAUSE