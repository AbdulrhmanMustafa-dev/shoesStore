# 👟 KicksVibe - Modern E-Commerce Shoes Store

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter Badge"/>
  <img src="https://img.shields.io/badge/Firebase-%23039BE5.svg?style=for-the-badge&logo=firebase&logoColor=white" alt="Firebase Badge"/>
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Badge"/>
  <br>
  <strong>A fully functional, scalable, and beautifully designed e-commerce application for footwear, built with Flutter, Firebase, and Clean Architecture.</strong>
</div>

<br>

<!-- استبدل banner.png باسم صورة الغلاف الخاصة بك -->
![KicksVibe Banner](assets/mdImages/banner.png)

## 📖 About The Project

**KicksVibe** is a comprehensive mobile commerce solution that offers a seamless shopping experience for sneaker enthusiasts. Engineered with robust **Clean Architecture** principles and **Cubit** for state management, the app ensures high performance, scalability, and a highly maintainable codebase. 

It features real-time backend integration, secure authentication, dynamic filtering, offline caching, and a complete checkout pipeline with a real payment gateway.

## ✨ Key Features

*   🔐 **Secure Authentication:** Email/Password & Google Sign-In with Email Verification (Firebase Auth).
*   💳 **Real Payment Gateway Integration:** Fully integrated with **Paymob** supporting Visa, Meeza, Vodafone Cash, and Instapay.
*   🌍 **Localization & Theming:** Supports English, Arabic, and French, alongside an elegant **Dark/Light Mode**.
*   📍 **Location & Mapping:** Live GPS location fetching with Reverse Geocoding and OpenStreetMap visualization.
*   🔎 **Smart Search & Filters:** Real-time search with local caching for recent searches, and dynamic multi-criteria filtering (Gender, Size, Price range).
*   📦 **Cart & Order Management:** Dynamic cart calculations, shipping fees, and order history tracking.
*   ⚡ **Exceptional UI/UX:** Features **Shimmer Loading Skeletons**, 3D image rotation sliders, and fluid animations.
*   💾 **Offline Caching:** Uses **Hive** and **SharedPreferences** for high-speed local data persistence (Favorites, Cart, Search History).

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <!-- قم بتعديل أسماء الصور هنا لتطابق الموجودة في مجلد mdImages -->
      <td><img src="assets/mdImages/home.png" width="220" alt="Home Screen"></td>
      <td><img src="assets/mdImages/search_filter.png" width="220" alt="Search and Filter"></td>
      <td><img src="assets/mdImages/product_details.png" width="220" alt="Product Details"></td>
      <td><img src="assets/mdImages/checkout.png" width="220" alt="Checkout"></td>
    </tr>
    <tr>
      <td align="center"><b>Home Screen & Shimmer</b></td>
      <td align="center"><b>Search & Filters</b></td>
      <td align="center"><b>Product Details (3D)</b></td>
      <td align="center"><b>Checkout & Maps</b></td>
    </tr>
    <tr>
      <td><img src="assets/mdImages/cart.png" width="220" alt="Cart Screen"></td>
      <td><img src="assets/mdImages/favorites.png" width="220" alt="Favorites"></td>
      <td><img src="assets/mdImages/orders.png" width="220" alt="Orders History"></td>
      <td><img src="assets/mdImages/profile.png" width="220" alt="Profile Settings"></td>
    </tr>
    <tr>
      <td align="center"><b>Cart Management</b></td>
      <td align="center"><b>Favorites Cache</b></td>
      <td align="center"><b>Orders History</b></td>
      <td align="center"><b>Localization & Dark Mode</b></td>
    </tr>
  </table>
</div>

## 🛠 Tech Stack & Architecture

This project strictly follows **Clean Architecture** (Presentation, Domain, Data layers) utilizing the **Dependency Inversion Principle**.

*   **Framework:** Flutter (Dart)
*   **State Management:** BLoC / Cubit (`flutter_bloc`)
*   **Dependency Injection:** GetIt & Injectable (`get_it`, `injectable`)
*   **Backend as a Service:** Firebase (Auth, Cloud Firestore, Cloud Messaging)
*   **Local Storage:** Hive (`hive_ce`), SharedPreferences
*   **Networking:** Dio (for Paymob APIs)
*   **Location Services:** `geolocator`, `geocoding`, `flutter_map`
*   **Localization:** `easy_localization`

## 📁 Folder Structure

```text
lib/
 ┣ core/                # Core utilities, routing, localization, and DI (GetIt)
 ┣ features/            # Feature-based folder structure
 ┃ ┣ auth/              # Login, Register, Recovery
 ┃ ┣ home/              # Dashboard, Brands, Shimmer Loaders
 ┃ ┣ search/            # Real-time Search and BottomSheet Filters
 ┃ ┣ product_details/   # Images Slider, Cart Logic
 ┃ ┣ cart/              # Cart management
 ┃ ┣ checkout/          # Geolocation, Maps, Paymob Integration
 ┃ ┣ orders/            # Order history and tracking
 ┃ ┗ profile/           # Settings, Localization toggle, Dark Mode
 ┣ main.dart            # Application Entry Point
 ┗ firebase_options.dart
