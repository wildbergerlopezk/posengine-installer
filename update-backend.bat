@echo off
echo Actualizando backend PosEngine...
cd C:\PosEngine

:: Baja la imagen latest de Docker Hub
docker compose pull backend

:: Reinicia solo el backend (no toca postgres ni nginx)
docker compose up -d --no-deps backend

echo Backend actualizado!