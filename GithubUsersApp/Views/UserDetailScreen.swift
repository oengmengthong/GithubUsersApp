//
//  UserDetailScreen.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import SwiftUI

struct UserDetailScreen: View {
    let user: GitHubUser
    @ObservedObject var viewModel: UserListViewModel
    @StateObject private var detailVM = UserDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: user.avatar_url)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())

                if let d = detailVM.detail {
                    Text(d.name ?? user.login)
                        .font(.largeTitle)
                        .bold()

                    if let bio = d.bio {
                        Text(bio)
                            .font(.body)
                            .multilineTextAlignment(.center)
                    }

                    Group {
                        if let location = d.location {
                            HStack { Image(systemName: "mappin.and.ellipse"); Text(location) }
                        }
                        if let blog = d.blog, !blog.isEmpty {
                            HStack { Image(systemName: "link"); Text(blog) }
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    HStack(spacing: 16) {
                        Label("\(d.followers) Followers", systemImage: "person.2")
                        Label("\(d.following) Following", systemImage: "arrow.right")
                        Label("\(d.public_repos) Repos", systemImage: "folder")
                    }
                    .font(.footnote)
                    .padding(.top)
                } else if detailVM.isLoading {
                    ProgressView("Loading user details...")
                }

                Button(action: {
                    viewModel.toggleFavorite(user: user)
                }) {
                    Label(
                        viewModel.isFavorite(user: user) ? "Unfavorite" : "Favorite",
                        systemImage: viewModel.isFavorite(user: user) ? "star.fill" : "star"
                    )
                }
                .buttonStyle(.borderedProminent)

                Button("Share Profile") {
                    share(user: user)
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(user.login)
        .onAppear {
            detailVM.fetchDetail(username: user.login)
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
