@ECHO OFF
SETLOCAL

SET OUTPUT_DIR=C:\Users\dtemb\Videos\OBS

ECHO ======================================================================================================================
ECHO.
ECHO Converting all VTT files to TXT for LLM processing
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

REM Convert each VTT file
FOR %%F IN ("%OUTPUT_DIR%\*.vtt") DO (
    ECHO Converting: %%~nxF
    python "C:\tools\ytd\vtt_to_txt.py" "%%F"
)

ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO ✓ Conversion complete!
ECHO.
ECHO VTT files with timestamps (for speaker analysis)
ECHO TXT files with clean text (for LLM input)
ECHO.
PAUSE