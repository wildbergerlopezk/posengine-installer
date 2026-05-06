@echo off
echo Actualizando backend PosEngine...
cd C:\PosEngine

:: 1. Actualizar docker-compose.yml desde GitHub
echo Actualizando configuracion...
curl -o C:\PosEngine\docker-compose.yml ^
  https://raw.githubusercontent.com/wildbergerlopezk/posengine-installer/main/docker-compose.yml

:: 2. Bajar la nueva imagen
echo Bajando nueva imagen...
docker compose pull backend

:: 3. Reiniciar solo el backend
echo Reiniciando backend...
docker compose up -d --no-deps backend

echo.
echo Backend actualizado!
pause