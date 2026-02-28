@ECHO OFF
SETLOCAL

REM Load configuration
CALL "%~dp0ytd_config.bat"
SET "OUTPUT_DIR=%YTD_OUTPUT_DIR%"

ECHO ======================================================================================================================
ECHO.
ECHO Clean Existing VTT Transcripts
ECHO Directory: %OUTPUT_DIR%
ECHO.
ECHO This will:
ECHO 1. Clean VTT files (remove HTML tags, timestamps)
ECHO 2. Create speaker-labeled transcripts
ECHO 3. Create clean text files for LLM
ECHO.
ECHO Directory: %OUTPUT_DIR%
ECHO.

REM Check if directory exists
IF NOT EXIST "%OUTPUT_DIR%" (
    ECHO ERROR: Directory not found: %OUTPUT_DIR%
    PAUSE
    EXIT /B 1
)

REM Count VTT files
SET count=0
FOR %%F IN ("%OUTPUT_DIR%\*.vtt") DO (
    SET /A count+=1
)

IF %count% EQU 0 (
    ECHO No VTT files found in %OUTPUT_DIR%
    PAUSE
    EXIT /B 0
)

ECHO Found %count% VTT file(s)
ECHO.

REM Process each VTT file
FOR %%F IN ("%OUTPUT_DIR%\*.vtt") DO (
    ECHO Processing: %%~nxF
    python "%YTD_HOME%\create_clean_transcript.py" "%%F" --speaker
    ECHO.
)

ECHO ======================================================================================================================
ECHO.
ECHO ✓ Transcript cleaning complete!
ECHO.
ECHO Files created:
ECHO - .txt files with speaker labels and timestamps
ECHO - _clean.txt files with pure text (for LLM)
ECHO.
PAUSE