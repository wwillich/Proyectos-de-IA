# 🚗 Proyecto: Identificador de Vehículos con Transfer Learning

##Resumen del Proyecto
[cite_start]Este proyecto desarrolla un sistema de **Visión por Computadora** para la clasificación de vehículos en imágenes[cite: 115]. [cite_start]Se utilizó la arquitectura **Xception** a través de Transfer Learning [cite: 133, 134] [cite_start]y un pipeline implementado en Python, ejecutado desde R mediante la librería `reticulate`[cite: 116]. [cite_start]El objetivo fue construir un detector de vehículos funcional, ajustando librerías (usando Keras3) [cite: 153] [cite_start]y aplicando técnicas avanzadas de optimización para el entrenamiento[cite: 141, 145].

##Stack Tecnológico

| Componente | Herramientas/Librerías | Descripción |
| :--- | :--- | :--- |
| **Modelo Base** | Xception | [cite_start]Utilizado mediante Transfer Learning, con pesos congelados y entrenado con ImageNet[cite: 133, 134]. |
| **Frameworks** | Keras3, TensorFlow | [cite_start]Librerías principales para la construcción y entrenamiento del modelo, elegidas para resolver problemas de compatibilidad[cite: 153]. |
| **Lenguajes** | R, Python | [cite_start]El pipeline de entrenamiento y deployment fue ejecutado desde R usando Python a través de `reticulate`[cite: 116, 121]. |
| **Deployment** | Shiny | [cite_start]Utilizado para montar la interfaz gráfica del clasificador (`app.R`)[cite: 116]. |

##Procesamiento y Entrenamiento
[cite_start]El conjunto de datos utilizado fue “Vehicle Image Classification” (Kaggle), complementado con imágenes de camiones para ampliar el reconocimiento[cite: 124, 125].

### 1. Preprocesamiento y Aumento de Datos
* [cite_start]**Aumento de Datos (*Data Augmentation*):** Se aplicaron volteos horizontales aleatorios y rotaciones leves (hasta el 10% del rango total)[cite: 127]. [cite_start]Esto expandió artificialmente el dataset, mejorando la robustez[cite: 128].
* [cite_start]**Normalización:** Los valores de píxeles se reescalaron de $[0, 255]$ a $[0.0, 1.0]$ dividiendo por 255[cite: 129, 130].
* [cite_start]**Prefetching:** Se implementó para optimizar la entrada de datos, cargando lotes de imágenes de forma asíncrona[cite: 131].

### 2. Optimización y Control de Entrenamiento (Callbacks)
[cite_start]Para maximizar la eficiencia en 4 épocas [cite: 150] y evitar el sobreajuste (*overfitting*), se definieron dos mecanismos de control:

* [cite_start]**Early Stopping:** Monitoreando la Pérdida de Validación (`val_loss`)[cite: 142]. [cite_start]Se estableció una `patience = 3` y se usó `restore_best_weights = TRUE` para asegurar que el modelo final fuese la mejor versión encontrada (la de menor `val_loss`)[cite: 143, 144].
* [cite_start]**Reduce Learning Rate On Plateau:** Si el rendimiento no mejora durante dos épocas (`patience = 2`), la **Tasa de Aprendizaje** se reduce automáticamente al 50%[cite: 147, 148]. [cite_start]Esto permite que el optimizador encuentre el mínimo error con mayor estabilidad y precisión[cite: 149].

### 📊 Resultados del Modelo
* [cite_start]**Métrica de Error:** Entropía Cruzada Categórica (`Categorical Crossentropy`)[cite: 136].
* [cite_start]**Optimizador:** Adam[cite: 138].
* [cite_start]**Métrica de Rendimiento:** Exactitud (`Accuracy`)[cite: 140].

El entrenamiento se detuvo en la Época 4 por las condiciones de *Early Stopping*.

| Métrica | Conjunto de Entrenamiento (Época 4) | Conjunto de Validación (Época 3 - Mejor Peso) |
| :--- | :--- | :--- |
| **Exactitud (Accuracy)** | 99% (Máximo en la Época 4) | [cite_start]~98.5% (Máximo en la Época 3) [cite: 150] |
| **Pérdida (Cross-Entropy)** | ~0.04 (Mínimo en la Época 4) | [cite_start]~0.06 (Mínimo en la Época 3) [cite: 150] |

##Aprendizajes Clave
[cite_start]Este proyecto fue fundamental para comprender y aplicar estrategias avanzadas de entrenamiento y manejo de dependencias[cite: 155].
* [cite_start]**Gestión de Dependencias y Compatibilidad:** Se resolvió la incompatibilidad entre la versión de R y las librerías Keras/TensorFlow al investigar y optar por **Keras3**[cite: 153].
* [cite_start]**Optimización del Entrenamiento:** El uso de **Early Stopping** y **Reduce Learning Rate On Plateau** permitió ajustar de manera óptima y robusta la cantidad de épocas, ahorrando tiempo y evitando el sobreajuste (*overfitting*)[cite: 156].

---

**[Enlace a la carpeta del script de entrenamiento]**
**[Enlace a la carpeta de la aplicación Shiny (Deployment)]**
