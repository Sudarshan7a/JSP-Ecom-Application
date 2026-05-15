<#
.SYNOPSIS
    Zero-install Bootstrap and Run Script for JSP E-Commerce App.

.DESCRIPTION
    This script creates a fully self-contained, portable development environment.
    It automatically downloads and configures JDK 17, Maven 3.9, Tomcat 9, and MariaDB.
    It then builds the project, initializes the database, and starts the server.

.NOTES
    First run will take several minutes to download dependencies (~250MB).
    Subsequent runs will use the cached tools in the .dev-tools directory.
#>

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ToolsDir = Join-Path $ScriptDir ".dev-tools"

# -----------------------------------------------------------------------------
# Configuration & URLs
# -----------------------------------------------------------------------------
$Config = @{
    JdkUrl     = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_x64_windows_hotspot_17.0.11_9.zip"
    JdkDir     = "jdk-17.0.11+9"
    
    MavenUrl   = "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
    MavenDir   = "apache-maven-3.9.6"
    
    TomcatUrl  = "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89-windows-x64.zip"
    TomcatDir  = "apache-tomcat-9.0.89"
    
    MariaDbUrl = "https://archive.mariadb.org/mariadb-10.11.8/winx64-packages/mariadb-10.11.8-winx64.zip"
    MariaDbDir = "mariadb-10.11.8-winx64"
    
    DbPort     = 33306
    DbName     = "jsp-servlet-ecommerce-website"
    DbUser     = "sudupa"
    DbPass     = "root"
}

# -----------------------------------------------------------------------------
# Utility Functions
# -----------------------------------------------------------------------------
function Ensure-Directory {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Download-And-Extract {
    param(
        [string]$Url,
        [string]$ExtractDirName,
        [string]$Description
    )
    $TargetDir = Join-Path $ToolsDir $ExtractDirName
    if (Test-Path $TargetDir) {
        Write-Host "[OK] $Description is already installed." -ForegroundColor Green
        return $TargetDir
    }

    Write-Host "[*] Downloading $Description..." -ForegroundColor Cyan
    $ZipPath = Join-Path $ToolsDir "$ExtractDirName.zip"
    
    try {
        Invoke-WebRequest -Uri $Url -OutFile $ZipPath -UseBasicParsing
        Write-Host "[*] Extracting $Description..." -ForegroundColor Cyan
        Expand-Archive -Path $ZipPath -DestinationPath $ToolsDir -Force
        Remove-Item $ZipPath -Force
        Write-Host "[+] Successfully set up $Description.`n" -ForegroundColor Green
    } catch {
        Write-Error "Failed to download or extract $Description. $_"
        exit 1
    }
    return $TargetDir
}

# -----------------------------------------------------------------------------
# 1. Setup Toolchain
# -----------------------------------------------------------------------------
Clear-Host
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host "  JSP E-Commerce - Portable Environment Setup          " -ForegroundColor Magenta
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host "Setting up completely portable environment in .dev-tools...`n"

Ensure-Directory $ToolsDir

# Add .dev-tools to .gitignore if not present
$GitIgnorePath = Join-Path $ScriptDir ".gitignore"
if (Test-Path $GitIgnorePath) {
    $GitIgnoreContent = Get-Content $GitIgnorePath
    if ($GitIgnoreContent -notcontains ".dev-tools/") {
        Add-Content $GitIgnorePath "`n# Portable Dev Tools`n.dev-tools/"
    }
} else {
    Set-Content $GitIgnorePath ".dev-tools/"
}

$JdkPath     = Download-And-Extract $Config.JdkUrl $Config.JdkDir "Java JDK 17"
$MavenPath   = Download-And-Extract $Config.MavenUrl $Config.MavenDir "Apache Maven 3.9"
$TomcatPath  = Download-And-Extract $Config.TomcatUrl $Config.TomcatDir "Apache Tomcat 9"
$MariaDbPath = Download-And-Extract $Config.MariaDbUrl $Config.MariaDbDir "MariaDB 10.11"

# Set up Environment Variables strictly for this script session
$env:JAVA_HOME = $JdkPath
$env:M2_HOME = $MavenPath
$env:CATALINA_HOME = $TomcatPath

$MvnBin = Join-Path $MavenPath "bin\mvn.cmd"
$TomcatStart = Join-Path $TomcatPath "bin\startup.bat"
$TomcatStop = Join-Path $TomcatPath "bin\shutdown.bat"

# -----------------------------------------------------------------------------
# 2. Database Initialization and Startup
# -----------------------------------------------------------------------------
Write-Host "`n[*] Configuring Portable Database (MariaDB on port $($Config.DbPort))..." -ForegroundColor Cyan

$DbDataDir = Join-Path $ToolsDir "db-data"
$MariaDbBin = Join-Path $MariaDbPath "bin"
$MysqlInstallDb = Join-Path $MariaDbBin "mysql_install_db.exe"
$Mysqld = Join-Path $MariaDbBin "mysqld.exe"
$MysqlClient = Join-Path $MariaDbBin "mysql.exe"

# Initialize DB if data dir doesn't exist
if (-not (Test-Path $DbDataDir)) {
    Write-Host "    -> Initializing fresh database files..."
    & $MysqlInstallDb --datadir=$DbDataDir 2>&1 | Out-Null
}

# Find and kill any existing mysqld running from our dev-tools
Get-WmiObject Win32_Process -Filter "name='mysqld.exe'" | Where-Object { $_.CommandLine -match "db-data" } | ForEach-Object {
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

# Start Database in background
Write-Host "    -> Starting Database Server..."
$MySqlArgs = "--datadir=$DbDataDir", "--port=$($Config.DbPort)", "--console"
$DbProcess = Start-Process -FilePath $Mysqld -ArgumentList $MySqlArgs -WindowStyle Hidden -PassThru

# Wait for DB to become available
$DbReady = $false
$RetryCount = 0
while (-not $DbReady -and $RetryCount -lt 15) {
    Start-Sleep -Seconds 2
    try {
        & $MysqlClient -u root -P $($Config.DbPort) -e "SELECT 1" 2>$null
        if ($LASTEXITCODE -eq 0) { $DbReady = $true }
    } catch { }
    $RetryCount++
}

if (-not $DbReady) {
    Write-Error "Database failed to start!"
    exit 1
}

Write-Host "[OK] Database is running." -ForegroundColor Green

# Create schema and user
Write-Host "    -> Verifying Schema and Credentials..."
$SqlSetup = @"
CREATE DATABASE IF NOT EXISTS \`$($Config.DbName)\`;
CREATE USER IF NOT EXISTS '$($Config.DbUser)'@'localhost' IDENTIFIED BY '$($Config.DbPass)';
GRANT ALL PRIVILEGES ON *.* TO '$($Config.DbUser)'@'localhost';
FLUSH PRIVILEGES;
"@
$SqlSetup | & $MysqlClient -u root -P $($Config.DbPort) 2>&1 | Out-Null

# -----------------------------------------------------------------------------
# 3. Build the Application
# -----------------------------------------------------------------------------
Write-Host "`n[*] Building Application with Maven..." -ForegroundColor Cyan
Set-Location $ScriptDir
& $MvnBin clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Error "Maven build failed!"
    Stop-Process -Id $DbProcess.Id -Force
    exit 1
}
Write-Host "[OK] Build successful." -ForegroundColor Green

# -----------------------------------------------------------------------------
# 4. Deploy and Start Tomcat
# -----------------------------------------------------------------------------
Write-Host "`n[*] Deploying to Portable Tomcat..." -ForegroundColor Cyan
& $TomcatStop 2>$null
Start-Sleep -Seconds 2

$RootApp = Join-Path $TomcatPath "webapps\ROOT"
$RootWar = Join-Path $TomcatPath "webapps\ROOT.war"
if (Test-Path $RootApp) { Remove-Item $RootApp -Recurse -Force }
if (Test-Path $RootWar) { Remove-Item $RootWar -Force }
Copy-Item ".\target\test-1.0-SNAPSHOT.war" $RootWar -Force

# Configure Tomcat to use our portable DB parameters
$DbUrl = "jdbc:mysql://localhost:$($Config.DbPort)/$($Config.DbName)"
$env:CATALINA_OPTS = "-Decom.db.url=""$DbUrl"" -Decom.db.user=""$($Config.DbUser)"" -Decom.db.password=""$($Config.DbPass)"""

Write-Host "    -> Starting Tomcat..."
Start-Process -FilePath $TomcatStart -WorkingDirectory (Join-Path $TomcatPath "bin") -WindowStyle Hidden

Start-Sleep -Seconds 4
Write-Host "[OK] Tomcat is running." -ForegroundColor Green

# -----------------------------------------------------------------------------
# 5. Open Browser and Monitor
# -----------------------------------------------------------------------------
Start-Process "http://localhost:8080"

Write-Host "`n=======================================================" -ForegroundColor Magenta
Write-Host " Application is live at: http://localhost:8080" -ForegroundColor White
Write-Host " Database is running on port: $($Config.DbPort)" -ForegroundColor White
Write-Host "=======================================================" -ForegroundColor Magenta
Write-Host "`nPress Ctrl+C to gracefully shut down the servers and exit." -ForegroundColor Yellow

try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    Write-Host "`n[*] Shutting down Tomcat..." -ForegroundColor Cyan
    & $TomcatStop 2>$null
    
    Write-Host "[*] Shutting down Database..." -ForegroundColor Cyan
    if ($DbProcess -and -not $DbProcess.HasExited) {
        Stop-Process -Id $DbProcess.Id -Force
    }
    
    Write-Host "[OK] All portable services stopped gracefully." -ForegroundColor Green
}
