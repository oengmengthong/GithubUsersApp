//
//  GitHubUser.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

// GitHubUser.swift
import Foundation
import SwiftData

@Model
final class GitHubUser: Identifiable {
    @Attribute(.unique) var id: Int
    var login: String
    var avatar_url: String

    init(id: Int, login: String, avatar_url: String) {
        self.id = id
        self.login = login
        self.avatar_url = avatar_url
    }
}
