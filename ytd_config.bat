@ECHO OFF
REM ============================================================
REM  ytd Configuration File
REM  Edit these values to customize your setup
REM ============================================================

REM Output directory for all downloads
REM Change this to wherever you want files saved
IF NOT DEFINED YTD_OUTPUT_DIR (
    SET "YTD_OUTPUT_DIR=C:\Users\%USERNAME%\Videos\OBS"
)

REM Path to ytd toolkit directory
IF NOT DEFINED YTD_HOME (
    SET "YTD_HOME=%~dp0"
)

REM Remove trailing backslash from YTD_HOME if present
IF "%YTD_HOME:~-1%"=="\" SET "YTD_HOME=%YTD_HOME:~0,-1%"

REM YouTube player client fallback configuration
REM web_safari provides HLS formats (no PO Token needed for GVS)
REM mweb is the recommended client for PO Token workflows
IF NOT DEFINED YTD_PLAYER_CLIENTS (
    SET "YTD_PLAYER_CLIENTS=mweb,web_safari"
)

REM JavaScript runtime configuration
REM Deno is the recommended runtime (yt-dlp default), Node.js as fallback
REM Each runtime needs a separate --js-runtimes flag
IF NOT DEFINED YTD_JS_FLAGS (
    SET "YTD_JS_FLAGS=--js-runtimes deno --js-runtimes node"
)
