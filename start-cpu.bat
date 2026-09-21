@echo off
REM iRoopDeepFaceCam - CPU
cd /d "%~dp0"
set "PATH=%~dp0ffmpeg_bin\bin;%PATH%"
call ".venv\Scripts\activate.bat"
python run.py --execution-provider cpu --execution-threads 8 %*
pause
