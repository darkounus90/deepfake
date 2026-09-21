# Setup local (Windows 11 + RTX 5070)

Instalación funcionando en `C:\dev\iRoopDeepFaceCam`.

## Instalar en otro PC

Requisitos: Windows 10/11, GPU NVIDIA con driver reciente, git y ~15 GB libres.

```
git clone https://github.com/darkounus90/deepfake.git
cd deepfake
install.bat
```

`install.bat` instala Python 3.10 si falta (winget), crea `.venv`, instala
`requirements-local-cu128.txt` (PyTorch cu128 + el wheel precompilado de insightface
en `wheels/`, así que no hace falta Visual Studio), aplica el parche de basicsr y
descarga los modelos y ffmpeg. Después, `start-gpu.bat`.

## Arranque

- `start-gpu.bat` -> CUDA, 5 hilos (recomendado)
- `start-cpu.bat` -> sin GPU

Ambos activan `.venv` y añaden `ffmpeg_bin\bin` al PATH antes de lanzar `run.py`.

## Diferencias respecto a `requirements.txt` del repo

La RTX 5070 es Blackwell (sm_120) y **no la soporta CUDA 11.8**, que es lo que
pide el `requirements.txt` original. Versiones realmente instaladas:

| Paquete | Repo | Instalado | Motivo |
|---|---|---|---|
| torch / torchvision | 2.0.1+cu118 / 0.15.2 | 2.7.1+cu128 / 0.22.1+cu128 | sm_120 necesita CUDA 12.8 |
| onnxruntime-gpu | 1.18.0 | 1.22.0 | build contra CUDA 12 + cuDNN 9 |
| tensorflow | 2.12.1 | 2.15.1 | 2.12 fija `typing-extensions<4.6` y rompe torch 2.7 |
| numpy | 1.23.5 | 1.26.4 | punto común entre insightface, TF 2.15 y opencv 4.8 |
| pillow | 9.5.0 | 12.3.0 | scikit-image (dep de insightface) pide >=10.1; el código solo usa `Image.LANCZOS`, que sigue existiendo |

Congelado exacto en `requirements-local-cu128.txt`.

## Parches aplicados

1. `.venv/Lib/site-packages/basicsr/data/degradations.py` linea 8:
   `torchvision.transforms.functional_tensor` -> `torchvision.transforms.functional`
   (el submódulo se eliminó en torchvision 0.17). **Se pierde si reinstalas basicsr.**
2. `insightface==0.7.3` no trae wheel y setuptools no detectaba el compilador. Hubo que
   compilar desde un entorno MSVC inicializado:

   ```
   call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
   set DISTUTILS_USE_SDK=1
   set MSSdk=1
   .venv\Scripts\python.exe -m pip install insightface==0.7.3
   ```

## Notas

- `pip check` avisa de `albumentations/albucore requires opencv-python-headless`.
  Es cosmético: `cv2` lo aporta `opencv-python`. No instales el headless, pisa el otro.
- Modelos en `models/`: `GFPGANv1.4.pth` (348 MB), `inswapper_128_fp16.onnx` (265 MB).
- `buffalo_l` (detección) vive en `C:\Users\PC\.insightface\models\`.
- Los pesos de facexlib se autodescargaron a `gfpgan/weights/` en el primer uso.
