//
//  UserListViewModel.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import Foundation
import Combine
import SwiftData

final class UserListViewModel: ObservableObject {
    @Published var users: [GitHubUser] = []
    @Published var favorites: [GitHubUser] = []
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        fetchFavorites()
        observeSearch()
    }

    func fetchUsers() {
        guard let url = URL(string: "https://api.github.com/users") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GitHubUserDTO].self, decoder: JSONDecoder())
            .map { $0.map { GitHubUser(id: $0.id, login: $0.login, avatar_url: $0.avatar_url) } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching users: \(error)")
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }

    func fetchMoreUsers() {
        guard let lastID = users.last?.id,
              let url = URL(string: "https://api.github.com/users?since=\(lastID)&per_page=30")
        else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GitHubUserDTO].self, decoder: JSONDecoder())
            .map { $0.map { GitHubUser(id: $0.id, login: $0.login, avatar_url: $0.avatar_url) } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] newUsers in
                self?.users.append(contentsOf: newUsers)
            })
            .store(in: &cancellables)
    }

    func searchUsers(query: String) {
        guard let url = URL(string: "https://api.github.com/search/users?q=\(query)") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitHubSearchResponse.self, decoder: JSONDecoder())
            .map { $0.items.map { GitHubUser(id: $0.id, login: $0.login, avatar_url: $0.avatar_url) } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error searching users: \(error)")
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }

    private func observeSearch() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.fetchUsers()
                } else {
                    self?.searchUsers(query: text)
                }
            }
            .store(in: &cancellables)
    }

    func fetchFavorites() {
        do {
            favorites = try context.fetch(FetchDescriptor<GitHubUser>())
        } catch {
            print("Failed to fetch favorites: \(error)")
        }
    }

    func toggleFavorite(user: GitHubUser) {
        if isFavorite(user: user) {
            if let existing = favorites.first(where: { $0.id == user.id }) {
                context.delete(existing)
            }
        } else {
            let newFavorite = GitHubUser(id: user.id, login: user.login, avatar_url: user.avatar_url)
            context.insert(newFavorite)
        }
        do {
            try context.save()
            fetchFavorites()
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    func isFavorite(user: GitHubUser) -> Bool {
        return favorites.contains(where: { $0.id == user.id })
    }
}
