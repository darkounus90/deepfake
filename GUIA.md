# Guía de uso

Guía rápida para instalar y usar la app. También puedes abrirla dentro de la app con el botón **Guía** o la tecla **F1**.

---

## 1. Requisitos

- Windows 10 u 11.
- Tarjeta NVIDIA con el driver al día (probado con RTX 5070). Sin NVIDIA funciona en modo CPU, pero mucho más lento.
- Git y unos 15 GB libres.

## 2. Instalación (una sola vez)

1. Descarga el proyecto:
   ```
   git clone https://github.com/darkounus90/deepfake.git
   cd deepfake
   ```
2. Ejecuta **`install.bat`**. Hace todo solo:
   - Instala Python 3.10 si no lo tienes.
   - Crea el entorno `.venv` e instala las dependencias (varios GB, tarda).
   - Descarga los modelos (`inswapper_128.onnx`, `GFPGANv1.4.pth`) y ffmpeg.
   - Al final debe mostrar `torch CUDA: True` y el nombre de tu tarjeta.
3. Si algo falla, vuelve a ejecutar `install.bat`: salta lo que ya está hecho.

> Los scripts antiguos (`run-cuda.bat`, `run-cpu.bat`, `setup_iRoopDeepFaceCam.bat`, etc.) ahora solo redirigen a `start-gpu.bat`, `start-cpu.bat` o `install.bat`.

## 3. Abrir la app

- **`start-gpu.bat`**: con la tarjeta NVIDIA (recomendado).
- **`start-cpu.bat`**: sin tarjeta gráfica.

La consola negra que se abre junto a la app muestra los mensajes técnicos; no la cierres mientras usas la app.

## 4. Uso básico

### En vivo con la webcam
1. **Seleccionar cara/s**: elige una foto con la cara que quieres poner. Si la foto tiene varias caras, se toman de izquierda a derecha (máximo 10).
2. **Cámara**: elige tu cámara en la lista de abajo.
3. Elige la resolución en el menú verde (recomendado **1280x720**).
4. Pulsa **En vivo**. La primera detección puede tardar unos segundos. Si vuelves a pulsar **En vivo**, la sesión anterior se cierra sola.
5. Puedes cambiar de cámara o de resolución con la sesión abierta.

### Con una imagen o un video
1. **Seleccionar cara/s**: la cara que quieres poner.
2. **Seleccionar destino**: la imagen o video donde se va a poner.
3. **Vista previa** para ver cómo queda, o **Iniciar** para generar el archivo final.
4. Opciones para video: *Mantener FPS*, *Mantener audio*, *Mejorar cara (Video)*.

## 5. Bloquear personas

Sirve para que la cara solo se cambie a quien tú quieres, aunque entre más gente en la imagen.

**Una persona**
1. Ponte solo frente a la cámara.
2. Activa **Bloquear personas** en la barra de la vista previa (o pulsa **L**).
3. La app se fija en tu cara. Si entra otra persona, a ella no se le cambia la cara.

**Dos personas**
1. En *Seleccionar cara/s* usa una foto con **las dos caras** de origen.
2. Activa **Usar las 2 primeras caras**.
3. Pónganse los dos frente a la cámara y activa **Bloquear personas** (o **L**).
4. La persona de la **izquierda** en ese momento recibe la primera cara (F1) y la de la derecha la segunda (F2). **Invertir** las intercambia.
5. Aunque se crucen o cambien de lado, cada uno conserva su cara. Una tercera persona no se cambia.

Si se bloqueó en la persona equivocada, pulsa **T** para reiniciar y vuelve a bloquear.

## 6. Atajos de teclado

| Tecla | Acción |
|---|---|
| **A** | Activar/desactivar seguimiento automático |
| **T** | Reiniciar seguimiento y bloqueo |
| **L** | Activar/desactivar *Bloquear personas* |
| **M** | Activar/desactivar máscara de boca |
| **1 … 0** | Máscara de boca para la cara 1 … 10 |
| **F1** | Abrir esta guía |

En la vista previa, **doble clic** oculta o muestra la barra de opciones.

## 7. Consejos para mejor calidad

- Cara **de frente**, centrada y con **buena luz**. De perfil o mirando hacia abajo el resultado empeora.
- Usa una foto de origen nítida, de frente y sin gafas de sol.
- Sube la resolución a 1280x720.
- **Mejorar cara** mejora el detalle pero baja los FPS.
- **Máscara de boca** conserva tu boca real: útil para que se vea natural al hablar.

## 8. Problemas comunes

**`No module named 'torch'`**
Abriste un script viejo. Ejecuta `install.bat` y usa `start-gpu.bat`.

**La cara sale negra o como una mancha**
Comprueba que existe `models\inswapper_128.onnx`. Si no está, ejecuta `install.bat`. Si sigue igual, prueba con `start-cpu.bat`: si en CPU sale bien, el problema es la GPU.

**`can't grab frame` / la cámara se congela**
Otra app está usando la cámara (OBS, navegador, Discord) o se cortó Camo con el celular. La app intenta **reconectar sola** y lo indica abajo («Cámara sin imagen, reconectando...»). Cierra las otras apps o revisa Camo y se recupera sin reiniciar.

**La imagen aparece girada de repente**
Desactiva **Auto** junto a *Rotación* (viene apagado por defecto). Solo es útil si la cámara está de lado o al revés.

**No reconoce mi cara con *Bloquear personas***
Ponte de frente con buena luz y pulsa **T** para volver a bloquear.

**La ventana no cabe en la pantalla**
La ventana principal tiene barra de desplazamiento: usa la rueda del ratón.

## 9. Uso responsable

Usa la app solo con tu propia cara o con la de personas que hayan dado su permiso. No la uses para engañar, suplantar a alguien ni crear contenido sin consentimiento: además de dañar a otros, puede ser un delito.
