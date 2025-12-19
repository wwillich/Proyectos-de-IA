# Generador de Etiquetas con WGAN-GP (Vino, Cerveza y Café)

## Resumen del Proyecto
Este proyecto consiste en el desarrollo y experimentación con una **Red Generativa Antagónica (GAN)** diseñada para crear imágenes sintéticas de etiquetas de productos (vino, cerveza y café). Se implementó una arquitectura avanzada **WGAN-GP** en **PyTorch**, enfocándose en la estabilidad del entrenamiento y la calidad de la generación de imágenes desde cero.

## Stack Tecnológico

| Componente | Herramientas/Librerías | Descripción |
| :--- | :--- | :--- |
| **Framework** | PyTorch | Implementación de redes neuronales profundas y gestión de tensores. |
| **Arquitectura** | WGAN-GP | Wasserstein GAN con Penalización de Gradiente para mayor estabilidad. |
| **Procesamiento** | Torchvision | Transformaciones de imágenes, normalización y aumento de datos. |
| **NLP (Módulo)** | Sentence-Transformers | Intento de mapeo de texto a espacio latente (Text-to-Image). |
| **Entorno** | Google Colab (GPU T4). Tambien se entreno de manera local, en mi PC | Entrenamiento acelerado por hardware. |

## Detalles de la Implementación Técnica

### 1. Arquitectura del Modelo
El sistema se compone de dos redes compitiendo entre sí:
* **Generador:** Utiliza capas de **Convolución Transpuesta 2D** para realizar *upsampling* desde un vector de ruido latente hasta una imagen de $64 \times 64$ píxeles.
* **Crítico (Discriminador):** Utiliza capas de **Convolución 2D** profundas para evaluar la "realidad" de las imágenes. A diferencia de una GAN clásica, el Crítico no clasifica (0 o 1), sino que puntúa la cercanía de la imagen a la distribución real.

### 2. Estabilidad y Función de Pérdida (WGAN-GP)
Para resolver los problemas comunes de las GANs (como el *mode collapse* o gradientes desvanecidos), se aplicaron las siguientes técnicas:
* **Distancia de Wasserstein:** Proporciona un gradiente más suave y significativo para el generador.
* **Gradient Penalty (GP):** Implementa una penalización sobre la norma del gradiente del crítico para cumplir con la condición de Lipschitz, reemplazando el tradicional *weight clipping*.

### 3. Dataset y Preprocesamiento
Se integraron tres fuentes de datos distintas:
* **Vino:** Dataset `winelabels` de Hugging Face.
* **Cerveza:** `Beer Bottle Image Dataset`.
* **Café:** `Coffee Packaging Dataset` (Roboflow).
Las imágenes fueron estandarizadas mediante redimensionamiento, recorte central y normalización al rango $[-1, 1]$.

## Desafíos y Lecciones Aprendidas
Como parte de un proceso de aprendizaje académico, se identificaron áreas de mejora clave:
* **Capacidad Computacional:** Debido a las limitaciones de la GPU gratuita, se completaron 111 épocas de las 400 planificadas. Esto permite observar el inicio de la formación de estructuras en las etiquetas, aunque la nitidez final requiere más tiempo de cómputo.
* **Integración de Lenguaje Natural:** Se experimentó con un módulo de `Sentence-Transformers` para convertir texto en espacio latente. Si bien la arquitectura está planteada, el modelo de lenguaje requiere un entrenamiento de alineación más profundo para que las solicitudes afecten directamente la estética de la etiqueta generada.

## Resultados Visuales
El modelo logró pasar de ruido aleatorio a generar composiciones que respetan la paleta cromática y la estructura básica de una etiqueta comercial, demostrando que el gradiente del Crítico guio efectivamente al Generador.
