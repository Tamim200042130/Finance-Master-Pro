import firebase_admin
from firebase_admin import credentials, firestore, initialize_app
import base64
import os

# Fetch the Firebase service account credentials from environment variables
firebase_credentials_base64 = os.getenv('FIREBASE_SERVICE_ACCOUNT_JSON')

print(firebase_credentials_base64)  # Add this line for debugging

# Decode the base64-encoded JSON and save it to a temporary file
temp_credentials_path = '/tmp/firebase_credentials.json'

if firebase_credentials_base64:
    with open(temp_credentials_path, 'wb') as f:
        f.write(base64.b64decode(firebase_credentials_base64))
else:
    print("Error: FIREBASE_SERVICE_ACCOUNT_JSON environment variable not set or empty.")

# Initialize Firebase with the credentials
if os.path.exists(temp_credentials_path):
    cred = credentials.Certificate(temp_credentials_path)
    initialize_app(cred)

    # Access Firestore database
    db = firestore.client()

    # Update remote config parameters
    def update_remote_config(apk_url):
        remote_config = db.collection('remoteConfig').document('parameters')

        remote_config.set({
            'latest_apk_url': apk_url
        }, merge=True)

    # Fetch APK URL from environment variables or arguments
    apk_url = os.getenv('APK_URL')

    # Update Firebase Remote Config
    update_remote_config(apk_url)

    print("Firebase Remote Config updated successfully!")
else:
    print(f"Error: Temporary credentials file '{temp_credentials_path}' not found.")
