"""Script to get the weather data and display it as JSON for a Waybar module."""

import json
import sys
import threading
import time
from datetime import datetime

import requests
from requests.exceptions import SSLError

# Constants
WEATHER_API_URL = "https://wttr.in/Guatemala?format=j1"
TIMEOUT = 30
CHECK_INTERVAL = 15  # Seconds between checks
# Maximum time to wait for an internet connection (in seconds)
MAX_WAIT_TIME = 180

WEATHER_CODES = {
    '113': '☀️', '116': '⛅️', '119': '☁️', '122': '☁️', '143': '🌫',
    '176': '🌦', '179': '🌧', '182': '🌧', '185': '🌧', '200': '⛈',
    '227': '🌨', '230': '❄️', '248': '🌫', '260': '🌫', '263': '🌦',
    '266': '🌦', '281': '🌧', '284': '🌧', '293': '🌦', '296': '🌦',
    '299': '🌧', '302': '🌧', '305': '🌧', '308': '🌧', '311': '🌧',
    '314': '🌧', '317': '🌧', '320': '🌨', '323': '🌨', '326': '🌨',
    '329': '❄️', '332': '❄️', '335': '❄️', '338': '❄️', '350': '🌧',
    '353': '🌦', '356': '🌧', '359': '🌧', '362': '🌧', '365': '🌧',
    '368': '🌨', '371': '❄️', '374': '🌧', '377': '🌧', '386': '⛈',
    '389': '🌩', '392': '⛈', '395': '❄️'
}


def check_internet_connection():
    """Checks for an Internet connection."""
    try:
        requests.get("https://www.google.com", timeout=5)
        return True
    except requests.RequestException:
        return False


def wait_for_internet_connection():
    """Waits for an Internet connection to be established."""
    elapsed_time = 0
    while elapsed_time < MAX_WAIT_TIME:
        if check_internet_connection():
            return True
        print(json.dumps({"text": "⏳ waiting for Internet connection.",
              "tooltip": "Waiting for an Internet connection."}))
        sys.stdout.flush()
        time.sleep(CHECK_INTERVAL)
        elapsed_time += CHECK_INTERVAL
    return False


def fetch_weather():
    """Fetches the weather data with a manual SSL check."""
    try:
        response = requests.get(WEATHER_API_URL, timeout=TIMEOUT)
        response.raise_for_status()
        return response.json()
    except SSLError:
        print("SSL verification failed. The certificate may be expired.")
        # Optionally fall back to verify=False
        response = requests.get(WEATHER_API_URL, timeout=TIMEOUT, verify=False)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        return {"error": str(e)}


def format_time(time):
    """Formats the time."""
    return time.zfill(4)[:-2]


def format_chances(hour):
    """Formats the forecast."""
    CHANCE_LABELS = {
        "chanceoffog": "Fog", "chanceoffrost": "Frost", "chanceofovercast": "Overcast",
        "chanceofrain": "Rain", "chanceofsnow": "Snow", "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder", "chanceofwindy": "Wind"
    }
    return ", ".join(
        f"{CHANCE_LABELS[event]} {hour[event]}%"
        for event in CHANCE_LABELS if int(hour[event]) > 0
    )


def generate_tooltip(weather_data):
    """Generates the module tooltip."""
    current = weather_data['current_condition'][0]
    tooltip = [
        f"<b>{current['weatherDesc'][0]['value']} {current['temp_C']}°</b>",
        f"Feels like: {current['FeelsLikeC']}°",
        f"Wind: {current['windspeedKmph']}Km/h",
        f"Humidity: {current['humidity']}%",
    ]
    now = datetime.now().hour

    for i, day in enumerate(weather_data['weather']):
        date_label = "Today" if i == 0 else "Tomorrow" if i == 1 else day['date']
        tooltip.append(f"\n<b>{date_label}</b>")
        tooltip.append(f"⬆️ {day['maxtempC']}° ⬇️ {day['mintempC']}°")
        tooltip.append(
            f" {day['astronomy'][0]['sunrise']}  {day['astronomy'][0]['sunset']}")

        for hour in day['hourly']:
            hour_time = int(format_time(hour['time']))
            if i == 0 and hour_time < now - 2:
                continue
            tooltip.append(
                f"{format_time(hour['time'])} {WEATHER_CODES.get(hour['weatherCode'], '❓')} "
                f"{hour['FeelsLikeC']}° {hour['weatherDesc'][0]['value']}, {format_chances(hour)}"
            )

    return "\n".join(tooltip)


def display_loading_icon():
    """Display the loading icon while the weather data is loading."""
    loading_data = {"text": "⏳ Loading...",
                    "tooltip": "Fetching weather data..."}
    print(json.dumps(loading_data))
    sys.stdout.flush()


def main():
    """Main loop."""
    # Display loading icon in a separate thread
    loading_thread = threading.Thread(target=display_loading_icon)
    loading_thread.start()

    if not wait_for_internet_connection():
        print(json.dumps({"text": "❌ no internet",
              "tooltip": "no internet connection available."}))
        sys.stdout.flush()
        return

    # Fetch and display weather data in the main thread
    weather_data = fetch_weather()

    if 'error' in weather_data:
        output = {"text": "❌ Error", "tooltip": weather_data['error']}
    else:
        current = weather_data['current_condition'][0]
        weather_icon = WEATHER_CODES.get(current['weatherCode'], '❓')
        weather_text = f"{weather_icon} {current['FeelsLikeC']}°"
        output = {
            "text": weather_text,
            "tooltip": generate_tooltip(weather_data)
        }

    print(json.dumps(output))


if __name__ == "__main__":
    main()
