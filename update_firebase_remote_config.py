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

    # Decode service account credentials
    firebase_service_account = json.loads(firebase_service_account_json)

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
    access_token = token_response.json()['access_token']

    # Update Remote Config
    remote_config_url = f"https://firebaseremoteconfig.googleapis.com/v1/projects/{firebase_service_account['project_id']}/remoteConfig"
    remote_config_headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json; UTF-8",
        "Accept": "application/json"
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
    remote_config_response = requests.put(remote_config_url, headers=remote_config_headers, json=remote_config_data)

    if remote_config_response.status_code == 200:
        print(f'Successfully updated Firebase Remote Config with APK URL: {apk_url}')
    else:
        print(f'Failed to update Firebase Remote Config: {remote_config_response.text}')

if __name__ == '__main__':
    main()
