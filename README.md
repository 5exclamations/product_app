<div align="center">


# Market Price Tracker

Flutter app that helps users browse and compare product prices across markets with search, filters, discount view, sorting, theming, and multilingual UI (EN/RU/AZ).

<a href="https://github.com/5exclamations/product_app">
  <img src="https://img.shields.io/badge/Flutter-App-02569B?logo=flutter&logoColor=white" alt="Flutter Badge" />
</a>
<img src="https://img.shields.io/badge/Dart-2%2B-0175C2?logo=dart&logoColor=white" alt="Dart Badge" />
<img src="https://img.shields.io/badge/State-Provider-5A2D82" alt="Provider Badge" />
<img src="https://img.shields.io/badge/API-REST-111827" alt="REST Badge" />
<img src="https://img.shields.io/badge/i18n-EN%20%7C%20RU%20%7C%20AZ-0F766E" alt="i18n Badge" />
<img src="https://img.shields.io/badge/UI-Material%203-6D28D9" alt="Material 3 Badge" />

</div>

---
<!--
## Preview


<p align="center">
  <img src="assets/screenshots/home.png" height="420" alt="Home screen" />
  <img src="assets/screenshots/filters.png" height="420" alt="Filters & sorting" />
  <img src="assets/screenshots/product.png" height="420" alt="Product details" />
</p>
-->

## What this app does

- Browse markets and categories.
- Fetch products from a REST API with query filters:
  - `search`
  - `category_id`
  - `market_id`
  - `on_discount=true`
  - `sort_by=price|name|discount`
  - `sort_order=asc|desc`
- Show discounts and compute discount percentage on the client.
- Persist user preferences:
  - Theme mode: system / light / dark.
  - Locale: English / Russian / Azerbaijani.

## Tech stack

- Flutter.
- State management: `provider` (ChangeNotifier + Consumer).
- Networking: `http`.
- Local persistence: `shared_preferences`.
- Localization: `flutter_localizations` + `AppLocalizationsDelegate`.

## Architecture (high-level)

```text
UI (screens/widgets)
   ↓
SettingsProvider (theme + locale)  ← persisted in SharedPreferences
   ↓
ApiService (HTTP client)
   ↓
DTO models (Market / Category / Product)
   ↓
Backend REST API
```
API endpoint

Base URL:

```text
https://api-for-app-r444.onrender.com/api/v1
```
Routes used by the app:

    GET /markets/

    GET /categories/

    GET /products/ (supports filtering & sorting via query parameters)

Example:

```text
GET /products/?search=milk&market_id=1&on_discount=true&sort_by=price&sort_order=asc
```
Getting started

    Install Flutter SDK.

    Fetch dependencies:

    bash
    flutter pub get

    Run:

    bash
    flutter run

    If you use a different backend, update baseUrl in ApiService.



  Backend API used by this app: https://github.com/5exclamations/api_for_app

  This Flutter client consumes the API endpoints for markets, categories, and products.



