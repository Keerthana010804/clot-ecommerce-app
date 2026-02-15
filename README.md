# Clot – E-Commerce Flutter App

Clot is a full-featured e-commerce mobile application built using Flutter and Firebase.
This project was developed as part of my Flutter learning journey, focusing on real-world app architecture, state management, API integration, and Firebase services.

## ✨ Features

🔐 User Authentication
- Google Sign-In using Firebase Authentication

🛍️ Product Catalog
- Dynamic product listing from FakeStoreAPI with offline JSON fallback

🛒 Shopping Cart
- Persistent cart using SharedPreferences

❤️ Wishlist / Favorites
- Save and manage favorite products

👤 User Profile
- Profile details with image upload support

📂 Categories
- Category-based product browsing with images

💳 Payment Integration
- Secure payments using Razorpay

🔔 Notifications
- Local and push notifications using Awesome Notifications

📱 Responsive UI
- Material Design with custom theming

🌐 Offline Support
- Local data fallback when API is unavailable

## 📸 Screenshots

<img width="976" height="618" alt="clot1" src="https://github.com/user-attachments/assets/ff4de8f8-6169-4215-84e3-4af3f3e1c324" />

<img width="976" height="618" alt="clot2" src="https://github.com/user-attachments/assets/9efc8c25-0477-4ec8-9248-d65643cb6d35" />

<img width="976" height="618" alt="clot3" src="https://github.com/user-attachments/assets/31d9bb74-bad9-4910-a041-5e2c422d0556" />

<img width="976" height="618" alt="clot4" src="https://github.com/user-attachments/assets/fb75d375-7d9d-46b0-974f-e554c350e6b3" />

## 🧰 Technical Stack

- Framework: Flutter (SDK ^3.8.1)
- Backend: Firebase Authentication & Firestore
- State Management: Provider
- API Integration: FakeStoreAPI
- Local Storage: SharedPreferences
- Payments: Razorpay Flutter (Testing phase)
- Notifications: Awesome Notifications
- Networking: HTTP package

## 📁 Project Structure

```bash
lib/
├── models/          # Data models (Product, User, CartItem)
├── provider/        # State management (Auth, Cart, Favorites, Profile)
├── repositories/    # Data access layer
├── screens/         # UI screens (20+ screens)
├── services/        # Business logic (Auth, API handling)
├── utils/           # Constants, themes, preferences
└── widgets/         # Reusable UI components
```

## 🚀 Getting Started

Prerequisites

- Flutter SDK (>= 3.8.1)
- Dart SDK
- Firebase project
- Android Studio or VS Code

Installation

1. Clone the Repository
2. Install dependencies:
```bash
flutter pub get
```
3. Run the app:
```bash
flutter run
```

Firebase Setup

1. Create a project in Firebase Console
2. Add Android & iOS apps
3. Download:
      - google-services.json (Android)
      - GoogleService-Info.plist (iOS)
4. Place them in the respective platform folders

## 🎯 Purpose of the Project
This project was built to practice Flutter development using
real-world features such as authentication, API integration,
state management, and payments.

## 🧠 Learning Outcomes

This project helped me gain hands-on experience with:

- Flutter app architecture & clean code practices
- Provider-based state management
- REST API integration & offline handling
- Firebase Authentication & Firestore
- Payment gateway integration
- Persistent local storage
- Real-world UI/UX implementation

## 🏗️ Architecture Overview

- Presentation Layer – Screens & Widgets
- Business Logic Layer – Providers & Services
- Data Layer – Repositories & Models

The app follows clean architecture principles to ensure scalability and maintainability.

## 📜 License

This project is licensed under the MIT License.
