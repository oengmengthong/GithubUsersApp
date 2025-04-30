//
//  AppCoordinator.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import Foundation

enum AppRoute {
    case userDetail(GitHubUser)
    case deeplinkedUser(String)
}

final class AppCoordinator: ObservableObject {
    @Published var route: AppRoute?
}
