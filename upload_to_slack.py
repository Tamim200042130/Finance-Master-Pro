from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import os

client = WebClient(token=os.environ['SLACK_TOKEN'])

channel_id = os.environ['SLACK_CHANNEL']
file_path = os.environ['APK_FILE_PATH']

try:
    response = client.files_upload_v2(
        channels=channel_id,
        file=file_path,
        initial_comment="New APK file uploaded",
        title=os.path.basename(file_path)
    )
    print(f"File uploaded successfully: {response['file']['id']}")
except SlackApiError as e:
    print(f"Error uploading file: {e.response['error']}")
