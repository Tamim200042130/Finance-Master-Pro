import re

# Read the version from version.txt
with open('version.txt', 'r') as version_file:
    version = version_file.read().strip()

# Ensure the version has three components
if len(version.split('.')) == 2:
    version = f"{version}.0"

# Read the contents of pubspec.yaml
with open('pubspec.yaml', 'r') as pubspec_file:
    pubspec_contents = pubspec_file.read()

# Replace the version line with the new version
new_pubspec_contents = re.sub(r'^version: .*$',
                              f'version: {version}+1',
                              pubspec_contents,
                              flags=re.MULTILINE)

# Write the updated contents back to pubspec.yaml
with open('pubspec.yaml', 'w') as pubspec_file:
    pubspec_file.write(new_pubspec_contents)

print(f'Updated pubspec.yaml to version {version}')
