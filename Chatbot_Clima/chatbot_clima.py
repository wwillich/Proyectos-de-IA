import flet
from flet import (
    Page, TextField, ElevatedButton, Column, Text, Container,
    alignment, Colors, border_radius, padding
)
import requests
import time
import threading
import random


def main(page: Page):
    page.title = "Chatbot del Clima"
    page.bgcolor = Colors.BLUE_GREY_900
    page.theme_mode = "dark"
    page.scroll = "auto"
    page.vertical_alignment = "start"

    # ========================================================
    # FUNCIONES DE INTERFAZ -> Burbujas del chat
    # ========================================================
    def user_bubble(msg):
        return Container(
            content=Text(msg, color=Colors.WHITE),
            bgcolor="#1565C0",
            padding=10,
            margin=5,
            width=300,
            border_radius=border_radius.all(12),
            alignment=alignment.center_right
        )

    def bot_bubble(msg):
        return Container(
            content=Text(msg, color=Colors.WHITE),
            bgcolor="#424242",
            padding=10,
            margin=5,
            width=300,
            border_radius=border_radius.all(12),
            alignment=alignment.center_left
        )

    typing_indicator = Text("🤖 Escribiendo...", visible=False)

    chat_area = Column(auto_scroll=True)
    chat_area.controls.append(typing_indicator)

    # ========================================================
    # API DEL CLIMA
    # ========================================================
    def get_weather(city):
        api_key = "3e0a4bdc8985cb158b77c90782afcc6a"  # tu API
        url = (
            f"http://api.openweathermap.org/data/2.5/weather?"
            f"q={city}&appid={api_key}&units=metric&lang=es"
        )

        res = requests.get(url)
        data = res.json()

        if data.get("cod") != 200:
            return f"No pude encontrar el clima para '{city}'. ¿Probaste escribirlo sin errores?"

        temp = data["main"]["temp"]
        feels = data["main"]["feels_like"]
        wind_speed = data["wind"]["speed"]
        desc = data["weather"][0]["description"]

        respuestas = [
            f"En {city.title()} hace {temp}°C, sensación de {feels}°C y el clima está {desc}. Viento: {wind_speed} m/s.",
            f"Actualmente {city.title()} tiene {temp}°C y clima {desc}. Sensación térmica: {feels}°C.",
            f"{city.title()} presenta {desc} con {temp}°C y vientos de {wind_speed} m/s."
        ]

        return random.choice(respuestas)

    # ========================================================
    # DETECTOR DE CIUDADES EN FRASES NATURALES
    # ========================================================
    def extract_city(text):
        text = text.lower()
        gatillos = ["en ", "de ", "para ", "sobre ", "en la ", "en el "]

        for g in gatillos:
            if g in text:
                posible = text.split(g)[-1].strip()
                posible = posible.replace("?", "").replace(".", "")
                return posible

        return None

    # ========================================================
    # DETECTOR DE PREGUNTAS DE CLIMA
    # ========================================================
    def is_weather_question(text):
        palabras = [
            "clima", "tiempo", "temperatura", "lluvia",
            "va a llover", "hace frío", "hace calor", "cómo está"
        ]
        text = text.lower()
        return any(p in text for p in palabras)

    # ========================================================
    # LÓGICA CENTRAL DEL CHATBOT
    # ========================================================
    def process_message(user_message):
        msg = user_message.lower()

        # Saludos
        if any(x in msg for x in ["hola", "buenas", "qué tal", "hey", "holis"]):
            return "¡Hola! Decime de qué ciudad querés saber el clima 😊"

        # Pregunta climática
        if is_weather_question(msg):
            city = extract_city(msg)
            if city:
                return get_weather(city)
            else:
                return "¿De qué ciudad querés saber el clima?"

        # Caso no reconocido
        return "Puedo darte el clima actual. Por ejemplo: '¿Qué temperatura hace en Rosario?'"

    # ========================================================
    # FUNCIÓN DE ENVÍO DE MENSAJES
    # ========================================================
    def send_message(e):
        user_message = input_box.value.strip()
        if not user_message:
            return

        # Mostrar mensaje del usuario
        chat_area.controls.insert(-1, user_bubble(user_message))
        input_box.value = ""
        page.update()

        # Mostrar "escribiendo..."
        typing_indicator.visible = True
        page.update()

        # Procesamiento en hilo separado
        def bot_reply():
            time.sleep(0.6)
            response = process_message(user_message)
            typing_indicator.visible = False
            chat_area.controls.insert(-1, bot_bubble(response))
            page.update()

        threading.Thread(target=bot_reply).start()

    # ========================================================
    # COMPONENTES DE INPUT
    # ========================================================
    input_box = TextField(
        label="Escribe tu mensaje",
        border_color=Colors.BLUE_200,
        focused_border_color=Colors.BLUE_400,
        text_style=flet.TextStyle(color=Colors.WHITE),
        expand=True
    )

    send_button = ElevatedButton(
        text="Enviar",
        on_click=send_message,
        bgcolor=Colors.BLUE_700,
        color=Colors.WHITE
    )

    page.add(
        chat_area,
        Container(
            content=Column([input_box, send_button]),
            padding=padding.all(10)
        )
    )


flet.app(target=main)