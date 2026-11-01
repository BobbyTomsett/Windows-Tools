@echo off
setlocal enabledelayedexpansion

:: Defaults
set WIDTH=256
set HEIGHT=256
set ALL=false
set INPUT=
set OUTDIR=
set EXPECT=

:: -------------------------
:: Argument parsing (NO SHIFT, NO GOTO)
:: -------------------------
for %%A in (%*) do (

    if defined EXPECT (
        if "!EXPECT!"=="width"  set WIDTH=%%A
        if "!EXPECT!"=="height" set HEIGHT=%%A
        if "!EXPECT!"=="out"    set OUTDIR=%%A
        set EXPECT=
    ) else (

        if /i "%%A"=="-a"       set ALL=true
        if /i "%%A"=="--all"    set ALL=true

        if /i "%%A"=="-w"       set EXPECT=width
        if /i "%%A"=="--width"  set EXPECT=width

        if /i "%%A"=="-h"       set EXPECT=height
        if /i "%%A"=="--height" set EXPECT=height

        if /i "%%A"=="-o"       set EXPECT=out
        if /i "%%A"=="--out"    set EXPECT=out

        if /i "%%A"=="--help" goto help

        if not defined INPUT (
            set INPUT=%%A
        )
    )
)

:: -------------------------
:: Validation
:: -------------------------
if "%ALL%"=="false" if not defined INPUT (
    echo Error: No input file specified.
    goto help
)

if defined OUTDIR (
    if not exist "%OUTDIR%" mkdir "%OUTDIR%"
)

:: -------------------------
:: Convert function
:: -------------------------
:convert
set "FILE=%~1"

if not exist "%FILE%" (
    echo File not found: %FILE%
    goto :eof
)

if defined OUTDIR (
    set "OUTPUT=%OUTDIR%\%~n1.png"
) else (
    set "OUTPUT=%~dpn1.png"
)

magick -background none "%FILE%" -resize %WIDTH%x%HEIGHT% "%OUTPUT%" >nul 2>&1

if exist "%OUTPUT%" (
    echo Converted: %FILE% ^> %OUTPUT% (%WIDTH%x%HEIGHT%)
) else (
    echo Failed: %FILE%
)

goto :eof

:: -------------------------
:: Main logic
:: -------------------------
if "%ALL%"=="true" (
    echo Converting all SVG files...
    for %%F in (*.svg) do call :convert "%%F"
    goto :eof
)

echo DEBUG INPUT="%INPUT%"
call :convert "%INPUT%"
goto :eof

:: -------------------------
:: Help
:: -------------------------
:help
echo.
echo Usage:
echo   svgtopng file.svg [-w N] [-h N] [-o DIR]
echo   svgtopng -a [-o DIR]
echo.
exit /b
