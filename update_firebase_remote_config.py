import os
import json
import base64
import requests
from google.auth.transport.requests import Request
from google.oauth2 import service_account

def main():
    firebase_service_account_b64 = os.getenv('FIREBASE_SERVICE_ACCOUNT')
    apk_url = os.getenv('APK_URL')

    if not firebase_service_account_b64:
        raise ValueError("FIREBASE_SERVICE_ACCOUNT environment variable not set or empty.")

    if not apk_url:
        raise ValueError("APK_URL environment variable not set or empty.")

    # Decode the base64 encoded service account JSON
    firebase_service_account_json = base64.b64decode(firebase_service_account_b64).decode('utf-8')

    # Debugging: Print the first few characters of the service account JSON
    print(f"FIREBASE_SERVICE_ACCOUNT (first 100 chars): {firebase_service_account_json[:100]}")

    # Load service account credentials
    try:
        firebase_service_account_info = json.loads(firebase_service_account_json)
    except json.JSONDecodeError as e:
        raise ValueError(f"Error decoding FIREBASE_SERVICE_ACCOUNT JSON: {e}")

    credentials = service_account.Credentials.from_service_account_info(
        firebase_service_account_info,
        scopes=["https://www.googleapis.com/auth/firebase.remoteconfig"]
    )

    # Obtain access token
    credentials.refresh(Request())
    access_token = credentials.token

    # Construct Firebase Remote Config URL
    firebase_project_id = firebase_service_account_info.get('project_id')
    if not firebase_project_id:
        raise ValueError("Firebase project_id not found in service account JSON.")

    firebase_remote_config_url = f"https://firebaseremoteconfig.googleapis.com/v1/projects/{firebase_project_id}/remoteConfig"

    # Define headers for fetching the current template
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }

    # Fetch the current Remote Config template to get the ETag
    fetch_response = requests.get(firebase_remote_config_url, headers=headers)
    if fetch_response.status_code != 200:
        print(f"Error fetching remote config: {fetch_response.status_code}")
        print(fetch_response.text)
        fetch_response.raise_for_status()

    etag = fetch_response.headers.get('ETag')
    if not etag:
        raise ValueError("ETag not found in the response headers.")

    # Define headers and data for Remote Config update
    remote_config_headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json",
        "If-Match": etag
    }

    remote_config_data = {
        "parameters": {
            "latest_apk_url": {
                "defaultValue": {
                    "value": apk_url
                }
            }
        }
    }

    # Send update request to Firebase Remote Config
    response = requests.put(firebase_remote_config_url, headers=remote_config_headers, json=remote_config_data)

    # Log response details for debugging
    print(f"Request URL: {firebase_remote_config_url}")
    print(f"Request Headers: {remote_config_headers}")
    print(f"Request Body: {json.dumps(remote_config_data, indent=2)}")
    print(f"Response Status Code: {response.status_code}")
    print(f"Response Text: {response.text}")

    # Raise an error for bad responses
    response.raise_for_status()

    print("Firebase Remote Config updated successfully.")

if __name__ == "__main__":
    main()
