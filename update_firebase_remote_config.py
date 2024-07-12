import os
import requests
import json
import base64

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

    # Decode service account credentials
    try:
        firebase_service_account = json.loads(firebase_service_account_json)
    except json.JSONDecodeError as e:
        raise ValueError(f"Error decoding FIREBASE_SERVICE_ACCOUNT JSON: {e}")

    # Get access token
    token_url = "https://oauth2.googleapis.com/token"
    token_request_data = {
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "assertion": firebase_service_account_json
    }
    token_response = requests.post(token_url, json=token_request_data)
    token_response.raise_for_status()
    access_token = token_response.json()['access_token']

    # Construct Firebase Remote Config URL
    firebase_project_id = firebase_service_account.get('project_id')
    if not firebase_project_id:
        raise ValueError("Firebase project_id not found in service account JSON.")

    firebase_remote_config_url = f"https://firebaseremoteconfig.googleapis.com/v1/projects/{firebase_project_id}/remoteConfig"

    # Define headers and data for Remote Config update
    remote_config_headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
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
    remote_config_response = requests.put(firebase_remote_config_url, headers=remote_config_headers, json=remote_config_data)
    remote_config_response.raise_for_status()

    print("Firebase Remote Config updated successfully.")

if __name__ == "__main__":
    main()
