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
ECHO YouTube Downloader - Basic Mode
ECHO Output Directory: %OUTPUT_DIR%
ECHO.
SET /P URL="[Enter video URL] "
ECHO.

REM Check if URL is provided
IF "%URL%"=="" (
    ECHO ERROR: No URL provided
    PAUSE
    EXIT /B 1
)

ECHO ======================================================================================================================
ECHO.
ECHO Starting download with JavaScript runtime...
ECHO.
yt-dlp --js-runtimes node ^
       -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" ^
       --write-sub ^
       --write-auto-sub ^
       --sub-langs en,en-US ^
       --convert-subs vtt ^
       --embed-metadata ^
       --embed-chapters ^
       --embed-thumbnail ^
       --merge-output-format mkv ^
       --no-playlist ^
       "%URL%"

REM Check download result
IF %ERRORLEVEL% EQU 0 (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO Sanitizing filenames...
    python "%YTD_HOME%\rename_downloaded_files.py" "%OUTPUT_DIR%"

    ECHO.
    ECHO ✓ Download completed successfully!
    ECHO Files saved to: %OUTPUT_DIR%
    ECHO.
) ELSE (
    ECHO.
    ECHO ======================================================================================================================
    ECHO.
    ECHO ✗ Download failed with error code %ERRORLEVEL%
    ECHO Please check the URL and try again.
    ECHO.
)

ECHO ======================================================================================================================
PAUSE
