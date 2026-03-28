# Flutter E-Commerce App (GetX + Dio + Hive)

A production-style Flutter e-commerce application built as a scalable assessment project using **GetX**, **Dio**, and **Hive**.  
This app demonstrates clean architecture, API integration, local persistence, offline support, cart/wishlist management, and a polished modern UI.

---

## 🚀 Features

### Core Features
- Product listing from API
- Product details screen
- Add to Cart / Remove from Cart
- Add to Wishlist / Remove from Wishlist
- Cart quantity increment / decrement
- Cart total calculation
- Empty state handling for Cart and Wishlist

### Search & Filter
- Real-time product search
- Debounced search using **GetX Workers**
- Category filtering
- Basic price range filtering

### Local Persistence
- Cart state persisted using **Hive**
- Wishlist state persisted using **Hive**
- Restores cart and wishlist on app restart

### Offline Support
- Product list cached locally after successful API fetch
- If network is unavailable, app loads the last cached product list

### UX / UI Enhancements
- Modern custom header
- Premium styled product cards
- Reusable snackbar feedback
- Green success snackbar for add actions
- Red snackbar for remove actions
- Responsive layout and clean spacing

### Error Handling
- Graceful API error handling
- Retry support for failed product fetch

---

## 🧱 Tech Stack

- **Flutter**
- **GetX** (State Management, Dependency Injection, Navigation)
- **Dio** (API calls + interceptors)
- **Hive** (Local storage / caching)
- **Cached Network Image** (Image optimization)

---

## 📂 Project Structure

```bash
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── local/
│   ├── models/
│   ├── remote/
│   └── repositories/
│
├── modules/
│   ├── home/
│   ├── product_details/
│   ├── cart/
│   └── wishlist/
│
└── main.dart