@ECHO OFF
SETLOCAL

ECHO ======================================================================================================================
ECHO.
ECHO YouTube Downloader - System Information
ECHO.
ECHO Checking yt-dlp version and configuration...
ECHO.
yt-dlp --version
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Checking Python/JavaScript runtime status...
ECHO.
yt-dlp --js-runtimes node --list-extractors | find "youtube"
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Checking FFmpeg availability...
ECHO.
ffmpeg -version | findstr "version"
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Checking Node.js runtime...
ECHO.
node --version 2>nul && ECHO ✓ Node.js is available for yt-dlp JavaScript processing || ECHO ✗ Node.js not found - JavaScript features may be limited
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Output directory check:
ECHO.
CALL "%~dp0ytd_config.bat"
SET "OUTPUT_DIR=%YTD_OUTPUT_DIR%"
IF EXIST "%OUTPUT_DIR%" (
    ECHO ✓ OBS directory exists: %OUTPUT_DIR%
    dir "%OUTPUT_DIR%" /b /a-d 2>nul | find /c "." >nul
    IF %ERRORLEVEL% EQU 0 (
        ECHO   Directory contains files
    ) ELSE (
        ECHO   Directory is empty
    )
) ELSE (
    ECHO ✗ OBS directory not found: %OUTPUT_DIR%
)
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO System configuration complete!
PAUSE