import os
import sys
from google.oauth2 import service_account
from googleapiclient.discovery import build

# Fetch credentials from environment variable
credentials_json = os.getenv('CREDENTIALS')
folder_id = os.getenv('DRIVEFOLDERID')

# Function to fetch latest APK URL from Google Drive
def fetch_latest_apk_url():
    try:
        credentials = service_account.Credentials.from_service_account_info(credentials_json)
        drive_service = build('drive', 'v3', credentials=credentials)

        # List files in the specified folder
        results = drive_service.files().list(
            q=f"'{folder_id}' in parents and mimeType='application/vnd.android.package-archive'",
            fields='files(id, name)',
            orderBy='createdTime desc',
            pageSize=1
        ).execute()

        files = results.get('files', [])
        if files:
            latest_apk = files[0]
            apk_url = f"https://drive.google.com/uc?id={latest_apk['id']}"
            print(f"Latest APK URL: {apk_url}")
            return apk_url
        else:
            print("No APK found in the specified folder.")
            return None

    except Exception as e:
        print(f"Error fetching APK URL: {str(e)}")
        return None

# Entry point
if __name__ == "__main__":
    apk_url = fetch_latest_apk_url()
    if apk_url:
        sys.exit(0)
    else:
        sys.exit(1)
