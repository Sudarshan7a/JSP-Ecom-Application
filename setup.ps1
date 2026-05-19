# Setup-only wrapper: downloads tools and prepares DB schema without starting Tomcat
param()

Write-Host "Running setup (download tools, initialize DB schema)..." -ForegroundColor Cyan
powershell -NoProfile -ExecutionPolicy Bypass -File .\bootstrap-and-run.ps1 -SetupOnly
if ($LASTEXITCODE -eq 0) { Write-Host "Setup completed." -ForegroundColor Green } else { Write-Host "Setup finished with errors." -ForegroundColor Yellow }
