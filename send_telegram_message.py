import os

import requests

TELEGRAM_TOKEN = os.getenv('TELEGRAM_TOKEN')
TELEGRAM_CHAT_ID = os.getenv('TELEGRAM_CHAT_ID')
TELEGRAM_THREAD_ID = os.getenv('TELEGRAM_THREAD_ID')
MESSAGE = os.getenv('MESSAGE')
APK_FILE_PATH = os.getenv('APK_FILE_PATH')

# Upload APK file to Telegram
url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendDocument"
files = {'document': open(APK_FILE_PATH, 'rb')}
data = {
    "chat_id": TELEGRAM_CHAT_ID,
    "message_thread_id": TELEGRAM_THREAD_ID,
}

response = requests.post(url, data=data, files=files)

if response.status_code == 200:
    document_link = response.json()['result']['document']['file_id']
    print("APK file uploaded successfully")

    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
    data = {
        "chat_id": TELEGRAM_CHAT_ID,
        "message_thread_id": TELEGRAM_THREAD_ID,
        # "text": f"{MESSAGE}\nDownload Now: {document_link}",
    }

    response = requests.post(url, data=data)

    if response.status_code == 200:
        print("Message sent successfully")
    else:
        print(f"Failed to send message: {response.status_code} - {response.text}")
else:
    print(f"Failed to upload APK file: {response.status_code} - {response.text}")
