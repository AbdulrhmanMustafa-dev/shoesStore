# KicksVibe

KicksVibe is a Flutter shoe-store app with Firebase authentication, a live
catalog, favourites, a persistent cart, checkout location and order history.

## Run locally

1. Install Flutter and run `flutter pub get`.
2. Configure Firebase for each platform you plan to run.
3. Start the app with `flutter run`.

## Payment setup

Payment credentials are deliberately not stored in this repository. Supply the
following values only through your secure CI/CD secrets or local environment:

```text
--dart-define=PAYMOB_API_KEY=...
--dart-define=PAYMOB_CARD_INTEGRATION_ID=...
--dart-define=PAYMOB_WALLET_INTEGRATION_ID=...
--dart-define=PAYMOB_IFRAME_ID=...
```

For example, append those `--dart-define` options to `flutter run`. Until all
four values are provided, checkout safely reports that payment is not
configured instead of sending requests with a secret embedded in the app.

## Quality checks

Run the following before publishing a build:

```text
flutter analyze
flutter test
```
