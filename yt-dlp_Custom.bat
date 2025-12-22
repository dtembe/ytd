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
ECHO YouTube Downloader - Custom Mode
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
ECHO Default arguments will be used unless you specify custom ones:
ECHO --js-runtimes node (JavaScript runtime)
ECHO -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s" (output path)
ECHO --write-sub --write-auto-sub --sub-langs en,en-US (transcripts)
ECHO --convert-subs vtt (timestamps, convertible to TXT)
ECHO --embed-metadata --embed-chapters (metadata)
ECHO --merge-output-format mkv (MKV video format)
ECHO.
SET /P arguments="Enter custom arguments (or press Enter for defaults): "

ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Starting download...

REM Build the command with defaults
SET BASE_ARGS=--js-runtimes node -o "%OUTPUT_DIR%\%%(upload_date)s_%%(title)s.%%(ext)s"

REM Add default arguments if none provided
IF "%arguments%"=="" (
    SET FINAL_ARGS=%BASE_ARGS% --write-sub --write-auto-sub --sub-langs en,en-US --convert-subs vtt --embed-metadata --embed-chapters --embed-thumbnail --merge-output-format mkv
) ELSE (
    REM Check if user provided their own output format
    echo %arguments% | findstr /C:"-o" >nul
    IF %ERRORLEVEL% EQU 0 (
        SET FINAL_ARGS=%BASE_ARGS% %arguments%
    ) ELSE (
        SET FINAL_ARGS=%BASE_ARGS% %arguments% --embed-metadata --merge-output-format mkv
    )
)

ECHO Running: yt-dlp %FINAL_ARGS% "%URL%"
ECHO.
yt-dlp %FINAL_ARGS% "%URL%"

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
    ECHO Please check your arguments and try again.
    ECHO.
)
ECHO ======================================================================================================================
PAUSE
