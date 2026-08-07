@echo off
setlocal enabledelayedexpansion

:SET_ROOT
echo ===================================================
echo               SET ROOT DIRECTORY
echo ===================================================
set /p "ROOT_DIR=Enter root directory path: "

:: Remove quotes
set "ROOT_DIR=%ROOT_DIR:"=%"

:: Validate root directory
if not exist "%ROOT_DIR%\" (
    echo [ERROR] Invalid directory! Please enter a valid root folder.
    echo.
    goto SET_ROOT
)

:: Change active directory to the set root
cd /d "%ROOT_DIR%"

:LOOP
echo.
echo ---------------------------------------------------
echo Active Root: %CD%
set /p "user_path=Enter path/file (or RESET / EXIT): "

:: Remove quotes
set "user_path=%user_path:"=%"

:: Menu controls
if /i "%user_path%"=="EXIT" goto END
if /i "%user_path%"=="RESET" (
    cls
    goto SET_ROOT
)

if "%user_path%"=="" goto LOOP

:: Check if the path exists
if exist "%user_path%" (
    echo Opening: "%user_path%"
    start "" "%user_path%"
    goto LOOP
)

:: --- PATH NOT FOUND: CONFIRM CREATION ---
echo.
echo [!] Path not found: "%user_path%"
set /p "choice=Do you want to create it? (Y/N): "
if /i not "%choice%"=="Y" (
    echo Cancelled.
    goto LOOP
)

:: Determine if it's a folder or file based on trailing slashes
set "LAST_CHAR=%user_path:~-1%"

if "%LAST_CHAR%"=="\" goto IS_FOLDER
if "%LAST_CHAR%"=="/" goto IS_FOLDER
goto IS_FILE

:IS_FOLDER
mkdir "%user_path%" 2>nul
if exist "%user_path%" (
    echo [SUCCESS] Folder created.
    start "" "%user_path%"
) else (
    echo [ERROR] Failed to create folder.
)
goto LOOP

:IS_FILE
:: Extract directory portion using a temporary loop construct
for %%I in ("%user_path%") do set "PARENT_DIR=%%~dpI"

:: Create parent directories if they don't exist
if not exist "%PARENT_DIR%" (
    mkdir "%PARENT_DIR%" 2>nul
)

:: Create the blank file
type nul > "%user_path%"

if exist "%user_path%" (
    echo [SUCCESS] File created.
    start "" "%user_path%"
) else (
    echo [ERROR] Failed to create file.
)

goto LOOP

:END
echo Exiting...
timeout /t 2 >nul
