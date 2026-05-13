@echo off
echo Setting up MySQL database...
cd /d "C:\Users\Sudupa\Documents\coding\projects\JSP-Ecom-Application"
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u sudupa -proot < setup-db.sql
if %ERRORLEVEL% equ 0 (
    echo [✓] Database setup complete!
) else (
    echo [✗] Database setup failed!
)
pause
