import os
import requests

TELEGRAM_TOKEN = os.getenv('TELEGRAM_TOKEN')
TELEGRAM_CHAT_ID = os.getenv('TELEGRAM_CHAT_ID')
TELEGRAM_THREAD_ID = os.getenv('TELEGRAM_THREAD_ID')
MESSAGE = os.getenv('MESSAGE')

url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
data = {
    "chat_id": TELEGRAM_CHAT_ID,
    "message_thread_id": TELEGRAM_THREAD_ID,
    "text": MESSAGE,
}

response = requests.post(url, data=data)

if response.status_code == 200:
    print("Message sent successfully")
else:
    print(f"Failed to send message: {response.status_code} - {response.text}")
