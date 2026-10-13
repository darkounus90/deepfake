@echo off
REM Script antiguo del proyecto original (CUDA 11.8, no sirve con RTX serie 5000).
REM Se mantiene solo para no romper accesos directos: redirige a start-gpu.bat.
echo Este script es antiguo. Usando start-gpu.bat (GPU)...
call "%~dp0start-gpu.bat" %*
