//
//  MainTabView.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView {
            NavigationStack {
                UserListScreen(viewModel: UserListViewModel(context: context))
            }
            .tabItem {
                Label("Users", systemImage: "person.3")
            }

            NavigationStack {
                FavoritesScreen(viewModel: UserListViewModel(context: context))
            }
            .tabItem {
                Label("Favorites", systemImage: "star")
            }
        }
    }
}
