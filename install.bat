@echo off
cd /d %~dp0

echo =====================================
echo        Instalador PosEngine
echo =====================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Ejecuta como Administrador
    pause
    exit /b
)

powershell -ExecutionPolicy Bypass -File install.ps1

echo.
echo Instalacion finalizada
pause