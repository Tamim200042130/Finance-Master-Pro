import firebase_admin
from firebase_admin import credentials, firestore

import os

# Fetch the environment variables
firebase_credentials_base64 = os.getenv('FIREBASE_SERVICE_ACCOUNT')
apk_url = os.getenv('APK_URL')

# Decode the base64-encoded credentials
firebase_credentials = base64.b64decode(firebase_credentials_base64).decode('utf-8')

# Initialize Firebase Admin SDK
cred = credentials.Certificate(json.loads(firebase_credentials))
firebase_admin.initialize_app(cred)

# Get the Remote Config instance
remote_config = firebase_admin.get_app().remote_config()

# Update the parameter
remote_config_params = remote_config.list_remote_config()
for param in remote_config_params:
    if param.key == 'latest_apk_url':
        param.update_value(apk_url)

# Publish changes to Firebase Remote Config
remote_config.publish()
print('Firebase Remote Config updated successfully.')
