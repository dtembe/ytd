@ECHO OFF
SETLOCAL

REM Set output directory
SET OUTPUT_DIR=C:\Users\dtemb\Videos\OBS

REM Check if OBS directory exists
IF NOT EXIST "%OUTPUT_DIR%" (
    ECHO ERROR: OBS directory not found: %OUTPUT_DIR%
    ECHO Please ensure the directory exists or update the script.
    PAUSE
    EXIT /B 1
)

ECHO ======================================================================================================================
ECHO.
ECHO YouTube Downloader - LLM Transcript Mode
ECHO Output Directory: %OUTPUT_DIR%
ECHO Optimized for AI/LLM processing
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
ECHO Available options:
ECHO 1) Transcripts only (all formats: TXT, VTT, SRT)
ECHO 2) Video (MKV) + transcripts (recommended)
ECHO 3) Audio only (MP3) + transcripts
ECHO 4) Clean TXT transcript only (best for LLM)
ECHO 5) List available languages
ECHO.
SET /P option="Select option: "

if "%option%"=="1" goto transcriptOnly
if "%option%"=="2" goto videoWithTranscript
if "%option%"=="3" goto audioWithTranscript
if "%option%"=="4" goto textOnly
if "%option%"=="5" goto listLanguages
ECHO.
ECHO Unknown value - please enter 1, 2, 3, 4, or 5
ECHO.
ECHO ======================================================================================================================
goto option

:listLanguages
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Fetching available subtitle languages...
yt-dlp --js-runtimes node --list-subs "%URL%"
ECHO.
ECHO ======================================================================================================================
goto transcriptOnly

:textOnly
ECHO.
ECHO Downloading clean TXT transcript only (optimized for LLM)...
ECHO ======================================================================================================================
ECHO.
yt-dlp --js-runtimes node ^
       --skip-download ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs vtt ^
       "%URL%"
goto finish

:transcriptOnly
ECHO.
ECHO Downloading all transcript formats (TXT, VTT, SRT)...
ECHO ======================================================================================================================
ECHO.
yt-dlp --js-runtimes node ^
       --skip-download ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs vtt ^
       "%URL%"
goto finish

:videoWithTranscript
ECHO.
ECHO Download format options:
ECHO 1) Best quality
ECHO 2) Select format
ECHO.
SET /P formatOpt="Select format option: "

if "%formatOpt%"=="1" goto videoBest
if "%formatOpt%"=="2" goto videoSelect

:videoBest
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Downloading MKV video with all transcript formats (TXT, VTT, SRT)...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "best" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs vtt ^
       --embed-metadata ^
       --embed-chapters ^
       --embed-thumbnail ^
       --merge-output-format mkv ^
       "%URL%"
goto finish

:videoSelect
ECHO.
ECHO Fetching available formats...
yt-dlp --js-runtimes node -F "%URL%"
ECHO.
SET /P format="Select format code: "
ECHO ======================================================================================================================
ECHO.
ECHO Downloading format %format% (MKV) with all transcript formats...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "%format%" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs vtt ^
       --embed-metadata ^
       --embed-thumbnail ^
       --merge-output-format mkv ^
       "%URL%"
goto finish

:audioWithTranscript
ECHO.
ECHO Audio format options:
ECHO 1) Best audio (will convert to MP3)
ECHO 2) Best audio (keep original format)
ECHO 3) Select audio format
ECHO.
SET /P audioOpt="Select audio option: "

if "%audioOpt%"=="1" goto audioBestMp3
if "%audioOpt%"=="2" goto audioBest
if "%audioOpt%"=="3" goto audioSelect

:audioBestMp3
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Downloading best audio as MP3 with all transcript formats...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "ba/bestaudio" ^
       --extract-audio ^
       --audio-format mp3 ^
       --audio-quality 0 ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs vtt ^
       --embed-metadata ^
       --embed-thumbnail ^
       "%URL%"
goto finish

:audioBest
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Downloading best audio with transcripts...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "ba/bestaudio" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs srt ^
       --embed-metadata ^
       --embed-thumbnail ^
       "%URL%"
goto finish

:audioSelect
ECHO.
ECHO Fetching available audio formats...
yt-dlp --js-runtimes node -F "%URL%" | findstr "audio only"
ECHO.
SET /P format="Select audio format code: "
ECHO ======================================================================================================================
ECHO.
ECHO Downloading audio format %format% with transcripts...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "%format%" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs all,en,en-US ^
       --convert-subs srt ^
       --embed-metadata ^
       --embed-thumbnail ^
       "%URL%"
goto finish

:finish
REM Check download result
IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO ✓ Operation completed successfully!
    ECHO Files saved to: %OUTPUT_DIR%

    REM List downloaded files
    ECHO.
    ECHO Recently downloaded files:
    FOR /F "delims=" %%F IN ('DIR "%OUTPUT_DIR%\*" /B /O-D /A-D 2^>nul ^| MORE +0 ^| FINDSTR /N "^" ^| FINDSTR "^[1-5]: "') DO (
        ECHO   %%F
    )
    ECHO.
) ELSE (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO ✗ Operation failed with error code %ERRORLEVEL%
    ECHO Please check the URL and try again.
    ECHO.
)
ECHO ======================================================================================================================
PAUSE