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
ECHO YouTube Downloader - Advanced Mode
ECHO Output Directory: %OUTPUT_DIR%
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
goto formatList

:formatList
ECHO.
ECHO Fetching available formats (this may take a moment)...
yt-dlp --js-runtimes node -F "%URL%"
ECHO.
ECHO ======================================================================================================================
goto selection


:selection
ECHO.
ECHO 1) Video + Audio (combine formats)
ECHO 2) Single format (Audio only / Video only)
ECHO 3) Best quality video + best quality audio
ECHO 4) Audio only (best quality)
ECHO.
SET /P option="Select option: "
if "%option%"=="1" goto download
if "%option%"=="2" goto downloadSingle
if "%option%"=="3" goto downloadBest
if "%option%"=="4" goto downloadAudioBest
ECHO.
ECHO Unknown value - please enter 1, 2, 3, or 4
ECHO.
ECHO ======================================================================================================================
goto selection

:downloadBest
ECHO.
ECHO Transcript format options:
ECHO 1) All formats (SRT, VTT, TXT - recommended for LLM)
ECHO 2) SRT only
ECHO 3) TXT only (cleanest for LLM)
ECHO.
SET /P transcriptOpt="Select transcript format: "

SET SUB_ARGS=--write-sub --write-auto-sub --sub-langs en,en-US
IF "%transcriptOpt%"=="1" (
    SET SUB_FORMATS=--convert-subs vtt
) ELSE IF "%transcriptOpt%"=="2" (
    SET SUB_FORMATS=--convert-subs srt
) ELSE IF "%transcriptOpt%"=="3" (
    SET SUB_FORMATS=--convert-subs vtt
) ELSE (
    SET SUB_FORMATS=--convert-subs vtt
    ECHO Invalid option, using all formats
)

ECHO.
ECHO Downloading best video + best audio with transcripts...
ECHO.
ECHO ======================================================================================================================
ECHO.
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "bv+ba/best" ^
       %SUB_ARGS% ^
       %SUB_FORMATS% ^
       --embed-metadata ^
       --embed-chapters ^
       --embed-thumbnail ^
       --merge-output-format mkv ^
       --postprocessor-args "-threads 4" ^
       "%URL%"
goto finish

:downloadAudioBest
ECHO.
ECHO Downloading best audio only with transcripts...
ECHO.
ECHO ======================================================================================================================
ECHO.
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "ba/bestaudio" ^
       --extract-audio ^
       --audio-format mp3 ^
       --audio-quality 0 ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs srt ^
       --embed-metadata ^
       --embed-thumbnail ^
       "%URL%"
goto finish

:download
ECHO.
ECHO Available transcript options:
ECHO 1) Download transcripts
ECHO 2) Skip transcripts
ECHO.
SET /P transcriptOpt="Include transcripts? (1 or 2): "
ECHO.
SET /P video="Select video format code: "
SET /P audio="Select audio format code: "

REM Build transcript arguments
SET SUB_ARGS=
if "%transcriptOpt%"=="1" (
    SET SUB_ARGS=--write-sub --write-auto-sub --sub-langs en,en-US --convert-srs srt
)

ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Downloading video format %video% + audio format %audio%...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "%video%+%audio%" ^
       %SUB_ARGS% ^
       --embed-metadata ^
       --embed-chapters ^
       --embed-thumbnail ^
       --postprocessor-args "-threads 4" ^
       "%URL%"
goto finish

:downloadSingle
ECHO.
ECHO Available transcript options:
ECHO 1) Download transcripts
ECHO 2) Skip transcripts
ECHO.
SET /P transcriptOpt="Include transcripts? (1 or 2): "
ECHO.
SET /P format="Select format code: "

REM Build transcript arguments
SET SUB_ARGS=
if "%transcriptOpt%"=="1" (
    SET SUB_ARGS=--write-sub --write-auto-sub --sub-langs en,en-US --convert-subs srt
)

ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Downloading single format %format%...
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       -f "%format%" ^
       %SUB_ARGS% ^
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
    ECHO ✓ Download completed successfully!
    ECHO Files saved to: %OUTPUT_DIR%
    ECHO.
) ELSE (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO ✗ Download failed with error code %ERRORLEVEL%
    ECHO Please check the format codes and try again.
    ECHO.
)
ECHO ======================================================================================================================
PAUSE

