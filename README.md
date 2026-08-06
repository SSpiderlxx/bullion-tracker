# 🏆 Bullion Tracker - Precious Metals Portfolio App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-gold.svg)](LICENSE)
[![GitHub Release](https://img.shields.io/badge/Release-v1.0.0-gold)](https://github.com/SSpiderlxx/bullion-tracker/releases/tag/v1.0.0)

**Bullion Tracker** is a production-quality, cross-platform mobile application for iOS and Android designed to track precious metal investments (Gold and Silver) with real-time portfolio performance calculations, live spot price sparklines, customizable price alerts, and offline-first SQLite persistence.

---

## ✨ Features

- 🪙 **Live Gold & Silver Spot Prices**: Real-time market data with 7-day price history trend sparklines.
- 📊 **Portfolio Performance Dashboard**: Instantly view Total Investment Value, Money Invested, Total Profit/Loss (£/$ and %), and Asset Allocation % (Gold vs Silver).
- 🔐 **Vault & Holdings Management**: Log purchases with custom premiums, shipping fees, purity, dealer name badges (*BullionByPost*, *Chards*, *APMEX*), and receipts.
- 🔔 **Custom Price Alerts**: Persisted SQLite alerts notifying users when gold or silver crosses custom price targets.
- 📉 **Analytics & Charts**: Interactive portfolio valuation charts, purchase history timelines, and allocation donut visualizations powered by `fl_chart`.
- 📁 **CSV & JSON Import/Export**: Export holdings to spreadsheet CSVs or full portfolio JSON backups.
- 🎨 **Luxury Metallic Design System**: Material 3 glassmorphism aesthetic with 3D metallic assets (`gold_bar.jpg`, `silver_coin.jpg`) tailored for dark mode.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: Flutter (Dart) with Material 3 Design
- **State Management**: Riverpod (`hooks_riverpod` & `flutter_hooks`)
- **Database**: SQLite via `package:sqlite3` for offline persistence
- **Charts**: `fl_chart` with custom smooth gradients & sparklines
- **Routing**: `go_router` for clean declarative navigation
- **Math Precision**: `decimal` for exact financial calculations

---

## 🚀 Building & Running

### Prerequisites
- Flutter SDK `^3.x`
- OpenJDK 17 (`JAVA_HOME` configured)
- Xcode (for iOS builds)

### 1. Clone & Install Dependencies
```bash
git clone https://github.com/SSpiderlxx/bullion-tracker.git
cd bullion-tracker
flutter pub get
```

### 2. Run Static Analysis & Tests
```bash
flutter analyze
flutter test
```

### 3. Build Release APK (Android)
```bash
flutter build apk --release
```

The compiled APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 Releases

Download pre-compiled binaries from the official [GitHub Release v1.0.0](https://github.com/SSpiderlxx/bullion-tracker/releases/tag/v1.0.0).

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
