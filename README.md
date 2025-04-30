# GitHubUsersApp

A SwiftUI iOS app that lists GitHub users using the GitHub REST API. Includes infinite scroll, real-time search from the API, favorites using SwiftData, detailed user profiles, and deep linking to open profiles directly.

---

## 🚀 Features

- 🔍 **Search GitHub Users** via GitHub's Search API (`/search/users?q=...`)
- 🔄 **Infinite Scroll** using pagination with `since` parameter
- ⭐ **Favorite Users** persisted using SwiftData
- 🔗 **Share Profile** via native `UIActivityViewController`
- 🧭 **MVVM Architecture** with a simple Coordinator pattern
- 🌐 **Deep Link Support** to open directly to a user profile via `githubusers://user/{username}`
- 🧪 Built with **SwiftUI**, **Combine**, and **SwiftData**

---

## 🖼 Screenshots

| User List | Detail Page | Favorites Tab |
|-----------|-------------|----------------|
| ![List](./screenshots/list.png) | ![Detail](./screenshots/detail.png) | ![Favorites](./screenshots/favorites.png) |

---

## 🛠 Technologies

- **SwiftUI** – Declarative UI framework
- **Combine** – For reactive data flow
- **SwiftData** – Local persistence for favorite users
- **GitHub REST API** – `/users`, `/search/users`, `/users/{username}`
- **Custom URL Scheme** – `githubusers://user/{username}` for deep linking

---

## 🔗 Deep Link Instructions

The app supports launching directly into a user profile using this URL format:

githubusers://user/{username}

Example:

githubusers://user/mengthong

This will open the app and display the detail page for the specified user. Make sure your app has registered the `CFBundleURLTypes` in `Info.plist`.

---

## 📦 Project Structure

```text
.
├── Models
│   ├── GitHubUser.swift
├── Networking
│   └── DTOs
│       ├── GitHubUserDTO.swift
│       ├── GitHubSearchResponse.swift
│       └── GitHubUserDetailDTO.swift
├── ViewModels
│   ├── UserListViewModel.swift
│   └── UserDetailViewModel.swift
├── Views
│   ├── MainTabView.swift
│   ├── UserListScreen.swift
│   ├── FavoritesScreen.swift
│   └── UserDetailScreen.swift
├── Coordinators
│   └── AppCoordinator.swift
└── GitHubUsersApp.swift (entry point)
