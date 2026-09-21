@echo off
REM iRoopDeepFaceCam - GPU (CUDA 12.8 / RTX 5070)
cd /d "%~dp0"
set "PATH=%~dp0ffmpeg_bin\bin;%PATH%"
call ".venv\Scripts\activate.bat"
python run.py --execution-provider cuda --execution-threads 5 %*
pause
