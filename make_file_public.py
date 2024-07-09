import base64
import os
from googleapiclient.discovery import build
from google.oauth2 import service_account

# Load the base64-encoded credentials from environment variable
credentials_base64 = os.getenv('GOOGLE_CREDENTIALS_BASE64')

# Decode and write credentials to a temporary JSON file
credentials_json = base64.b64decode(credentials_base64).decode('utf-8')
with open('credentials.json', 'w') as f:
    f.write(credentials_json)

# Authenticate using service account credentials
credentials = service_account.Credentials.from_service_account_file(
    'credentials.json',
    scopes=['https://www.googleapis.com/auth/drive']
)

# Build the Google Drive service
drive_service = build('drive', 'v3', credentials=credentials)

# Get the file ID from environment variable or use the output from upload action
file_id = os.getenv('FILE_ID')

# Make the file public
permissions = {
    "role": "reader",
    "type": "anyone",
}
drive_service.permissions().create(fileId=file_id, body=permissions).execute()

# Clean up: remove the temporary credentials file
os.remove('credentials.json')
