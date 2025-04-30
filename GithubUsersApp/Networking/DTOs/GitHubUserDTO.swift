//
//  GitHubUserDTO.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

struct GitHubUserDTO: Codable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
}
