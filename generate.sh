# Build Runner Script
# Generates code for freezed, json_serializable, and other code generators

# Clean previous builds
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# For watching changes during development, use:
# flutter pub run build_runner watch --delete-conflicting-outputs
