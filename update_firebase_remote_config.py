import os
import json
import firebase_admin
from firebase_admin import credentials, remote_config

def main():
    firebase_service_account_json = os.getenv('FIREBASE_SERVICE_ACCOUNT')
    apk_url = os.getenv('APK_URL')

    if not firebase_service_account_json:
        raise ValueError("FIREBASE_SERVICE_ACCOUNT environment variable not set or empty.")

    if not apk_url:
        raise ValueError("APK_URL environment variable not set or empty.")

    # Write the service account JSON to a temporary file
    temp_credentials_path = '/tmp/firebase_credentials.json'
    with open(temp_credentials_path, 'w') as f:
        f.write(firebase_service_account_json)

    # Initialize the Firebase app
    cred = credentials.Certificate(temp_credentials_path)
    firebase_admin.initialize_app(cred)

    # Create a new Remote Config parameter and set its value
    parameters = {
        'latest_apk_url': remote_config.Parameter(
            apk_url,
            remote_config.ParameterValueType.STRING
        )
    }

    # Create the Remote Config template
    template = remote_config.Template(parameters=parameters)

    # Publish the template to Firebase Remote Config
    remote_config.publish_template(template)

    print(f'Successfully updated Firebase Remote Config with APK URL: {apk_url}')

if __name__ == '__main__':
    main()
