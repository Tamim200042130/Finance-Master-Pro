import base64
import os
from googleapiclient.discovery import build
from google.oauth2 import service_account

def make_file_public(credentials_base64, folder_id):
    try:
        # Decode the base64-encoded credentials
        credentials_json = base64.b64decode(credentials_base64).decode('utf-8')

        # Write credentials to a temporary file
        with open('credentials.json', 'w') as f:
            f.write(credentials_json)

        # Authenticate using the credentials
        creds = service_account.Credentials.from_service_account_file(
            'credentials.json',
            scopes=['https://www.googleapis.com/auth/drive']
        )

        # Build the Google Drive service
        drive_service = build('drive', 'v3', credentials=creds)

        # Query files in the specified folder
        query = f"'{folder_id}' in parents"
        results = drive_service.files().list(q=query, fields="files(id, name)").execute()
        items = results.get('files', [])

        if not items:
            print(f'No files found in folder with ID: {folder_id}')
        else:
            for item in items:
                file_id = item['id']

                # Define permissions for making the file public
                permissions = {
                    "role": "reader",
                    "type": "anyone",
                }

                # Create permissions to make the file public
                drive_service.permissions().create(fileId=file_id, body=permissions).execute()

                # Get the public link
                file = drive_service.files().get(fileId=file_id, fields="webViewLink").execute()
                public_link = file.get("webViewLink", "Link not available")

                print(f'Made file public: {item["name"]} ({file_id})')
                print(f'Public link: {public_link}')

    except Exception as e:
        print(f'Failed to make files public with error: {e}')

def main():
    # Retrieve secrets from environment variables
    credentials_base64 = os.getenv('GOOGLE_CREDENTIALS_BASE64')
    folder_id = os.getenv('FOLDER_ID')

    if not credentials_base64:
        print("GOOGLE_CREDENTIALS_BASE64 environment variable not set.")
        return

    if not folder_id:
        print("FOLDER_ID environment variable not set.")
        return

    make_file_public(credentials_base64, folder_id)

if __name__ == '__main__':
    main()
