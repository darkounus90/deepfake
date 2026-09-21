@echo off
REM ============================================================
REM  iRoopDeepFaceCam - instalador para Windows + NVIDIA (CUDA 12.8)
REM  Crea .venv, instala dependencias, aplica parches,
REM  descarga modelos y ffmpeg. Se puede volver a ejecutar sin problema.
REM ============================================================
setlocal
cd /d "%~dp0"

echo.
echo [1/6] Buscando Python 3.10...
py -3.10 --version >nul 2>&1
if errorlevel 1 (
    echo Python 3.10 no esta instalado. Instalando con winget...
    winget install --id Python.Python.3.10 -e --source winget --accept-package-agreements --accept-source-agreements
    py -3.10 --version >nul 2>&1
    if errorlevel 1 (
        echo.
        echo ERROR: no se encontro Python 3.10. Instalalo desde https://www.python.org/downloads/release/python-31011/
        echo y vuelve a ejecutar este script.
        pause
        exit /b 1
    )
)

echo.
echo [2/6] Creando entorno virtual .venv...
if not exist ".venv\Scripts\python.exe" (
    py -3.10 -m venv .venv || goto :error
)
set "PY=%~dp0.venv\Scripts\python.exe"
"%PY%" -m pip install --upgrade pip || goto :error

echo.
echo [3/6] Instalando dependencias (varios GB, puede tardar)...
"%PY%" -m pip install -r requirements-local-cu128.txt || goto :error

echo.
echo [4/6] Parcheando basicsr para torchvision nuevo...
"%PY%" -c "import pathlib,basicsr; p=pathlib.Path(basicsr.__file__).parent/'data'/'degradations.py'; s=p.read_text(encoding='utf-8'); n=s.replace('torchvision.transforms.functional_tensor','torchvision.transforms.functional'); p.write_text(n,encoding='utf-8'); print('  parcheado' if n!=s else '  ya estaba parcheado')" || goto :error

echo.
echo [5/6] Descargando modelos...
if not exist models mkdir models
if not exist "models\inswapper_128_fp16.onnx" (
    curl -L --fail -o "models\inswapper_128_fp16.onnx" https://huggingface.co/ivideogameboss/iroopdeepfacecam/resolve/main/inswapper_128_fp16.onnx || goto :error
) else echo   inswapper_128_fp16.onnx ya existe
if not exist "models\GFPGANv1.4.pth" (
    curl -L --fail -o "models\GFPGANv1.4.pth" https://github.com/TencentARC/GFPGAN/releases/download/v1.3.4/GFPGANv1.4.pth || goto :error
) else echo   GFPGANv1.4.pth ya existe

echo.
echo [6/6] Descargando ffmpeg...
if not exist "ffmpeg_bin\bin\ffmpeg.exe" (
    curl -L --fail -o "%TEMP%\ffmpeg.zip" https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip || goto :error
    if exist "%TEMP%\ffmpeg_x" rmdir /s /q "%TEMP%\ffmpeg_x"
    mkdir "%TEMP%\ffmpeg_x"
    tar -xf "%TEMP%\ffmpeg.zip" -C "%TEMP%\ffmpeg_x" || goto :error
    for /d %%D in ("%TEMP%\ffmpeg_x\ffmpeg-*") do xcopy /e /i /q /y "%%D" "ffmpeg_bin" >nul
    rmdir /s /q "%TEMP%\ffmpeg_x"
    del "%TEMP%\ffmpeg.zip"
) else echo   ffmpeg ya existe

echo.
echo Verificando GPU...
"%PY%" -c "import torch, onnxruntime as o; print('  torch CUDA:', torch.cuda.is_available(), torch.cuda.get_device_name(0) if torch.cuda.is_available() else ''); print('  onnxruntime:', o.get_available_providers())"

echo.
echo ============================================================
echo  Instalacion completa. Ejecuta start-gpu.bat para iniciar.
echo  (El modelo buffalo_l se descarga solo la primera vez.)
echo ============================================================
pause
exit /b 0

:error
echo.
echo ERROR: la instalacion fallo en el paso anterior. Revisa el mensaje de arriba.
pause
exit /b 1
