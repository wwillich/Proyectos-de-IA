# Proyecto: Identificador de Vehículos con Transfer Learning

## Resumen del Proyecto
Este proyecto desarrolla un sistema de **Visión por Computadora** para la clasificación de vehículos en imágenes. Se utilizó la arquitectura **Xception** a través de Transfer Learning y un pipeline implementado en Python, ejecutado desde R mediante la librería `reticulate`. El objetivo fue construir un detector de vehículos funcional, ajustando librerías (usando Keras3)  y aplicando técnicas avanzadas de optimización para el entrenamiento.

## Stack Tecnológico

| Componente | Herramientas/Librerías | Descripción |
| :--- | :--- | :--- |
| **Modelo Base** | Xception | Utilizado mediante Transfer Learning, con pesos congelados y entrenado con ImageNet. |
| **Frameworks** | Keras3, TensorFlow | Librerías principales para la construcción y entrenamiento del modelo, elegidas para resolver problemas de compatibilidad. |
| **Lenguajes** | R, Python | El pipeline de entrenamiento y deployment fue ejecutado desde R usando Python a través de `reticulate`. |
| **Deployment** | Shiny | Utilizado para montar la interfaz gráfica del clasificador (`app.R`). |

## Procesamiento y Entrenamiento
El conjunto de datos utilizado fue “Vehicle Image Classification” (Kaggle), complementado con imágenes de camiones para ampliar el reconocimiento.

### 1. Preprocesamiento y Aumento de Datos
* **Aumento de Datos (*Data Augmentation*):** Se aplicaron volteos horizontales aleatorios y rotaciones leves (hasta el 10% del rango total). Esto expandió artificialmente el dataset, mejorando la robustez.
* **Normalización:** Los valores de píxeles se reescalaron de $[0, 255]$ a $[0.0, 1.0]$ dividiendo por 255.
* **Prefetching:** Se implementó para optimizar la entrada de datos, cargando lotes de imágenes de forma asíncrona.

### 2. Optimización y Control de Entrenamiento (Callbacks)
Para maximizar la eficiencia en 4 épocas  y evitar el sobreajuste (*overfitting*), se definieron dos mecanismos de control:

* **Early Stopping:** Monitoreando la Pérdida de Validación (`val_loss`). Se estableció una `patience = 3` y se usó `restore_best_weights = TRUE` para asegurar que el modelo final fuese la mejor versión encontrada (la de menor `val_loss`).
* **Reduce Learning Rate On Plateau:** Si el rendimiento no mejora durante dos épocas (`patience = 2`), la **Tasa de Aprendizaje** se reduce automáticamente al 50%. Esto permite que el optimizador encuentre el mínimo error con mayor estabilidad y precisión.

### 📊 Resultados del Modelo
* **Métrica de Error:** Entropía Cruzada Categórica (`Categorical Crossentropy`).
* **Optimizador:** Adam.
* **Métrica de Rendimiento:** Exactitud (`Accuracy`).

El entrenamiento se detuvo en la Época 4 por las condiciones de *Early Stopping*.

| Métrica | Conjunto de Entrenamiento (Época 4) | Conjunto de Validación (Época 3 - Mejor Peso) |
| :--- | :--- | :--- |
| **Exactitud (Accuracy)** | 99% (Máximo en la Época 4) | ~98.5% (Máximo en la Época 3)  |
| **Pérdida (Cross-Entropy)** | ~0.04 (Mínimo en la Época 4) | ~0.06 (Mínimo en la Época 3)  |

##Aprendizajes Clave
Este proyecto fue fundamental para comprender y aplicar estrategias avanzadas de entrenamiento y manejo de dependencias.
* **Gestión de Dependencias y Compatibilidad:** Se resolvió la incompatibilidad entre la versión de R y las librerías Keras/TensorFlow al investigar y optar por **Keras3**.
* **Optimización del Entrenamiento:** El uso de **Early Stopping** y **Reduce Learning Rate On Plateau** permitió ajustar de manera óptima y robusta la cantidad de épocas, ahorrando tiempo y evitando el sobreajuste (*overfitting*).
