#!/usr/bin/env python3
"""Script to get the weather data and display it as JSON for a Waybar module."""

import json
import sys
import threading
import time
from typing import List

import requests
from requests.exceptions import SSLError

# Constants
WTTR_API_URL = "https://wttr.in/Guatemala?format=j1"
OPEN_METEO_API_URL = "https://api.open-meteo.com/v1/forecast?latitude=14.6349&longitude=-90.5069&current_weather=true&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=America/Guatemala"
TIMEOUT = 30
CHECK_INTERVAL = 15  # Seconds between checks
MAX_WAIT_TIME = 180  # Maximum time to wait for an internet connection (in seconds)

WEATHER_CODES = {
    "113": "☀️", "116": "⛅️", "119": "☁️", "122": "☁️", "143": "🌫",
    "176": "🌦", "179": "🌧", "182": "🌧", "185": "🌧", "200": "⛈",
    "227": "🌨", "230": "❄️", "248": "🌫", "260": "🌫", "263": "🌦",
    "266": "🌦", "281": "🌧", "284": "🌧", "293": "🌦", "296": "🌦",
    "299": "🌧", "302": "🌧", "305": "🌧", "308": "🌧", "311": "🌧",
    "314": "🌧", "317": "🌧", "320": "🌨", "323": "🌨", "326": "🌨",
    "329": "❄️", "332": "❄️", "335": "❄️", "338": "❄️", "350": "🌧",
    "353": "🌦", "356": "🌧", "359": "🌧", "362": "🌧", "365": "🌧",
    "368": "🌨", "371": "❄️", "374": "🌧", "377": "🌧", "386": "⛈",
    "389": "🌩", "392": "⛈", "395": "❄️"
}


def check_internet_connection():
    """Checks for an Internet connection."""
    try:
        requests.get("https://www.google.com", timeout=5)
        return True
    except requests.RequestException:
        return False


def wait_for_internet_connection():
    """Waits for an Internet connection with animated feedback."""
    elapsed_time = 0
    stop_event = threading.Event()
    spinner_thread = threading.Thread(
        target=spinner_animation,
        args=(stop_event, " ", "Waiting for Internet connection ⏳", True)
    )
    spinner_thread.start()

    try:
        while elapsed_time < MAX_WAIT_TIME:
            if check_internet_connection():
                stop_event.set()
                spinner_thread.join()
                return True
            time.sleep(CHECK_INTERVAL)
            elapsed_time += CHECK_INTERVAL
    finally:
        stop_event.set()
        spinner_thread.join()

    return False


def spinner_animation(stop_event: threading.Event, label: str = "Loading...", tooltip: str = "", alternate: bool = False,
                      interval: float = 0.2):
    """Displays a spinner animation with JSON output, stopping when the event is set.

    Args:
        stop_event (threading.Event): Event to signal when to stop animation.
        label (str): Message to show next to spinner.
        tooltip (str): Message to show as the tooltip.
        alternate (bool): Whether to use the alternate spinner style.
        interval (float): Time between frames.
    """
    default_spinner: List[str] = ["🕐", "🕑", "🕒", "🕓", "🕔",
                                  "🕕", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕛"]
    alternate_spinner: List[str] = ["▁", "▃", "▄",
                                    "▅", "▆", "▇", "█", "▆", "▅", "▄", "▃"]

    spinner_frames: List[str] = alternate_spinner if alternate else default_spinner

    i: int = 0
    while not stop_event.is_set():
        frame = spinner_frames[i % len(spinner_frames)]
        print(json.dumps({
            "text": f"{frame} {label}",
            "tooltip": tooltip
        }))
        sys.stdout.flush()
        time.sleep(interval)
        i += 1


def fetch_weather():
    """Fetches the weather data from wttr.in, falls back to Open-Meteo if it fails."""
    try:
        response = requests.get(WTTR_API_URL, timeout=TIMEOUT)
        response.raise_for_status()
        return response.json()
    except (SSLError, requests.RequestException):
        return fetch_weather_open_meteo()


def fetch_weather_open_meteo():
    """Fetches the weather data from Open-Meteo as a fallback."""
    try:
        response = requests.get(OPEN_METEO_API_URL, timeout=TIMEOUT)
        response.raise_for_status()
        weather_data = response.json()
        return format_open_meteo(weather_data)
    except requests.RequestException as e:
        return {"error": f"Open-Meteo error: {str(e)}"}


def format_open_meteo(data):
    """Formats Open-Meteo data to match the wttr.in structure."""
    current = data["current_weather"]
    daily = data["daily"]

    weather_data = {
        "current_condition": [{
            "temp_C": str(current["temperature"]),
            # Open-Meteo lacks "feels like" temp
            "FeelsLikeC": str(current["temperature"]),
            "windspeedKmph": str(current["windspeed"]),
            "humidity": "N/A",  # Open-Meteo does not provide humidity in the free tier
            "weatherCode": "113",  # Assume clear weather if no specific condition is given
            "weatherDesc": [{"value": "Clear"}]
        }],
        "weather": [{
            "date": daily["time"][0],
            "maxtempC": str(daily["temperature_2m_max"][0]),
            "mintempC": str(daily["temperature_2m_min"][0]),
            "astronomy": [{
                "sunrise": daily["sunrise"][0].split("T")[1],
                "sunset": daily["sunset"][0].split("T")[1]
            }],
            "hourly": []
        }]
    }
    return weather_data


def generate_tooltip(weather_data):
    """Generates the module tooltip."""
    current = weather_data["current_condition"][0]
    tooltip = [
        f"<b>{current["weatherDesc"][0]["value"]} {current["temp_C"]}°</b>",
        f"Feels like: {current["FeelsLikeC"]}°",
        f"Wind: {current["windspeedKmph"]}Km/h",
        f"Humidity: {current.get("humidity", "N/A")}%",
    ]

    for i, day in enumerate(weather_data["weather"]):
        date_label = "Today" if i == 0 else "Tomorrow" if i == 1 else day["date"]
        tooltip.append(f"\n<b>{date_label}</b>")
        tooltip.append(f"⬆️ {day["maxtempC"]}° ⬇️ {day["mintempC"]}°")
        tooltip.append(
            f"{day["astronomy"][0]["sunrise"]} ☀️ {day["astronomy"][0]["sunset"]} 🌙")

    return "\n".join(tooltip)


def display_loading_icon(stop_event):
    """Displays a loading animation until stopped."""
    spinner_animation(stop_event, " ", "Fetching weather data ⏳")


def main():
    """Main loop."""
    # Display animated loading icon
    loading_stop_event = threading.Event()
    loading_thread = threading.Thread(
        target=display_loading_icon,
        args=(loading_stop_event,)
    )
    loading_thread.start()

    if not wait_for_internet_connection():
        loading_stop_event.set()
        loading_thread.join()
        print(json.dumps({"text": "󰖪",
                          "tooltip": "<b>No Internet connection available.</b>\nPlease reconnect to get the weather data."}))
        sys.stdout.flush()
        return

    weather_data = fetch_weather()

    loading_stop_event.set()
    loading_thread.join()

    if "error" in weather_data:
        output = {"text": "❌ Error", "tooltip": weather_data["error"]}
    else:
        current = weather_data["current_condition"][0]
        weather_icon = WEATHER_CODES.get(
            current.get("weatherCode", "113"), "❓")
        weather_text = f"{weather_icon} {current["FeelsLikeC"]}°"
        output = {
            "text": weather_text,
            "tooltip": generate_tooltip(weather_data)
        }

    print(json.dumps(output))


if __name__ == "__main__":
    main()
