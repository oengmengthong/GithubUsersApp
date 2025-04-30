//
//  GithubUsersAppApp.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import SwiftUI
import SwiftData

@main
struct GitHubUsersAppApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(coordinator)
                .modelContainer(for: GitHubUser.self)
                .onOpenURL { url in
                    handleDeeplink(url: url)
                }
        }
    }
    
    func handleDeeplink(url: URL) {
            guard url.scheme == "githubusers",
                  url.host == "user",
                  let username = url.pathComponents.dropFirst().first
            else { return }
            coordinator.route = .deeplinkedUser(username)
        }
}
