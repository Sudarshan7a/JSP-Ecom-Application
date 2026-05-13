# JSP E-Commerce App Runner (PowerShell)
# This script prepares a local Tomcat 9 environment, builds the project with Maven, and runs the app.

$ErrorActionPreference = "Stop"
$projectName = "jsp-servlet-ecommerce-website"
$warFile = Join-Path $PSScriptRoot "target\test-1.0-SNAPSHOT.war"
$tomcatRoot = "C:\tomcat-ecom"
$tomcatHome = Join-Path $tomcatRoot "apache-tomcat-9.0.117"
$mavenHome = Join-Path $tomcatRoot "apache-maven-3.9.6"
$mvnCmd = "mvn"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   JSP E-Commerce App Launcher & Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Setup Maven if missing
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    if (-not (Test-Path (Join-Path $mavenHome "bin\mvn.cmd"))) {
        Write-Host "[*] Downloading Maven 3.9.6..." -ForegroundColor Yellow
        if (-not (Test-Path $tomcatRoot)) { New-Item -ItemType Directory -Path $tomcatRoot | Out-Null }
        $mvnZip = Join-Path $tomcatRoot "maven.zip"
        Invoke-WebRequest -Uri "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip" -OutFile $mvnZip
        Write-Host "[*] Extracting Maven..." -ForegroundColor Yellow
        Expand-Archive -Path $mvnZip -DestinationPath $tomcatRoot -Force
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
    if (-not (Test-Path $tomcatRoot)) { New-Item -ItemType Directory -Path $tomcatRoot | Out-Null }
    
    $zipPath = Join-Path $tomcatRoot "tomcat.zip"
    $url = "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.117/bin/apache-tomcat-9.0.117.zip"
    
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    
    Write-Host "[*] Extracting Tomcat..." -ForegroundColor Yellow
    Expand-Archive -Path $zipPath -DestinationPath $tomcatRoot -Force
    Remove-Item $zipPath
    Write-Host "[OK] Tomcat installed" -ForegroundColor Green
}

# 4. Deploy App to ROOT
Write-Host "`n[*] Deploying application..." -ForegroundColor Yellow
$webapps = Join-Path $tomcatHome "webapps"
$rootApp = Join-Path $webapps "ROOT"
$rootWar = Join-Path $webapps "ROOT.war"

if (Test-Path $rootApp) { Remove-Item $rootApp -Recurse -Force }
if (Test-Path $rootWar) { Remove-Item $rootWar -Force }

Copy-Item $warFile $rootWar -Force
Write-Host "[OK] Deployed as ROOT application" -ForegroundColor Green

# 5. Set Environment Variables for Demo Mode
$env:ECOM_DB_USER = "sudupa"
$env:ECOM_DB_PASSWORD = "root"

# 6. Launch Tomcat
Write-Host "`n----------------------------------------" -ForegroundColor Cyan
Write-Host "Starting Tomcat Server..." -ForegroundColor Green
Write-Host "URL: http://localhost:8080" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to exit this script (server stays running)" -ForegroundColor Gray
Write-Host "----------------------------------------" -ForegroundColor Cyan

$env:CATALINA_HOME = $tomcatHome
Start-Process -FilePath (Join-Path $tomcatHome "bin\startup.bat") -WorkingDirectory (Join-Path $tomcatHome "bin")

Write-Host "Launching browser..." -ForegroundColor Gray
Start-Sleep -Seconds 5
Start-Process "http://localhost:8080"

