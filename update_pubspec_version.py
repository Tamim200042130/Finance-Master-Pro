import re

with open('version.txt', 'r') as version_file:
    version = version_file.read().strip()

if len(version.split('.')) == 2:
    version = f"{version}.0"

with open('pubspec.yaml', 'r') as pubspec_file:
    pubspec_contents = pubspec_file.read()

new_pubspec_contents = re.sub(r'^version: .*$',
                              f'version: {version}+1',
                              pubspec_contents,
                              flags=re.MULTILINE)

with open('pubspec.yaml', 'w') as pubspec_file:
    pubspec_file.write(new_pubspec_contents)

print(f'Updated pubspec.yaml to version {version}')
