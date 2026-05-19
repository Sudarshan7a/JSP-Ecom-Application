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

param(
    [switch]$SetupOnly,
    [switch]$StartOnly
)

$ErrorActionPreference = "Continue"
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
        Write-Host "[ERROR] Failed to download or extract $Description. $_" -ForegroundColor Red
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

# If StartOnly mode, skip downloads and use existing .dev-tools
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

# Download & extract tools unless we're starting only
if (-not $StartOnly) {
    $JdkPath     = Download-And-Extract $Config.JdkUrl $Config.JdkDir "Java JDK 17"
    $MavenPath   = Download-And-Extract $Config.MavenUrl $Config.MavenDir "Apache Maven 3.9"
    $TomcatPath  = Download-And-Extract $Config.TomcatUrl $Config.TomcatDir "Apache Tomcat 9"
    $MariaDbPath = Download-And-Extract $Config.MariaDbUrl $Config.MariaDbDir "MariaDB 10.11"
} else {
    # Use already-downloaded tools
    $JdkPath     = Join-Path $ToolsDir $Config.JdkDir
    $MavenPath   = Join-Path $ToolsDir $Config.MavenDir
    $TomcatPath  = Join-Path $ToolsDir $Config.TomcatDir
    $MariaDbPath = Join-Path $ToolsDir $Config.MariaDbDir
    Write-Host "[OK] StartOnly: using existing .dev-tools installations." -ForegroundColor Green
}

# Set up Environment Variables strictly for this script session
$env:JAVA_HOME = $JdkPath
$env:M2_HOME = $MavenPath
$env:CATALINA_HOME = $TomcatPath
$env:ECOM_DB_USER = $Config.DbUser
$env:ECOM_DB_PASSWORD = $Config.DbPass
$env:ECOM_DB_URL = "jdbc:mysql://localhost:$($Config.DbPort)/$($Config.DbName)"

$MvnBin = Join-Path $MavenPath "bin\mvn.cmd"
$TomcatStart = Join-Path $TomcatPath "bin\startup.bat"
$TomcatStop = Join-Path $TomcatPath "bin\shutdown.bat"

# Ensure Tomcat uses the default HTTP port 8080.
$ServerXml = Join-Path $TomcatPath "conf\server.xml"
if (Test-Path $ServerXml) {
    try {
        (Get-Content $ServerXml) -replace 'port="8081"', 'port="8080"' | Set-Content $ServerXml
        Write-Host "[OK] Configured Tomcat to use port 8080." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to update server.xml to port 8080: $_"
    }
} else {
    Write-Warning "Tomcat server.xml not found; Tomcat will keep its default ports."
}

# Create setenv.bat to persist DB environment variables across Tomcat restarts
$SetEnvBat = Join-Path $TomcatPath "bin\setenv.bat"
$SetEnvContent = @"
@echo off
REM Database Configuration for JSP E-Commerce App
set ECOM_DB_USER=$($Config.DbUser)
set ECOM_DB_PASSWORD=$($Config.DbPass)
set ECOM_DB_URL=jdbc:mysql://localhost:$($Config.DbPort)/$($Config.DbName)
"@
Set-Content -Path $SetEnvBat -Value $SetEnvContent -Force
Write-Host "[OK] Created Tomcat setenv.bat with database configuration." -ForegroundColor Green

# -----------------------------------------------------------------------------
# 2. Database Initialization and Startup
# -----------------------------------------------------------------------------
Write-Host "`n[*] Configuring Portable Database (MariaDB on port $($Config.DbPort))..." -ForegroundColor Cyan

$DbDataDir = Join-Path $ToolsDir "db-data"
$MariaDbBin = Join-Path $MariaDbPath "bin"
$MysqlInstallDb = Join-Path $MariaDbBin "mysql_install_db.exe"
$Mysqld = Join-Path $MariaDbBin "mysqld.exe"
$MysqlClient = Join-Path $MariaDbBin "mysql.exe"

# Initialize DB data directory if missing
if (-not (Test-Path $DbDataDir)) {
    Write-Host "    -> Initializing fresh database files..."
    if ((Test-Path $MysqlInstallDb) -and (-not $StartOnly)) {
        & $MysqlInstallDb --datadir=$DbDataDir 2>&1 | Out-Null
    } else {
        Ensure-Directory $DbDataDir
    }
}

# Kill any existing mysqld running from our dev-tools
Get-WmiObject Win32_Process -Filter "name='mysqld.exe'" | Where-Object { $_.CommandLine -match "db-data" } | ForEach-Object {
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

# Patch my.ini to include the correct port so MariaDB binds to it on startup
$MyIniPath = Join-Path $DbDataDir "my.ini"
if (Test-Path $MyIniPath) {
    $MyIniContent = Get-Content $MyIniPath -Raw
    if ($MyIniContent -notmatch "port\s*=") {
        # Insert port under [mysqld] section
        $MyIniContent = $MyIniContent -replace '(\[mysqld\])', "`$1`nport=$($Config.DbPort)"
        Set-Content -Path $MyIniPath -Value $MyIniContent -NoNewline
        Write-Host "    -> Patched my.ini with port $($Config.DbPort)." -ForegroundColor Cyan
    } elseif ($MyIniContent -notmatch "port\s*=\s*$($Config.DbPort)") {
        $MyIniContent = $MyIniContent -replace 'port\s*=\s*\d+', "port=$($Config.DbPort)"
        Set-Content -Path $MyIniPath -Value $MyIniContent -NoNewline
        Write-Host "    -> Updated my.ini port to $($Config.DbPort)." -ForegroundColor Cyan
    }
}

# Start Database in background
Write-Host "    -> Starting Database Server..."
$MySqlArgs = "--datadir=$DbDataDir", "--port=$($Config.DbPort)", "--console"
$DbProcess = Start-Process -FilePath $Mysqld -ArgumentList $MySqlArgs -WindowStyle Hidden -PassThru

# Wait for DB to become available
$DbReady = $false
$RetryCount = 0
while (-not $DbReady -and $RetryCount -lt 20) {
    Start-Sleep -Seconds 2
    try {
        # -h 127.0.0.1 forces TCP instead of named pipe on Windows
        & $MysqlClient -u root -h 127.0.0.1 -P $($Config.DbPort) -e "SELECT 1" 2>$null
        if ($LASTEXITCODE -eq 0) { $DbReady = $true }
    } catch { }
    $RetryCount++
    if ($RetryCount % 5 -eq 0) {
        Write-Host "    -> Still waiting for database... ($RetryCount/20)" -ForegroundColor Yellow
    }
}

if (-not $DbReady) {
    Write-Host "[ERROR] Database failed to start! Check .dev-tools\db-data\*.err for details." -ForegroundColor Red
    if ($DbProcess -and -not $DbProcess.HasExited) { Stop-Process -Id $DbProcess.Id -Force }
    exit 1
}

Write-Host "[OK] Database is running." -ForegroundColor Green

# Create schema and user (idempotent)
Write-Host "    -> Verifying Schema and Credentials..."
$SqlSetup = @"
CREATE DATABASE IF NOT EXISTS ``$($Config.DbName)``;
CREATE USER IF NOT EXISTS '$($Config.DbUser)'@'localhost' IDENTIFIED BY '$($Config.DbPass)';
GRANT ALL PRIVILEGES ON *.* TO '$($Config.DbUser)'@'localhost';
FLUSH PRIVILEGES;
"@
$SqlSetup | & $MysqlClient -u root -h 127.0.0.1 -P $($Config.DbPort) 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Database initialization failed!" -ForegroundColor Red
    Stop-Process -Id $DbProcess.Id -Force
    exit 1
}

function Test-CoreTables {
    param(
        [string]$MysqlClientPath,
        [int]$Port,
        [string]$DatabaseName
    )

    $Tables = & $MysqlClientPath -u root -h 127.0.0.1 -P $Port -D $DatabaseName -N -B -e "SELECT table_name FROM information_schema.tables WHERE table_schema = '$DatabaseName' AND table_name IN ('account', 'category', 'product');"
    return ($LASTEXITCODE -eq 0 -and $Tables -match 'account' -and $Tables -match 'category' -and $Tables -match 'product')
}

# Fix collation in the dump file BEFORE importing - MariaDB doesn't support utf8mb4_0900_ai_ci
$DumpFile = Join-Path $ScriptDir "Dump20210903.sql"
if (Test-Path $DumpFile) {
    if ((Select-String -Path $DumpFile -Pattern "utf8mb4_0900_ai_ci" -Quiet) -eq $true) {
        Write-Host "    -> Fixing SQL collation compatibility (one-time)..."
        (Get-Content $DumpFile) -replace 'utf8mb4_0900_ai_ci', 'utf8mb4_unicode_ci' | Set-Content $DumpFile
    }
}

# Import schema from SQL dump only if core tables don't already exist
Write-Host "    -> Importing Database Schema (if needed)..."
if (-not (Test-Path $DumpFile)) {
    Write-Warning "Database dump file not found: $DumpFile (skipping import)"
} elseif (Test-CoreTables -MysqlClientPath $MysqlClient -Port $Config.DbPort -DatabaseName $Config.DbName) {
    Write-Host "[OK] Database schema already present, skipping import." -ForegroundColor Green
} else {
    try {
        # Use cmd /c with input redirection - most reliable way to pipe a file to mysql on Windows
        $importArgs = "-u root -h 127.0.0.1 -P $($Config.DbPort) -D `"$($Config.DbName)`""
        cmd /c "`"$MysqlClient`" $importArgs < `"$DumpFile`"" 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Some SQL statements failed during import, but continuing..."
        } else {
            Write-Host "[OK] Database schema imported successfully." -ForegroundColor Green
        }
    } catch {
        Write-Warning "Failed to import database schema: $_ (continuing)"
    }
}

if (-not (Test-CoreTables -MysqlClientPath $MysqlClient -Port $Config.DbPort -DatabaseName $Config.DbName)) {
    Write-Warning "Database core tables not detected; some features may not work until schema is applied."
} else {
    Write-Host "[OK] Database schema present." -ForegroundColor Green
}

# Add missing product_image_url column if it doesn't exist
Write-Host "    -> Ensuring schema is up-to-date..."
$AlterTableSql = "ALTER TABLE product ADD COLUMN IF NOT EXISTS product_image_url varchar(1000) DEFAULT NULL;"
$AlterTableSql | & $MysqlClient -u $($Config.DbUser) -p$($Config.DbPass) -h 127.0.0.1 -P $($Config.DbPort) $($Config.DbName) 2>&1 | Out-Null

# Add order coupon tracking columns and contact_messages table if they do not exist.
$OrderSchemaSql = @'
ALTER TABLE `order` ADD COLUMN IF NOT EXISTS order_subtotal double DEFAULT NULL;
ALTER TABLE `order` ADD COLUMN IF NOT EXISTS coupon_code varchar(50) DEFAULT NULL;
ALTER TABLE `order` ADD COLUMN IF NOT EXISTS discount_amount double DEFAULT NULL;
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150),
    subject VARCHAR(200),
    message TEXT,
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
'@
$OrderSchemaSql | & $MysqlClient -u root -h 127.0.0.1 -P $($Config.DbPort) $($Config.DbName) 2>&1 | Out-Null

# -----------------------------------------------------------------------------
# 3. Build the Application
# -----------------------------------------------------------------------------
Write-Host "`n[*] Building Application with Maven..." -ForegroundColor Cyan
Set-Location $ScriptDir
& $MvnBin clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Maven build failed!" -ForegroundColor Red
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
$DbUrl = $env:ECOM_DB_URL
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
