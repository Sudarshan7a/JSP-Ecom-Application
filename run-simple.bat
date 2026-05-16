@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "BOOTSTRAP=%SCRIPT_DIR%bootstrap-and-run.ps1"

if not exist "%BOOTSTRAP%" (
    echo [ERROR] bootstrap-and-run.ps1 not found next to this script.
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%BOOTSTRAP%"
exit /b %ERRORLEVEL%
