import os
import base64
import json
from google.oauth2 import service_account
from googleapiclient.discovery import build

# Decode base64-encoded credentials from GitHub Secrets
base64_credentials = os.getenv('CREDENTIALS')
json_credentials = json.loads(base64.b64decode(base64_credentials).decode('utf-8'))

# Initialize credentials from the decoded JSON
credentials = service_account.Credentials.from_service_account_info(json_credentials)

# Initialize the Drive service
drive_service = build('drive', 'v3', credentials=credentials)

# Function to fetch the latest APK URL from Google Drive
def get_latest_apk_url(folder_id):
    # Query parameters to get the latest file from the folder
    query = f"'{folder_id}' in parents and mimeType='application/vnd.android.package-archive'"
    files = drive_service.files().list(q=query, orderBy='createdTime desc', pageSize=1).execute()

    # Extract the webContentLink from the latest file
    latest_file = files.get('files')[0] if 'files' in files and len(files.get('files')) > 0 else None
    if latest_file:
        return latest_file.get('webContentLink')
    else:
        return None

# Retrieve the Google Drive folder ID from GitHub Secrets
folder_id = os.getenv('DRIVEFOLDERID')

# Example usage
latest_apk_url = get_latest_apk_url(folder_id)
if latest_apk_url:
    print("Latest APK URL:", latest_apk_url)
else:
    print("No APK found in the specified folder.")
