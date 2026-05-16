# JSP E-Commerce App Runner (PowerShell)
# This script prepares a local Tomcat 9 environment, builds the project with Maven, and runs the app.

$ErrorActionPreference = "Stop"
$projectName = "jsp-servlet-ecommerce-website"
$warFile = Join-Path $PSScriptRoot "target\test-1.0-SNAPSHOT.war"
$toolsRoot = Join-Path $PSScriptRoot ".dev-tools"
$tomcatRoot = $toolsRoot
$jdkHome = Join-Path $toolsRoot "jdk-17.0.11+9"
$jdkZip = Join-Path $toolsRoot "jdk-17.0.11+9.zip"
$tomcatHome = Join-Path $tomcatRoot "apache-tomcat-9.0.117"
$mavenHome = Join-Path $tomcatRoot "apache-maven-3.9.6"
$mvnCmd = "mvn"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   JSP E-Commerce App Launcher & Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 0. Setup JDK if missing
if (-not (Test-Path (Join-Path $jdkHome "bin\java.exe"))) {
    Write-Host "[*] Downloading JDK 17..." -ForegroundColor Yellow
    if (-not (Test-Path $toolsRoot)) { New-Item -ItemType Directory -Path $toolsRoot | Out-Null }
    $jdkUrl = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_x64_windows_hotspot_17.0.11_9.zip"
    Invoke-WebRequest -Uri $jdkUrl -OutFile $jdkZip
    Write-Host "[*] Extracting JDK..." -ForegroundColor Yellow
    Expand-Archive -Path $jdkZip -DestinationPath $toolsRoot -Force
    Remove-Item $jdkZip
}

# 1. Setup Maven if missing
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    if (-not (Test-Path (Join-Path $mavenHome "bin\mvn.cmd"))) {
        Write-Host "[*] Downloading Maven 3.9.6..." -ForegroundColor Yellow
        if (-not (Test-Path $toolsRoot)) { New-Item -ItemType Directory -Path $toolsRoot | Out-Null }
        $mvnZip = Join-Path $tomcatRoot "maven.zip"
        Invoke-WebRequest -Uri "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip" -OutFile $mvnZip
        Write-Host "[*] Extracting Maven..." -ForegroundColor Yellow
        Expand-Archive -Path $mvnZip -DestinationPath $toolsRoot -Force
        Remove-Item $mvnZip
    }
    $mvnCmd = Join-Path $mavenHome "bin\mvn.cmd"
    Write-Host "[OK] Using local Maven at $mvnCmd" -ForegroundColor Green
} else {
    Write-Host "[OK] Using system Maven" -ForegroundColor Green
}

# 2. Build the Project
Write-Host "`n[*] Building project (this might take a minute)..." -ForegroundColor Yellow
Set-Location $PSScriptRoot
& $mvnCmd clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed! Check the console output above." -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Build successful!" -ForegroundColor Green

# 3. Download Tomcat 9 if missing
if (-not (Test-Path (Join-Path $tomcatHome "bin\startup.bat"))) {
    Write-Host "`n[*] Downloading Tomcat 9.0.117 (first time only)..." -ForegroundColor Yellow
    if (-not (Test-Path $toolsRoot)) { New-Item -ItemType Directory -Path $toolsRoot | Out-Null }
    
    $zipPath = Join-Path $toolsRoot "tomcat.zip"
    $url = "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.117/bin/apache-tomcat-9.0.117.zip"
    
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    
    Write-Host "[*] Extracting Tomcat..." -ForegroundColor Yellow
    Expand-Archive -Path $zipPath -DestinationPath $toolsRoot -Force
    Remove-Item $zipPath
    Write-Host "[OK] Tomcat installed" -ForegroundColor Green
}

# 4. Stop existing Tomcat if running
$webapps = Join-Path $tomcatHome "webapps"
$shutdownBat = Join-Path $tomcatHome "bin\shutdown.bat"
if (Test-Path $shutdownBat) {
    Write-Host "`n[*] Stopping existing Tomcat..." -ForegroundColor Yellow
    Start-Process -FilePath $shutdownBat -WorkingDirectory (Join-Path $tomcatHome "bin") -NoNewWindow -Wait -ErrorAction SilentlyContinue
    # Wait for Tomcat java process to fully exit
    $retries = 0
    while ($retries -lt 15) {
        $tomcatProcs = Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object {
            try { $_.MainModule.FileName -like "*$tomcatHome*" } catch { $false }
        }
        # Also check if the jstl jar is still locked
        $jstlLocked = $false
        $jstlPath = Join-Path $webapps "ROOT\WEB-INF\lib\jstl-1.2.jar"
        if (Test-Path $jstlPath) {
            try {
                [IO.File]::Open($jstlPath, 'Open', 'ReadWrite', 'None').Close()
            } catch {
                $jstlLocked = $true
            }
        }
        if (-not $tomcatProcs -and -not $jstlLocked) { break }
        Start-Sleep -Seconds 1
        $retries++
    }
    if ($retries -ge 15) {
        Write-Host "[WARN] Tomcat may not have fully stopped. Attempting deployment anyway..." -ForegroundColor Yellow
    } else {
        Write-Host "[OK] Tomcat stopped" -ForegroundColor Green
    }
}

# 5. Deploy App to ROOT
Write-Host "`n[*] Deploying application..." -ForegroundColor Yellow
$webapps = Join-Path $tomcatHome "webapps"
$rootApp = Join-Path $webapps "ROOT"
$rootWar = Join-Path $webapps "ROOT.war"

if (Test-Path $rootApp) { Remove-Item $rootApp -Recurse -Force }
if (Test-Path $rootWar) { Remove-Item $rootWar -Force }

Copy-Item $warFile $rootWar -Force
Write-Host "[OK] Deployed as ROOT application" -ForegroundColor Green

# 6. Set Environment Variables for DB Mode
$env:JAVA_HOME = $jdkHome
$env:ECOM_DB_USER = "sudupa"
$env:ECOM_DB_PASSWORD = "root"
$env:ECOM_DB_URL = "jdbc:mysql://localhost:33306/jsp-servlet-ecommerce-website"
# Also pass as JVM system properties so Tomcat's JVM can always access them
$env:CATALINA_OPTS = '-Decom.db.url="' + $env:ECOM_DB_URL + '" -Decom.db.user=sudupa -Decom.db.password=root'

# 7. Launch Tomcat
Write-Host "`n----------------------------------------" -ForegroundColor Cyan
Write-Host "Starting Tomcat Server..." -ForegroundColor Green
Write-Host "URL: http://localhost:8081" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to exit this script (server stays running)" -ForegroundColor Gray
Write-Host "----------------------------------------" -ForegroundColor Cyan

$env:CATALINA_HOME = $tomcatHome
Start-Process -FilePath (Join-Path $tomcatHome "bin\startup.bat") -WorkingDirectory (Join-Path $tomcatHome "bin")

Write-Host "Launching browser..." -ForegroundColor Gray
Start-Sleep -Seconds 5
Start-Process "http://localhost:8081"

