# VPN Connection App

A Flutter application with a VPN connection UI and analytics dashboard.

## Features

- **VPN Connection Screen**

  - Connect/Disconnect button with animated state changes
  - Connection status display
  - Timer showing connection duration
  - Visual animation when connected

- **Analytics Screen**
  - Bar chart showing connection history
  - List view of past connections with details
  - Summary statistics (total connections, average duration)

## Architecture

This app is built using:

- Flutter for the UI
- BLoC pattern for state management
- Shared Preferences for local storage
- Firebase Analytics for event tracking
- ScreenUtil for responsive design

## Setup Instructions

1. **Clone the repository**

   ```
   git clone <repository-url>
   cd vpn-connection-app
   ```

2. **Install dependencies**

   ```
   flutter pub get
   ```

3. **Configure Firebase**

   - Create a new Firebase project
   - Add your app to the Firebase project
   - Download the `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS)
   - Place these files in the appropriate directories

4. **Run the app**
   ```
   flutter run
   ```

## Testing

The app includes unit tests for the core functionality:

```
flutter test
```

## Project Structure

- `lib/blocs/` - BLoC pattern implementation
- `lib/models/` - Data models
- `lib/screens/` - App screens
- `lib/widgets/` - Reusable UI components
- `lib/utils/` - Utility functions
- `test/` - Unit tests

## Dependencies

- flutter_bloc: ^8.1.3
- equatable: ^2.0.5
- shared_preferences: ^2.2.2
- firebase_core: ^2.24.2
- firebase_analytics: ^10.8.0
- flutter_screenutil: ^5.9.0
- fl_chart: ^0.65.0
- lottie: ^2.7.0
- intl: ^0.18.1

## License

This project is licensed under the MIT License.
