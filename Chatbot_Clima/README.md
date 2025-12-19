# Chatbot del Clima - Python & Flet

## Resumen del Proyecto
Este proyecto consiste en un chatbot conversacional desarrollado en **Python** utilizando el framework **Flet**. El bot permite a los usuarios consultar el estado del tiempo en tiempo real para cualquier ciudad del mundo. La solución destaca por su interfaz gráfica moderna y una lógica de procesamiento de lenguaje natural (PLN) basada en reglas que permite una interacción fluida sin necesidad de comandos rígidos.

## Stack Tecnológico

| Componente | Herramientas/Librerías | Descripción |
| :--- | :--- | :--- |
| **Lenguaje** | Python | Lógica principal del chatbot y procesamiento de datos. |
| **Interfaz (UI)** | Flet | Framework basado en Flutter para crear interfaces de usuario multiplataforma. |
| **API Externa** | OpenWeather API | Consumo de datos meteorológicos globales en tiempo real. |
| **Concurrencia** | Threading | Uso de hilos para gestionar la respuesta del bot sin bloquear la interfaz. |

## Características Principales

### 1. Interacción Natural (NLP Básico)
El chatbot no requiere comandos específicos (como `/clima`). En su lugar, analiza el mensaje del usuario buscando:
* **Intención:** Identifica palabras clave como "clima", "temperatura", "tiempo" o "lluvia".
* **Extracción de Entidad (Ciudad):** Utiliza "gatillos" gramaticales (ej. "en", "de") para extraer el nombre de la ubicación mencionada por el usuario (ej. "¿Cómo está el clima **en** Rosario?").

### 2. Experiencia de Usuario (UX/UI)
* **Interfaz Dinámica:** Diseño con tema oscuro, burbujas de chat diferenciadas por colores y sistema de `auto_scroll` para mantener siempre a la vista el último mensaje.
* **Simulación Humana:** Para evitar una respuesta instantánea y robótica, el bot incluye un indicador de **"Escribiendo..."** y un retardo programado de 0.6 segundos, mejorando la percepción de flujo conversacional.

### 3. Integración de Datos Reales
A través de la librería `requests`, el sistema se conecta a **OpenWeather** para obtener y mostrar:
* Temperatura actual y sensación térmica.
* Descripción del cielo (despejado, nublado, etc.).
* Velocidad del viento.

## Funcionamiento Técnico
El flujo de la aplicación sigue estos pasos:
1. **Captura de Input:** El usuario envía un texto libre.
2. **Procesamiento:** Se limpia el texto (minúsculas y eliminación de espacios) y se busca la intención y la ciudad.
3. **Consulta API:** Si se detecta una ciudad, se realiza una petición HTTP asíncrona.
4. **Respuesta:** El bot responde con un saludo aleatorio (para variar la interacción) y la ficha técnica del clima, o solicita aclaración si no entendió la consulta.

## 🚀 Cómo ejecutarlo
1. Clona este repositorio.
2. Instala las dependencias: `pip install flet requests`.
3. Asegúrate de tener una API Key válida de [OpenWeather](https://openweathermap.org/api).
4. Ejecuta la aplicación: `python chatbot_clima.py`.
