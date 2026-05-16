@ECHO OFF
ECHO ======================================================================================================================
ECHO.
ECHO YouTube Downloader - Update Tool
ECHO.
ECHO Current yt-dlp version:
yt-dlp --version
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Updating yt-dlp...
ECHO.
yt-dlp -U
ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Updated yt-dlp version:
yt-dlp --version
ECHO.
ECHO Checking runtimes...
ECHO.
deno --version 2>nul | findstr "deno" && ECHO ✓ Deno available || ECHO ✗ Deno not found - install via: winget install DenoLand.Deno
node --version 2>nul && ECHO ✓ Node.js available || ECHO ✗ Node.js not found
ECHO.
ECHO ======================================================================================================================
PAUSE
