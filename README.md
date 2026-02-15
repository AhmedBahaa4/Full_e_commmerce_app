# E-Commerce Flutter App

Production-style Flutter e-commerce application using Cubit + Firebase.

## Features

- Authentication: email/password, Google, Facebook
- Onboarding flow with persistence
- Home feed with products, categories, and announcements carousel
- Favorites and cart management
- Product details with size/quantity and add-to-cart
- Checkout with address and payment method selection
- Theme toggle (light/dark)
- Firebase Cloud Messaging handling (foreground/background/open app)

## Tech Stack

- Flutter (Dart)
- Cubit / flutter_bloc
- Firebase Auth
- Cloud Firestore
- Firebase Messaging
- Shared Preferences

## Project Structure

- `lib/views/` UI pages and reusable widgets
- `lib/views_models/cubit/` state management
- `lib/services/` Firebase and data access services
- `lib/models/` app models
- `lib/utils/` routes, colors, and app constants

## Run Locally

1. Install dependencies:

```bash
flutter pub get
```

2. Configure Firebase for your target platform.

3. Run analyzer:

```bash
flutter analyze
```

4. Start app:

```bash
flutter run
```

## Notes

- Android Firebase config is already included (`android/app/google-services.json`).
- For iOS/web/desktop, make sure Firebase options are configured for each platform.
