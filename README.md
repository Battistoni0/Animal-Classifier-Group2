# Clasificador de Animales

Este es un proyecto de Flutter que utiliza TensorFlow Lite para clasificar imágenes de animales.

## Instalación de Flutter

Para comenzar a trabajar con este proyecto, sigue los siguientes pasos para instalar Flutter en tu sistema:

1. **Descargar Flutter:** Visita la [página oficial de Flutter](https://flutter.dev/docs/get-started/install) y sigue las instrucciones de instalación según tu sistema operativo (Windows, macOS, Linux).

2. **Configuración del Entorno:** Después de instalar Flutter, asegúrate de configurar correctamente tu entorno de desarrollo siguiendo las [instrucciones de la documentación oficial](https://flutter.dev/docs/get-started/editor).

## Compilar el Código

Antes de ejecutar el código, asegúrate de tener todos los paquetes y dependencias necesarios instalados. Abre una terminal en la raíz del proyecto y ejecuta el siguiente comando para instalar las dependencias:

```bash
flutter pub get
```
## Modificar el Modelo

Si deseas cambiar el modelo a utilizar tienes que cambiar los archivos de de assets, tanto el modelo.tflite, como el labels.txt y luego modificar sus menciones en el main.dart