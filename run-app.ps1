# JSP E-Commerce App Runner
# Downloads Tomcat if needed, deploys the pre-built WAR, and starts the server

$ErrorActionPreference = "Stop"
$warFile = "$PSScriptRoot\target\test-1.0-SNAPSHOT.war"
$tomcatDir = "C:\tomcat-runner"
$tomcatHome = "$tomcatDir\apache-tomcat-10.1.24"

# Step 1: Check if WAR exists
if (-not (Test-Path $warFile)) {
    Write-Error "WAR file not found at $warFile. Build the project first with Maven."
    exit 1
}

Write-Host "✓ Found WAR file" -ForegroundColor Green

# Step 2: Download Tomcat if needed
if (-not (Test-Path "$tomcatHome\bin\startup.bat")) {
    Write-Host "Downloading Tomcat 10.1.24..." -ForegroundColor Yellow
    if (-not (Test-Path $tomcatDir)) { New-Item -ItemType Directory -Path $tomcatDir | Out-Null }
    
    $ProgressPreference = 'SilentlyContinue'
    $tomcatUrl = "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.24/bin/apache-tomcat-10.1.24.zip"
    Invoke-WebRequest -Uri $tomcatUrl -OutFile "$tomcatDir\tomcat.zip"
    
    Write-Host "Extracting Tomcat..." -ForegroundColor Yellow
    Expand-Archive "$tomcatDir\tomcat.zip" -DestinationPath $tomcatDir -Force
    Remove-Item "$tomcatDir\tomcat.zip"
    Write-Host "✓ Tomcat installed" -ForegroundColor Green
}

# Step 3: Deploy WAR
$webappsDir = "$tomcatHome\webapps"
$appDir = "$webappsDir\ROOT"

if (Test-Path $appDir) {
    Write-Host "Removing old deployment..." -ForegroundColor Yellow
    Remove-Item $appDir -Recurse -Force
}

Write-Host "Deploying WAR..." -ForegroundColor Yellow
Copy-Item $warFile "$webappsDir\ROOT.war" -Force
Write-Host "✓ WAR deployed to ROOT" -ForegroundColor Green

# Step 4: Start Tomcat
Write-Host "`nStarting Tomcat..." -ForegroundColor Cyan
Write-Host "App will be available at: http://localhost:8080" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server`n" -ForegroundColor Yellow

$env:CATALINA_HOME = $tomcatHome
& "$tomcatHome\bin\startup.bat"

# Keep script running and show logs
Start-Sleep -Seconds 3
Get-Content "$tomcatHome\logs\catalina.out" -Wait
