# JSP E-Commerce App Runner (PowerShell)
# Delegate to the portable bootstrap flow so database, build, and server setup stay in one place.

$ErrorActionPreference = "Stop"
$bootstrap = Join-Path $PSScriptRoot "bootstrap-and-run.ps1"

if (-not (Test-Path $bootstrap)) {
    Write-Host "[ERROR] bootstrap-and-run.ps1 not found next to this script." -ForegroundColor Red
    exit 1
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $bootstrap
exit $LASTEXITCODE

