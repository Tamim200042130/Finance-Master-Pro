import base64
import json
import os
from googleapiclient.discovery import build
from google.oauth2 import service_account

# Decode the base64-encoded credentials
credentials_base64 = os.getenv('GOOGLE_CREDENTIALS_BASE64')
credentials_json = base64.b64decode(credentials_base64).decode('utf-8')

# Save the credentials to a temporary file
with open('credentials.json', 'w') as f:
    f.write(credentials_json)

# Load credentials
credentials = service_account.Credentials.from_service_account_file(
    'credentials.json',
    scopes=['https://www.googleapis.com/auth/drive']
)

drive_service = build('drive', 'v3', credentials=credentials)

folder_id = os.getenv('FOLDER_ID')

# List all files in the folder
query = f"'{folder_id}' in parents"
results = drive_service.files().list(q=query, fields="files(id, name)").execute()
items = results.get('files', [])

if not items:
    print('No files found.')
else:
    for item in items:
        file_id = item['id']
        try:
            drive_service.files().delete(fileId=file_id).execute()
            print(f'Deleted file: {item["name"]} ({file_id})')
        except Exception as e:
            print(f'Failed to delete file: {item["name"]} ({file_id}) with error: {e}')
