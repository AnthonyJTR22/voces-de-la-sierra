@echo off
title Voces de la Sierra - Traductor Offline Espanol-Nahuatl
color 0A

echo.
echo  ============================================================
echo  =                                                          =
echo  =            VOCES DE LA SIERRA v1.0                       =
echo  =            Traductor Bilingue Esp - Nahuatl              =
echo  =            100%% Offline - Sin Internet                   =
echo  =                                                          =
echo  ============================================================
echo.
echo  Powered by Gemma 4 E2B + llama.cpp
echo.

:: ── Verificar que los archivos existen ──
set "MODEL=google_gemma-4-E2B-it-Q4_K_M.gguf"
set "LORA=voces_sierra_lora_v2.gguf"
set "SERVER=llama-server.exe"

if not exist "%MODEL%" (
    echo  [ERROR] No se encontro el modelo base: %MODEL%
    echo  Descargalo de: https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF
    echo  y colocalo en esta carpeta.
    echo.
    pause
    exit /b 1
)

if not exist "%LORA%" (
    echo  [ERROR] No se encontro el adaptador LoRA: %LORA%
    echo  Descargalo de Google Drive y colocalo en esta carpeta.
    echo.
    pause
    exit /b 1
)

if not exist "%SERVER%" (
    echo  [ERROR] No se encontro llama-server.exe
    echo  Descarga llama.cpp desde: https://github.com/ggml-org/llama.cpp/releases
    echo  y coloca llama-server.exe en esta carpeta.
    echo.
    pause
    exit /b 1
)

echo  [OK] Modelo base encontrado
echo  [OK] Adaptador LoRA encontrado
echo  [OK] Servidor llama.cpp encontrado
echo.
echo  Iniciando servidor...
echo  Cuando vea "listening on http://...", abra su navegador en:
echo.
echo       http://localhost:8080
echo.
echo  Para detener el servidor, cierre esta ventana.
echo  ============================================================
echo.

:: ── Iniciar el servidor ──
"%SERVER%" ^
    -m "%MODEL%" ^
    --lora "%LORA%" ^
    --chat-template gemma ^
    --port 8080 ^
    -n 200

:: Si el servidor se cierra, pausar para ver errores
echo.
echo  El servidor se detuvo.
pause
