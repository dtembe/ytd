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
