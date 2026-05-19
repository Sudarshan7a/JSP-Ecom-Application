@echo off
echo Setting up MySQL database...

REM Dynamically resolve the directory this script lives in
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM Find mysql.exe - check common install locations
set "MYSQL_EXE="
for %%P in (
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
    "C:\Program Files\MySQL\MySQL Server 8.1\bin\mysql.exe"
    "C:\Program Files\MySQL\MySQL Server 8.2\bin\mysql.exe"
    "C:\Program Files\MySQL\MySQL Server 8.3\bin\mysql.exe"
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
    "C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin\mysql.exe"
) do (
    if exist %%P set "MYSQL_EXE=%%~P"
)

REM Also check PATH
if not defined MYSQL_EXE (
    where mysql.exe >nul 2>&1
    if %ERRORLEVEL% equ 0 set "MYSQL_EXE=mysql.exe"
)

if not defined MYSQL_EXE (
    echo [!] mysql.exe not found. Please install MySQL or add it to PATH.
    pause
    exit /b 1
)

echo Using MySQL: %MYSQL_EXE%

REM Step 1: Create database
"%MYSQL_EXE%" -u sudupa -proot < "%SCRIPT_DIR%setup-db.sql"
if %ERRORLEVEL% neq 0 (
    echo [FAIL] Failed to create database!
    pause
    exit /b 1
)

REM Step 2: Import the dump directly (avoids SOURCE path issues)
echo Importing schema from Dump20210903.sql...
"%MYSQL_EXE%" -u sudupa -proot jsp-servlet-ecommerce-website < "%SCRIPT_DIR%Dump20210903.sql"
if %ERRORLEVEL% equ 0 (
    echo [OK] Database setup complete!
) else (
    echo [FAIL] Database setup failed!
)
pause
