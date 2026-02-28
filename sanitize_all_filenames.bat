@ECHO OFF
SETLOCAL

REM Load configuration
CALL "%~dp0ytd_config.bat"
SET "OUTPUT_DIR=%YTD_OUTPUT_DIR%"

ECHO ======================================================================================================================
ECHO.
ECHO Sanitizing all filenames in OBS directory
ECHO.
ECHO This will remove special characters from filenames
ECHO and replace them with underscores and hyphens.
ECHO.
ECHO Directory: %OUTPUT_DIR%
ECHO.

REM Check if directory exists
IF NOT EXIST "%OUTPUT_DIR%" (
    ECHO ERROR: Directory not found: %OUTPUT_DIR%
    PAUSE
    EXIT /B 1
)

REM Count files before
SET count=0
FOR %%F IN ("%OUTPUT_DIR%\*") DO (
    SET /A count+=1
)

IF %count% EQU 0 (
    ECHO No files found in %OUTPUT_DIR%
    PAUSE
    EXIT /B 0
)

ECHO Found %count% file(s) to check
ECHO.

REM Run Python script to sanitize filenames
python "%YTD_HOME%\rename_downloaded_files.py" "%OUTPUT_DIR%"

ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO ✓ Filename sanitization complete!
ECHO.
ECHO Special characters removed:
ECHO - Pipes (|), quotes, slashes, etc.
ECHO - Replaced with underscores
ECHO - Files now Python/code friendly
ECHO.
PAUSE