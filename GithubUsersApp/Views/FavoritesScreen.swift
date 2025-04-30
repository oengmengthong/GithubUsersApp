//
//  FavoritesScreen.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import SwiftUI

struct FavoritesScreen: View {
    @ObservedObject var viewModel: UserListViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        List(viewModel.favorites) { user in
            Button(action: {
                coordinator.route = .userDetail(user)
            }) {
                HStack {
                    AsyncImage(url: URL(string: user.avatar_url)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                    Text(user.login)
                        .font(.headline)
                }
            }
        }
        .onAppear(perform: viewModel.fetchFavorites)
        .navigationTitle("Favorites")
        .navigationDestination(isPresented: Binding(
            get: { coordinator.route != nil },
            set: { if !$0 { coordinator.route = nil } }
        )) {
            if case let .userDetail(user) = coordinator.route {
                UserDetailScreen(user: user, viewModel: viewModel)
            }
        }
    }
}
