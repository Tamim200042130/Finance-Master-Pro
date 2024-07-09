# delete_drive_files.py
from googleapiclient.discovery import build
from google.oauth2 import service_account
import os

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
        drive_service.files().delete(fileId=file_id).execute()
        print(f'Deleted file: {item["name"]} ({file_id})')
