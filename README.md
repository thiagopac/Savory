# Savory

A food delivery app for iOS. Browse restaurants, explore menus, save favorites, and track your orders.

## Screenshots

<table>
  <tr>
    <td><img src="screenshots/home.png" width="180"/></td>
    <td><img src="screenshots/detail.png" width="180"/></td>
    <td><img src="screenshots/cart.png" width="180"/></td>
  </tr>
  <tr>
    <td align="center">Home</td>
    <td align="center">Restaurant Detail</td>
    <td align="center">Cart</td>
  </tr>
  <tr>
    <td><img src="screenshots/search.png" width="180"/></td>
    <td><img src="screenshots/search_results.png" width="180"/></td>
    <td><img src="screenshots/orders.png" width="180"/></td>
  </tr>
  <tr>
    <td align="center">Search</td>
    <td align="center">Search Results</td>
    <td align="center">Orders</td>
  </tr>
  <tr>
    <td><img src="screenshots/order_detail.png" width="180"/></td>
    <td><img src="screenshots/favorites.png" width="180"/></td>
    <td><img src="screenshots/profile.png" width="180"/></td>
  </tr>
  <tr>
    <td align="center">Order Detail</td>
    <td align="center">Favorites</td>
    <td align="center">Profile</td>
  </tr>
</table>

## Tech stack

| | |
|---|---|
| Language | Swift 5 (Xcode 26) |
| UI | SwiftUI |
| Minimum deployment | iOS 17 |
| State management | `@Observable` macro |
| Networking | `URLSession` async/await |
| Navigation | `NavigationStack` + `NavigationLink` |

## Architecture

MVVM. Full screens live in `pages/`, reusable components in `Views/`. Each screen with async data has a dedicated `@Observable` ViewModel.

**Skeleton loading** — every tab renders animated shimmer placeholders while data loads, replacing the blank-screen + spinner pattern.

**Parallax hero** — the restaurant detail screen reads scroll offset via `GeometryReader` and applies a fractional offset to the cover photo, so the white card slides over the image faster than the photo moves.

**Shared environment objects** — `CartManager` and `FavoritesManager` are `@Observable` classes injected at the root via `.environment()`, making cart and favorites state available to any view without prop drilling.

**Parallel fetching** — screens that need multiple data sources use `async let` to fire requests concurrently.

## Project structure

```
Savory/
  Models/       — Codable data models (Restaurant, MenuItem, MasterOrder, …)
  Services/     — APIService (one static method per endpoint)
  ViewModels/   — HomeViewModel, SearchViewModel, OrdersViewModel, CartManager, FavoritesManager
  Views/        — Reusable components and skeleton views
  pages/        — Full screens (HomeView, SearchView, RestaurantDetailView, CartView, …)
```

## API

Powered by the open [Fake Restaurant API](https://fakerestaurantapi.runasp.net/Docs.html) — a public REST API that provides restaurants, menus, and order management in JSON format.

```
GET  /api/Restaurant                          — all restaurants
GET  /api/Restaurant?category={type}          — filter by cuisine
GET  /api/Restaurant?name={q}                 — search by name
GET  /api/Restaurant/{id}/menu                — restaurant menu
GET  /api/Restaurant/items?ItemName={q}       — search dishes
GET  /api/Order?apikey={key}                  — order history
GET  /api/Order/{masterID}?apikey={key}       — order items
POST /api/Order/{restaurantID}/makeorder      — place an order
DELETE /api/Order/master/{masterID}           — delete an order
```

`APIService` is an `enum` with static `async throws` methods, one per endpoint. No third-party networking libraries.
