//
//  GitHubSearchResponse.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import Foundation

struct GitHubSearchResponse: Codable {
    let items: [GitHubUserDTO]
}
