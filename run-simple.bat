@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   JSP E-Commerce App Launcher
echo ========================================
echo.

REM Set paths
set "PROJECT_DIR=%~dp0"
set "WAR_FILE=%PROJECT_DIR%target\test-1.0-SNAPSHOT.war"
set "TOMCAT_DIR=C:\tomcat-ecom"
set "TOMCAT_HOME=%TOMCAT_DIR%\apache-tomcat-9.0.117"
set "TOMCAT_STARTUP=%TOMCAT_HOME%\bin\startup.bat"

REM Step 1: Check WAR exists
if not exist "%WAR_FILE%" (
    echo [ERROR] WAR file not found at %WAR_FILE%
    echo Build with Maven first!
    pause
    exit /b 1
)
echo [✓] Found WAR file

REM Step 2: Download Tomcat if needed
if not exist "%TOMCAT_STARTUP%" (
    echo.
    echo [*] Downloading Tomcat 9.0.117 ^(first time only^)...
    if not exist "%TOMCAT_DIR%" mkdir "%TOMCAT_DIR%"
    
    curl -L -o "%TOMCAT_DIR%\tomcat.zip" "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.117/bin/apache-tomcat-9.0.117.zip"
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] Download failed
        pause
        exit /b 1
    )
    
    cd /d "%TOMCAT_DIR%"
    tar -xf tomcat.zip
    del tomcat.zip
    cd /d "%PROJECT_DIR%"
    
    if not exist "%TOMCAT_STARTUP%" (
        echo [ERROR] Tomcat extraction failed
        pause
        exit /b 1
    )
    echo [✓] Tomcat installed
)

REM Step 3: Deploy WAR to ROOT
echo.
echo [*] Deploying application...
set "WEBAPPS=%TOMCAT_HOME%\webapps"

if exist "%WEBAPPS%\ROOT" rmdir /S /Q "%WEBAPPS%\ROOT" 2>nul
if exist "%WEBAPPS%\ROOT.war" del /Q "%WEBAPPS%\ROOT.war" 2>nul

copy /Y "%WAR_FILE%" "%WEBAPPS%\ROOT.war" >nul
echo [✓] Application deployed

REM Step 4: Set Database Credentials
echo.
echo [*] Setting database credentials...
set "ECOM_DB_USER=sudupa"
set "ECOM_DB_PASSWORD=root"
echo [✓] DB user: sudupa ^(password: root^)

REM Step 5: Start Tomcat
echo.
echo ========================================
echo [*] Starting Tomcat...
echo [✓] App available at: http://localhost:8080
echo [*] Press Ctrl+C to stop
echo ========================================
echo.

set "CATALINA_HOME=%TOMCAT_HOME%"
call "%TOMCAT_STARTUP%"

pause
