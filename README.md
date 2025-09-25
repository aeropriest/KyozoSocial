# KyozoSocial

KyozoSocial is a Flutter application that provides social authentication features including email/password and Google Sign-In integration.

## Features

- **Email Authentication**: Sign up and sign in with email and password
- **Google Sign-In**: One-tap authentication with Google accounts
- **Email Verification**: Secure email verification flow
- **Firebase Integration**: Real-time authentication and user management
- **Cross-platform**: Available on both iOS and Android
- **Modern UI**: Clean and intuitive user interface

## Getting Started

### Prerequisites

- Flutter SDK (3.6.0 or higher)
- Firebase project setup
- iOS development environment (for iOS builds)
- Android development environment (for Android builds)

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase for your project
4. Run the app using `flutter run`

## Firebase Configuration

This app uses Firebase for:
- Authentication (Email/Password and Google)
- Firestore database for user data
- Email verification

Make sure to configure your Firebase project and add the configuration files:
- `ios/Runner/GoogleService-Info.plist` for iOS
- `android/app/google-services.json` for Android

## Project Structure

The app follows a feature-based architecture with:
- `/features/auth` - Authentication screens and logic
- `/features/home` - Home screen after authentication
- `/core` - Shared utilities, themes, and widgets
- `/services` - Authentication service and API integrations

## Authentication Flow

1. **GetStartedScreen** - Welcome screen with sign-in option
2. **SignInScreen** - Combined sign-in/sign-up screen with toggle
3. **VerifyEmailScreen** - Email verification (if needed)
4. **HomeScreen** - Main screen after successful authentication

## Dependencies

Key dependencies used:
- `firebase_core` & `firebase_auth` - Firebase authentication
- `cloud_firestore` - User data storage
- `google_sign_in` - Google authentication
- `font_awesome_flutter` - Icons
- `google_fonts` - Typography

## Bundle Identifiers

- iOS: `com.kyozosocial.app`
- Android: `com.kyozosocial.app`

## Contributing

Please read our contributing guidelines before submitting pull requests.

## License

This project is proprietary software.
