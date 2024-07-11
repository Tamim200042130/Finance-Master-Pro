from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import os

client = WebClient(token=os.environ['SLACK_TOKEN'])

channel_id = os.environ['SLACK_CHANNEL']
file_path = os.environ['APK_FILE_PATH']

try:
    # Step 1: Retrieve the list of files in the channel
    response_files = client.files_list(channel=channel_id)
    files = response_files.get('files', [])

    # Step 2: Delete the files
    for file in files:
        try:
            client.files_delete(file=file['id'])
            print(f"Deleted file: {file['id']}")
        except SlackApiError as e:
            print(f"Error deleting file: {e.response['error']}")

    # Step 1: Retrieve the list of messages in the channel
    response_messages = client.conversations_history(channel=channel_id)
    messages = response_messages.get('messages', [])

    # Step 2: Delete the messages
    for message in messages:
        try:
            client.chat_delete(channel=channel_id, ts=message['ts'])
            print(f"Deleted message: {message['ts']}")
        except SlackApiError as e:
            print(f"Error deleting message: {e.response['error']}")

    # Step 3: Upload the new file
    response_upload = client.files_upload_v2(
        channels=channel_id,
        file=file_path,
        initial_comment="New APK file uploaded",
        title=os.path.basename(file_path)
    )
    print(f"File uploaded successfully: {response_upload['file']['id']}")
except SlackApiError as e:
    print(f"Error: {e.response['error']}")
