import requests
import json

url = "http://localhost:8000/chat"
payload = {"message": "I have a query doing a full table scan on 1 million rows. Is it slow?"}
headers = {"Content-Type": "application/json"}

try:
    print(f"Sending request to {url}...")
    response = requests.post(url, json=payload, headers=headers)
    print(f"Status Code: {response.status_code}")
    print("Response JSON:")
    print(json.dumps(response.json(), indent=2))
except Exception as e:
    print(f"Error: {e}")
