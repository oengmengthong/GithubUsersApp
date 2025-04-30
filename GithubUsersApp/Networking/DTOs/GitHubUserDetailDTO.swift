//
//  GitHubUserDetailDTO.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import Foundation

struct GitHubUserDetailDTO: Codable {
    let login: String
    let avatar_url: String
    let name: String?
    let bio: String?
    let blog: String?
    let location: String?
    let public_repos: Int
    let followers: Int
    let following: Int
    let created_at: String
}
