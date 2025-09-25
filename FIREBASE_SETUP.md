# Firebase Configuration

## Current Setup
The project is currently using the **MeetMaxi Firebase project**:
- Project ID: `meetmaxi-apr-2025-6ed9d`
- Bundle ID (iOS): `ai.axarsoft.askmaxie` (needs updating to `com.kyozosocial.app`)
- Package Name (Android): needs updating to `com.kyozosocial.app`

## Required Changes for KyozoSocial

### 1. Create New Firebase Project (Recommended)
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project: `kyozosocial-app`
3. Enable Authentication with Email/Password and Google providers
4. Enable Firestore Database

### 2. Update App Configuration
1. Add iOS app with bundle ID: `com.kyozosocial.app`
2. Add Android app with package name: `com.kyozosocial.app`
3. Download new configuration files:
   - `GoogleService-Info.plist` for iOS
   - `google-services.json` for Android

### 3. Update Firebase Options
Run the FlutterFire CLI to generate new firebase_options.dart:
```bash
flutterfire configure --project=kyozosocial-app
```

### 4. Environment Variables
Copy `.env.example` to `.env.local` and update with your Firebase credentials.

## Current Firebase Configuration
- Using shared MeetMaxi project
- Authentication: Email/Password ✅
- Firestore: User data storage ✅
- Google Sign-In: Configured ✅

## Security Note
Firebase configuration contains sensitive API keys. Always use environment variables for production deployments.
