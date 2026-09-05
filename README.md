# KicksVibe

<div align="center">
  <img src="assets/mdImages/Home.png" alt="KicksVibe home screen" width="220" />
  <h3>A modern Flutter storefront for discovering and buying sneakers</h3>
  <p>
    KicksVibe combines a polished shopping experience with Firebase services,
    local caching, location-aware checkout, and secure payment processing.
  </p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-3.12.2%2B-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter 3.12.2 or newer" />
    <img src="https://img.shields.io/badge/Dart-3.12.2%2B-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart 3.12.2 or newer" />
    <img src="https://img.shields.io/badge/Firebase-integrated-FFCA28?style=flat-square&logo=firebase&logoColor=111827" alt="Firebase integrated" />
    <img src="https://img.shields.io/badge/Architecture-Clean-111827?style=flat-square" alt="Clean Architecture" />
  </p>
</div>

## Overview

KicksVibe is a feature-rich e-commerce application focused on footwear. It is
designed around a clean, feature-first architecture and provides the complete
journey from account creation and product discovery to cart management,
location-aware checkout, payment, and order history.

## Features

- **Authentication:** Email/password authentication, email verification, and Google Sign-In.
- **Product discovery:** Search, best sellers, product details, image galleries, and multi-criteria filters.
- **Shopping flow:** Favorites, cart calculations, shipping fees, checkout, and order history.
- **Payments:** Paymob integration for card and supported local payment methods.
- **Location services:** Current location, reverse geocoding, and OpenStreetMap display.
- **Localization:** English, Arabic, and French support.
- **Personalization:** Light and dark themes with profile settings.
- **Performance:** Shimmer loading states, cached network images, Hive persistence, and SharedPreferences.
- **Notifications:** Firebase Cloud Messaging integration.

## App Preview

<div align="center">
  <table>
    <tr>
      <td align="center"><img src="assets/mdImages/Home.png" alt="Home screen" width="180" /><br /><strong>Home</strong></td>
      <td align="center"><img src="assets/mdImages/Search.png" alt="Search screen" width="180" /><br /><strong>Search</strong></td>
      <td align="center"><img src="assets/mdImages/Filter.png" alt="Filter screen" width="180" /><br /><strong>Filters</strong></td>
      <td align="center"><img src="assets/mdImages/Best%20Seller.png" alt="Best seller screen" width="180" /><br /><strong>Best Sellers</strong></td>
    </tr>
    <tr>
      <td align="center"><img src="assets/mdImages/Details.png" alt="Product details screen" width="180" /><br /><strong>Product Details</strong></td>
      <td align="center"><img src="assets/mdImages/My%20Cart.png" alt="Shopping cart screen" width="180" /><br /><strong>Cart</strong></td>
      <td align="center"><img src="assets/mdImages/Checkout.png" alt="Checkout screen" width="180" /><br /><strong>Checkout</strong></td>
      <td align="center"><img src="assets/mdImages/Profile.png" alt="Profile screen" width="180" /><br /><strong>Profile</strong></td>
    </tr>
  </table>
</div>

## Light Version

<div align="center">
  <table>
    <tr>
      <td align="center"><img src="assets/mdImages/Home-1.png" alt="Light version home screen" width="180" /></td>
      <td align="center"><img src="assets/mdImages/Search-1.png" alt="Light version search screen" width="180" /></td>
      <td align="center"><img src="assets/mdImages/Details-1.png" alt="Light version product details screen" width="180" /></td>
      <td align="center"><img src="assets/mdImages/Checkout-1.png" alt="Light version checkout screen" width="180" /></td>
    </tr>
  </table>
  <p><strong>Light version of the application</strong><br />النسخة الفاتحة من البرنامج</p>
</div>

## Technology Stack

| Area                 | Technology                                                    |
| -------------------- | ------------------------------------------------------------- |
| Framework            | Flutter and Dart                                              |
| State management     | BLoC / Cubit with `flutter_bloc`                              |
| Architecture         | Clean Architecture with feature-based modules                 |
| Dependency injection | `get_it` and `injectable`                                     |
| Backend              | Firebase Authentication, Cloud Firestore, and Cloud Messaging |
| Local storage        | Hive CE and SharedPreferences                                 |
| Networking           | Dio                                                           |
| Maps and location    | `flutter_map`, `geolocator`, `geocoding`, and OpenStreetMap   |
| Payments             | Paymob through secure API calls and WebView checkout          |

## Project Structure

```text
lib/
├── core/                 # Shared utilities, routing, localization, and DI
├── features/             # Feature-first application modules
│   ├── auth/             # Sign in, sign up, and password recovery
│   ├── home/             # Home feed, brands, and loading states
│   ├── search/           # Search and filter workflows
│   ├── product_details/  # Product gallery and product actions
│   ├── cart/             # Cart state and calculations
│   ├── checkout/         # Location, maps, and payment flow
│   ├── orders/           # Order history and tracking
│   └── profile/          # Account settings, language, and theme
├── firebase_options.dart # Generated Firebase platform configuration
├── hive_registrar.g.dart # Generated Hive adapters
└── main.dart             # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK compatible with Dart `3.12.2` or newer.
- A configured Firebase project for Android, iOS, or another target platform.
- Paymob credentials for testing the payment flow.

### Installation

1. Install the project dependencies:

   ```bash
   flutter pub get
   ```

2. Configure Firebase for the platform you want to run. The repository already
   contains generated Firebase configuration files; replace them with your
   project configuration when using a different Firebase project.

3. Add the required environment and payment settings to `env.json`. Keep
   private credentials out of source control.

4. Run the application on a connected device or emulator:

   ```bash
   flutter run
   ```

### Useful Commands

```bash
# Check the project for analyzer issues
flutter analyze

# Run the test suite
flutter test

# Regenerate injectable and Hive generated files when needed
dart run build_runner build --delete-conflicting-outputs
```

## Configuration Notes

- Firebase Authentication, Firestore, and Cloud Messaging must be enabled in the Firebase console.
- Location permissions must be granted by the user before requesting the current location.
- Payment credentials are environment-specific and should never be hard-coded or committed.
- Android and iOS platform permissions must be configured before testing maps, location, notifications, or payments.

## Contributing

1. Create a focused branch for your change.
2. Keep new code inside the appropriate feature and architecture layer.
3. Run `flutter analyze` and `flutter test` before opening a pull request.
4. Include screenshots or a short behavior description for user-facing changes.

## License

This project is not currently published under an open-source license.
