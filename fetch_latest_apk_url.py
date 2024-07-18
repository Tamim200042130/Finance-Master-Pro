import os
import base64
import json
from google.oauth2 import service_account
from googleapiclient.discovery import build

def main():
    # Load credentials from environment variable
    credentials_base64 = os.getenv('CREDENTIALS')
    folder_id = os.getenv('DRIVEFOLDERID')

    if not credentials_base64:
        raise ValueError("CREDENTIALS environment variable is missing.")

    if not folder_id:
        raise ValueError("DRIVEFOLDERID environment variable is missing.")

    credentials_json = base64.b64decode(credentials_base64).decode('utf-8')
    credentials_dict = json.loads(credentials_json)

    # Authenticate and build the Drive API client
    credentials = service_account.Credentials.from_service_account_info(credentials_dict)
    service = build('drive', 'v3', credentials=credentials)

    # Query the files in the specified folder
    try:
        results = service.files().list(
            q=f"'{folder_id}' in parents and name contains 'Finance Master Pro' and mimeType='application/vnd.android.package-archive'",
            fields="nextPageToken, files(id, name, webViewLink)",
            pageSize=10
        ).execute()

        files = results.get('files', [])

        if not files:
            print('No APK files found in the specified folder.')
            return

        # Assuming the latest file is the most recently uploaded one
        latest_file = sorted(files, key=lambda x: x['name'], reverse=True)[0]
        print(f"Latest APK URL: {latest_file['webViewLink']}")

    except Exception as e:
        print(f"Error fetching APK URL: {e}")

if __name__ == '__main__':
    main()
