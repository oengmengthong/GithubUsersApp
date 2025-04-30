//
//  UserListScreen.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import SwiftUI

struct UserListScreen: View {
    @ObservedObject var viewModel: UserListViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        List(viewModel.users) { user in
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

                    Spacer()

                    if viewModel.isFavorite(user: user) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .contextMenu {
                Button(viewModel.isFavorite(user: user) ? "Remove Favorite" : "Add Favorite") {
                    viewModel.toggleFavorite(user: user)
                }
                Button("Share") {
                    share(user: user)
                }
            }
            .onAppear {
                if user == viewModel.users.last {
                    viewModel.fetchMoreUsers()
                }
            }
        }
        .navigationTitle("GitHub Users")
        .searchable(text: $viewModel.searchText, prompt: "Search GitHub users")
        .navigationDestination(isPresented: Binding(
            get: { coordinator.route != nil },
            set: { if !$0 { coordinator.route = nil } }
        )) {
            destinationView()
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        switch coordinator.route {
            case .userDetail(let user):
                UserDetailScreen(user: user, viewModel: viewModel)

            case .deeplinkedUser(let username):
                UserDetailScreen(user: GitHubUser(id: 0, login: username, avatar_url: ""), viewModel: viewModel)

            case .none:
                EmptyView()
            }
    }

    private func share(user: GitHubUser) {
        let url = URL(string: "https://github.com/\(user.login)")!
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(av, animated: true, completion: nil)
        }
    }
}
