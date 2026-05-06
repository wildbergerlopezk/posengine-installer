@echo off
setlocal

:: ─── Configuración ───────────────────────────────────────────────
set BACKUP_DIR=C:\PosEngine\backups
set CONTAINER=posengine-postgres
set DB_USER=posengine
set DB_NAME=posengine

:: Fecha para el nombre del archivo
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set FECHA=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%

:: ─── Backup base de datos ─────────────────────────────────────────
echo [1/2] Haciendo backup de la base de datos...

docker exec %CONTAINER% pg_dump -U %DB_USER% %DB_NAME% > "%BACKUP_DIR%\db_%FECHA%.sql"

if %errorlevel% neq 0 (
    echo ERROR: No se pudo hacer el backup de la DB
    exit /b 1
)

echo Backup DB guardado: db_%FECHA%.sql

:: ─── Backup imágenes ──────────────────────────────────────────────
echo [2/2] Haciendo backup de imágenes...

docker run --rm ^
    -v posengine-frontend_uploads_data:/data ^
    -v "%BACKUP_DIR%":/backup ^
    alpine tar czf /backup/uploads_%FECHA%.tar.gz -C /data .

if %errorlevel% neq 0 (
    echo ERROR: No se pudo hacer el backup de imágenes
    exit /b 1
)

echo Backup imágenes guardado: uploads_%FECHA%.tar.gz

:: ─── Limpiar backups viejos (más de 30 días) ──────────────────────
echo Limpiando backups antiguos...
forfiles /p "%BACKUP_DIR%" /s /m *.sql     /d -30 /c "cmd /c del @path" 2>nul
forfiles /p "%BACKUP_DIR%" /s /m *.tar.gz  /d -30 /c "cmd /c del @path" 2>nul

echo.
echo ================================
echo  BACKUP COMPLETADO - %FECHA%
echo ================================