# import os
#
# import requests
#
# TELEGRAM_TOKEN = os.getenv('TELEGRAM_TOKEN')
# TELEGRAM_CHAT_ID = os.getenv('TELEGRAM_CHAT_ID')
# TELEGRAM_THREAD_ID = os.getenv('TELEGRAM_THREAD_ID')
# MESSAGE = os.getenv('MESSAGE')
# APK_FILE_PATH = os.getenv('APK_FILE_PATH')
#
# url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendDocument"
# files = {'document': open(APK_FILE_PATH, 'rb')}
# data = {
#     "chat_id": TELEGRAM_CHAT_ID,
#     "message_thread_id": TELEGRAM_THREAD_ID,
# }
#
# response = requests.post(url, data=data, files=files)
#
# if response.status_code == 200:
#     document_link = response.json()['result']['document']['file_id']
#     print("APK file uploaded successfully")
#
#     url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
#     data = {
#         "chat_id": TELEGRAM_CHAT_ID,
#         "message_thread_id": TELEGRAM_THREAD_ID,
#         "text": f"{MESSAGE}",
#     }
#
#     response = requests.post(url, data=data)
#
#     if response.status_code == 200:
#         print("Message sent successfully")
#     else:
#         print(f"Failed to send message: {response.status_code} - {response.text}")
# else:
#     print(f"Failed to upload APK file: {response.status_code} - {response.text}")

import os
import requests

# Environment variables
TELEGRAM_TOKEN = os.getenv('TELEGRAM_TOKEN')
TELEGRAM_CHAT_ID = os.getenv('TELEGRAM_CHAT_ID')
TELEGRAM_THREAD_ID = os.getenv('TELEGRAM_THREAD_ID')
MESSAGE = os.getenv('MESSAGE')
APK_FILE_PATH = os.getenv('APK_FILE_PATH')


# Function to delete previous messages
def delete_previous_messages():
    # Retrieve the list of updates (messages) for the bot
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/getUpdates"
    response = requests.get(url)

    if response.status_code == 200:
        updates = response.json()['result']

        # Iterate over updates and delete messages
        for update in updates:
            if 'message' in update:
                message_id = update['message']['message_id']
                chat_id = update['message']['chat']['id']

                # Delete the message
                delete_url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/deleteMessage"
                data = {
                    "chat_id": chat_id,
                    "message_id": message_id
                }
                delete_response = requests.post(delete_url, data=data)

                if delete_response.status_code == 200:
                    print(f"Deleted message: {message_id}")
                else:
                    print(
                        f"Failed to delete message: {delete_response.status_code} - {delete_response.text}")


# Step 1: Delete previous messages
delete_previous_messages()

# Step 2: Upload the new APK file
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

    # Step 3: Send a new message with the file link
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
    data = {
        "chat_id": TELEGRAM_CHAT_ID,
        "message_thread_id": TELEGRAM_THREAD_ID,
        "text": f"{MESSAGE}",
    }

    response = requests.post(url, data=data)

    if response.status_code == 200:
        print("Message sent successfully")
    else:
        print(f"Failed to send message: {response.status_code} - {response.text}")
else:
    print(f"Failed to upload APK file: {response.status_code} - {response.text}")
