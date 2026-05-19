# Start-only wrapper: starts DB and Tomcat using existing .dev-tools (no downloads)
param()

Write-Host "Starting application (using existing .dev-tools)..." -ForegroundColor Cyan
powershell -NoProfile -ExecutionPolicy Bypass -File .\bootstrap-and-run.ps1 -StartOnly
if ($LASTEXITCODE -eq 0) { Write-Host "Start complete; app should be live at http://localhost:8080" -ForegroundColor Green } else { Write-Host "Start finished with errors." -ForegroundColor Yellow }
