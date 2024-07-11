import os
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

slack_token = os.getenv('SLACK_TOKEN')
channel_id = os.getenv('SLACK_CHANNEL')
file_path = os.getenv('APK_FILE_PATH')

client = WebClient(token=slack_token)

try:
    response = client.files_upload(
        channels=channel_id,
        file=file_path,
        initial_comment="New version of Finance Master Pro is available!"
    )
    assert response["file"]
except SlackApiError as e:
    print(f"Error uploading file: {e.response['error']}")
