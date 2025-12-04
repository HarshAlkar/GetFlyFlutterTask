## Folder Structure
```
lib/
  main.dart
  models/
    dpr.dart
    project.dart
  providers/
    dpr_provider.dart
  screens/
    login_screen.dart
    project_list_screen.dart
    dpr_form_screen.dart
  widgets/
    project_card.dart
```

## Mock Credentials
- Email: `test@test.com`
- Password: `123456`

## Getting Started
1. Install Flutter SDK and platform toolchains.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## iOS Permissions
The following keys are added in `ios/Runner/Info.plist` for image picking:
- `NSPhotoLibraryUsageDescription`
- `NSCameraUsageDescription`

## Android Notes
`image_picker` manages the required permissions automatically. Ensure your emulator/device has a gallery app and images to pick.

## Known Issues / Limitations
- DPR data is stored in-memory only (resets on app restart).
- Authentication is mocked and not secure.
- No backend integration; all data is local.

## Screenshots (Placeholders)
Add screenshots in this section:
- Login Screen
- Project List Screen
- DPR Form Screen & History

---
Made with Flutter and Material 3.
# Construction Field Management – Intern Task App

A mobile-friendly Flutter app demonstrating login, project listing, and Daily Progress Report (DPR) submission with image attachments.

## Overview
This app includes:
- Login with mock credentials
- Project list from a static JSON-like source
- DPR form with validation, photo picker, and local in-memory history

## Features
- Material 3 design and responsive layout
- Provider-based state management (`DprProvider`)
- Image selection (1–3 photos) via `image_picker`
- Form validation for all fields
- DPR submission history per project (in-memory)

## Tech Stack
- Flutter SDK 3.8+
- Dart 3
- Packages: `provider`, `image_picker`
