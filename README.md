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

## Responsive & Landscape

This project now includes a responsive system to improve layout behavior across:

- Small phones
- Large phones
- Tablets
- Landscape orientation

Core helper:

- `lib/utils/responsive_helper.dart`

What it provides:

- Screen/orientation checks (`isLandscape`, `isTablet`, `isDesktop`)
- Adaptive content width (`maxContentWidth`)
- Adaptive spacing (`horizontalPadding`)
- Adaptive product grid columns (`productGridCount`)

Updated responsive screens/components:

- `lib/views/widgets/home_tab_view.dart`
- `lib/views/pages/cart_page.dart`
- `lib/views/widgets/cart_item_widget.dart`
- `lib/views/pages/onboarding_page.dart`
- `lib/views/pages/product_details_page.dart`
- `lib/views/widgets/category_tab_view.dart`
- `lib/views/pages/checkout_page.dart`
- `lib/views/widgets/ai_floating_button.dart`

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
