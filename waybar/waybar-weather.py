import requests
import json
import time
import os

API_KEY: str = "2b06ff244e67b88dda17ae1e872998de" # openweatherap.org API
LAT: float = 50.62925 # Latitude
LON: float = 3.057256 # Longitude
UNITS: str = "metric" # standard | metric |imperial
COUNT: int = 4 # Get only n next hours
REQ_URL: str = f"https://api.openweathermap.org/data/2.5/forecast?lat={LAT}&lon={LON}&appid={API_KEY}&units={UNITS}&cnt={COUNT}"


def classify_entries(req: dict) -> dict:
    toreturn = {}
    for entry in req["list"]:
        toreturn[entry["dt"]] = entry
    
    return toreturn
    
def main():
    # Get request and entries
    req = requests.get(REQ_URL)
    if not req.ok:
        return {"text": "API error! Debug it... I plead..."}
    
    content = json.loads(req.content)
    weather_report = classify_entries(req=content)
    
    # Advance 1 entry if next entry timestamp difference with current time is less than 15 minutes
    current_time = int(time.time())
    next_timestamp = weather_report[list(weather_report.keys())[1]]["dt"] 
    if next_timestamp - current_time <= 900:
        weather_report.pop(0)
    
    # Generate text
    entry_keys = list(weather_report.keys())
    icons = {"Rain": "", "Clouds" : "", "Snow": "", "Clear": ""}
    text = ""
    for idx in range(3):
        current_entry = weather_report[entry_keys[idx]]
        weather = current_entry["weather"][0]["main"]
        temp = int(current_entry["main"]["temp"])

        text += f"{icons[weather]} {temp}ºC"
    
    return text
        

if __name__ == "__main__":
    try:
        weather = main()
    except Exception as e:
        weather = "Exception! Debug... I plead..."
    print(weather)