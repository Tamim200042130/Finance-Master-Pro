import os
import json
import base64
import requests
from google.auth.transport.requests import Request
from google.oauth2 import service_account

def get_current_version():
    with open('version.txt', 'r') as file:
        return file.read().strip()

def main():
    # Load service account credentials
    firebase_service_account_b64 = os.getenv('FIREBASE_SERVICE_ACCOUNT')

    if not firebase_service_account_b64:
        raise ValueError("FIREBASE_SERVICE_ACCOUNT environment variable not set or empty.")

    # Decode the base64 encoded service account JSON
    firebase_service_account_json = base64.b64decode(firebase_service_account_b64).decode('utf-8')

    # Load service account credentials
    firebase_service_account_info = json.loads(firebase_service_account_json)
    credentials = service_account.Credentials.from_service_account_info(
        firebase_service_account_info,
        scopes=["https://www.googleapis.com/auth/firebase.remoteconfig"]
    )

    # Obtain access token
    credentials.refresh(Request())
    access_token = credentials.token

    # Construct Firebase Remote Config URL
    firebase_project_id = firebase_service_account_info.get('project_id')
    firebase_remote_config_url = f"https://firebaseremoteconfig.googleapis.com/v1/projects/{firebase_project_id}/remoteConfig"

    # Define headers for fetching the current template
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Fetch the current Remote Config template
    fetch_response = requests.get(firebase_remote_config_url, headers=headers)
    fetch_response.raise_for_status()

    remote_config = fetch_response.json()

    # Extract the latest ETag
    etag = fetch_response.headers.get('ETag')

    if not etag:
        raise ValueError("ETag not found in the response headers")

    # Obtain current app version
    current_version = get_current_version()

    # Get the APK URL from the environment variable
    original_apk_url = os.getenv('APK_URL')

    if not original_apk_url:
        raise ValueError("APK_URL environment variable not set or empty.")

    # Extract the file ID from the Google Drive URL
    file_id = original_apk_url.split('/d/')[1].split('/')[0]

    # Construct the direct download link
    direct_download_link = f"https://drive.google.com/uc?export=download&id={file_id}"

    # Update the remote config with the new APK URL and current version
    remote_config_data = {
        "parameters": {
            "latest_apk_url": {
                "defaultValue": {
                    "value": direct_download_link
                }
            },
            "minimum_required_version": {
                "defaultValue": {
                    "value": current_version
                }
            }
        }
    }

    # Define headers for updating the template
    update_headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json",
        "If-Match": etag
    }

    # Update the Remote Config template
    update_response = requests.put(firebase_remote_config_url, headers=update_headers, json=remote_config_data)
    update_response.raise_for_status()

    # Print the update response for debugging
    print("Update Response Status Code:", update_response.status_code)
    print("Update Response Text:", update_response.text)

if __name__ == "__main__":
    main()
