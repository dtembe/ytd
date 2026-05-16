@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

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
ECHO YouTube Downloader - LLM Workflow
ECHO Output Directory: %OUTPUT_DIR%
ECHO This workflow downloads video + transcripts and prepares for LLM processing
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
ECHO LLM Processing Options:
ECHO 1) Download and prepare for LLM (MKV + clean TXT + metadata)
ECHO 2) Download + auto-generate LLM-ready summary file template
ECHO 3) Research mode (transcript only + video metadata)
ECHO 4) Lecture/Academic mode (chapters + timestamps + transcript)
ECHO 5) Speaker diarization mode (identify speakers for better summaries)
ECHO 6) Full analysis (video + transcripts + speaker detection + summary template)
ECHO.
SET /P option="Select workflow: "

if "%option%"=="1" goto standardWorkflow
if "%option%"=="2" goto summaryWorkflow
if "%option%"=="3" goto researchWorkflow
if "%option%"=="4" goto lectureWorkflow
if "%option%"=="5" goto speakerWorkflow
if "%option%"=="6" goto fullAnalysisWorkflow
ECHO.
ECHO Unknown value - please enter 1, 2, 3, 4, 5, or 6
ECHO.
ECHO ======================================================================================================================
goto option

:standardWorkflow
ECHO.
ECHO Downloading for LLM processing...
ECHO ======================================================================================================================
ECHO.
yt-dlp %YTD_JS_FLAGS% --extractor-args "youtube:player_client=%YTD_PLAYER_CLIENTS%" ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "bv+ba/best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs txt ^
       --embed-metadata ^
       --embed-chapters ^
       --embed-thumbnail ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ✓ LLM-ready files downloaded!
    ECHO.
    ECHO Files created:
    ECHO - Video: MKV format with embedded metadata
    ECHO - Transcript: Clean TXT file (best for LLM input)
    ECHO - Metadata: JSON file with video information
    ECHO - Description: Separate description file
    ECHO.
    ECHO Ready for LLM processing!
)
goto finish

:summaryWorkflow
ECHO.
ECHO Downloading and creating summary template...
ECHO ======================================================================================================================
ECHO.
yt-dlp %YTD_JS_FLAGS% --extractor-args "youtube:player_client=%YTD_PLAYER_CLIENTS%" ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "bv+ba/best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs txt ^
       --embed-metadata ^
       --embed-chapters ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO Creating LLM summary template...

    REM Extract title for summary file
    FOR /F "tokens=*" %%i IN ('yt-dlp %YTD_JS_FLAGS% --get-title "%URL%" 2^>nul') DO (
        SET VIDEO_TITLE=%%i
    )

    REM Create summary template
    ECHO # Summary: %VIDEO_TITLE% > "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO. >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO ## Video Information >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO - URL: %URL% >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO - Date: %DATE% >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO. >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO ## Key Points >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO - [Add key takeaways here] >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO. >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO ## Detailed Summary >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO [Generate from transcript] >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO. >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO ## Action Items >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"
    ECHO - [List actionable items] >> "%OUTPUT_DIR%\%(upload_date)s_%(title)s_YYYYMMDD_summary.md"

    ECHO ✓ Summary template created!
    ECHO ✓ Ready for LLM processing with transcript and template!
)
goto finish

:researchWorkflow
ECHO.
ECHO Research mode: Getting comprehensive transcript and metadata...
ECHO ======================================================================================================================
ECHO.
yt-dlp %YTD_JS_FLAGS% --extractor-args "youtube:player_client=%YTD_PLAYER_CLIENTS%" ^
       --skip-download ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs txt,vtt ^
       --write-description ^
       --write-info-json ^
       --write-annotations ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ✓ Research data downloaded!
    ECHO.
    ECHO Available for analysis:
    ECHO - Transcripts in multiple languages
    ECHO - Complete video metadata (JSON)
    ECHO - Video description
    ECHO - Video annotations (if available)
    ECHO.
    ECHO Use this data for research without downloading video!
)
goto finish

:lectureWorkflow
ECHO.
ECHO Lecture/Academic mode: Downloading with chapters and timestamps...
ECHO ======================================================================================================================
ECHO.
yt-dlp %YTD_JS_FLAGS% --extractor-args "youtube:player_client=%YTD_PLAYER_CLIENTS%" ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "bv+ba/best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs txt,vtt ^
       --embed-metadata ^
       --embed-chapters ^
       --embed-thumbnail ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       --write-annotations ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ✓ Lecture materials downloaded!
    ECHO.
    ECHO Files for academic use:
    ECHO - Video: MKV with embedded chapters
    ECHO - Transcript: TXT (clean) + VTT (with timestamps)
    ECHO - Chapters: Embedded in video and separate file
    ECHO - Annotations: Available if supported
    ECHO - Metadata: Complete JSON with all details
    ECHO.
    ECHO Perfect for creating study guides or research papers!
)
goto finish

:speakerWorkflow
ECHO.
ECHO Speaker diarization mode: Downloading with VTT for speaker analysis...
ECHO ======================================================================================================================
ECHO.
yt-dlp %YTD_JS_FLAGS% --extractor-args "youtube:player_client=%YTD_PLAYER_CLIENTS%" ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "bv+ba/best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs vtt ^
       --embed-metadata ^
       --embed-chapters ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       "%URL%"

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO Sanitizing filenames...
    python "%YTD_HOME%\rename_downloaded_files.py" "%OUTPUT_DIR%"

    ECHO.
    ECHO ✓ Files downloaded for speaker diarization!
    ECHO.
    ECHO Running speaker analysis...
    ECHO.

    REM Find the VTT file and run speaker diarization
    FOR %%F IN ("%OUTPUT_DIR%\*.vtt") DO (
        ECHO Processing VTT: %%F
        python "%YTD_HOME%\create_clean_transcript.py" "%%F" --speaker
        goto speakerDone
    )

    :speakerDone
    ECHO.
    ECHO ✓ Speaker diarization completed!
    ECHO.
    ECHO Files created:
    ECHO - Video: MKV with chapters
    ECHO - VTT: Original transcript with timestamps
    ECHO - TXT: Clean transcript with speaker labels
    ECHO - _clean.txt: Clean text without speakers (for LLM)
    ECHO.
    ECHO Use the TXT file for accurate speaker-separated transcript!
)
goto finish

:fullAnalysisWorkflow
ECHO.
ECHO Full analysis mode: Everything you need for complete understanding...
ECHO ======================================================================================================================
ECHO.
REM First download with VTT
yt-dlp %YTD_JS_FLAGS% --extractor-args "youtube:player_client=%YTD_PLAYER_CLIENTS%" ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "bv+ba/best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs vtt ^
       --embed-metadata ^
       --embed-chapters ^
       --merge-output-format mkv ^
       --write-description ^
       --write-info-json ^
       --write-comments ^
       "%URL%"

IF %ERRORLEVEL% NEQ 0 goto finish

REM Convert VTT to TXT for LLM
ECHO.
ECHO Converting VTT to clean transcript for LLM...
FOR %%F IN ("%OUTPUT_DIR%\*.vtt") DO (
    ECHO Converting: %%F
    python "%YTD_HOME%\create_clean_transcript.py" "%%F" --speaker
    goto conversionDone
)

:conversionDone

IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO Creating comprehensive analysis package...

    REM Sanitize filenames first
    ECHO.
    ECHO Sanitizing filenames...
    python "%YTD_HOME%\rename_downloaded_files.py" "%OUTPUT_DIR%"

    REM Run speaker diarization
    FOR %%F IN ("%OUTPUT_DIR%\*.vtt") DO (
        ECHO Running speaker analysis on: %%F
        python "%YTD_HOME%\create_clean_transcript.py" "%%F" --speaker
        goto analysisDone
    )

    :analysisDone
    ECHO.
    ECHO Creating enhanced summary template...

    REM Create comprehensive summary template
    SET SUMMARY_FILE=!OUTPUT_DIR!\full_analysis_template.md
    ECHO # Comprehensive Analysis > "!SUMMARY_FILE!"
    ECHO. >> "!SUMMARY_FILE!"
    ECHO ## Video Information >> "!SUMMARY_FILE!"
    ECHO - URL: %URL% >> "!SUMMARY_FILE!"
    ECHO - Date: %DATE% >> "!SUMMARY_FILE!"
    ECHO. >> "!SUMMARY_FILE!"
    ECHO ## Speaker Summary >> "!SUMMARY_FILE!"
    ECHO [Fill from speaker-labeled transcript] >> "!SUMMARY_FILE!"
    ECHO. >> "!SUMMARY_FILE!"
    ECHO ## Key Takeaways >> "!SUMMARY_FILE!"
    ECHO - [Main insights] >> "!SUMMARY_FILE!"
    ECHO - [Important points] >> "!SUMMARY_FILE!"
    ECHO. >> "!SUMMARY_FILE!"
    ECHO ## Detailed Summary by Speaker >> "!SUMMARY_FILE!"
    ECHO [Use speaker analysis output] >> "!SUMMARY_FILE!"
    ECHO. >> "!SUMMARY_FILE!"
    ECHO ## Action Items >> "!SUMMARY_FILE!"
    ECHO - [From Speaker 1] >> "!SUMMARY_FILE!"
    ECHO - [From Speaker 2] >> "!SUMMARY_FILE!"
    ECHO. >> "!SUMMARY_FILE!"
    ECHO ## Additional Notes >> "!SUMMARY_FILE!"
    ECHO - [Comments from video] >> "!SUMMARY_FILE!"
    ECHO - [External context] >> "!SUMMARY_FILE!"

    ECHO.
    ECHO ✓ Full analysis package ready!
    ECHO.
    ECHO Files included:
    ECHO - Video (MKV)
    ECHO - VTT transcript (original with timestamps)
    ECHO - TXT transcript (with speaker labels)
    ECHO - _clean.txt (pure text for LLM)
    ECHO - Full analysis template
    ECHO - Comments (if available)
    ECHO - Complete metadata
)
goto finish

:finish
REM Check download result
IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO ✓ LLM workflow completed successfully!
    ECHO Files saved to: %OUTPUT_DIR%
    ECHO.
    ECHO Next steps for LLM processing:
    ECHO 1. Use the .txt transcript for direct LLM input
    ECHO 2. Reference the .json file for metadata
    ECHO 3. Use summary templates for structured output
    ECHO 4. Process chapters from VTT for timestamped analysis
    ECHO 5. For videos with multiple speakers, use speaker-labeled transcripts
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