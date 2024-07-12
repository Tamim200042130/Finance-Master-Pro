import os
import requests
import json

def main():
    firebase_service_account_json = os.getenv('FIREBASE_SERVICE_ACCOUNT')
    apk_url = os.getenv('APK_URL')

    if not firebase_service_account_json:
        raise ValueError("FIREBASE_SERVICE_ACCOUNT environment variable not set or empty.")

    if not apk_url:
        raise ValueError("APK_URL environment variable not set or empty.")

    # Debugging: Print the first few characters of the service account JSON
    print(f"FIREBASE_SERVICE_ACCOUNT (first 100 chars): {firebase_service_account_json[:100]}")

    # Decode service account credentials
    try:
        firebase_service_account = json.loads(firebase_service_account_json)
    except json.JSONDecodeError as e:
        raise ValueError(f"Error decoding FIREBASE_SERVICE_ACCOUNT JSON: {e}")

    # Get access token
    token_url = "https://oauth2.googleapis.com/token"
    token_data = {
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "assertion": firebase_service_account['private_key']
    }
    token_headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    token_response = requests.post(token_url, data=token_data, headers=token_headers)
    token_response.raise_for_status()

    access_token = token_response.json()['access_token']

    # Update Firebase Remote Config
    firebase_project_id = firebase_service_account['project_id']
    firebase_remote_config_url = f"https://firebaseremoteconfig.googleapis.com/v1/projects/{firebase_project_id}/remoteConfig"

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

    remote_config_response = requests.put(firebase_remote_config_url, headers=remote_config_headers, data=json.dumps(remote_config_data))
    remote_config_response.raise_for_status()

    print("Firebase Remote Config updated successfully.")

if __name__ == "__main__":
    main()
