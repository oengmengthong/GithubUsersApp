//
//  UserDetailViewModel.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
//

import Foundation
import Combine

final class UserDetailViewModel: ObservableObject {
    @Published var detail: GitHubUserDetailDTO?
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    func fetchDetail(username: String) {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else { return }

        isLoading = true
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitHubUserDetailDTO.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    print("Error fetching detail: \(error)")
                }
            }, receiveValue: { [weak self] detail in
                self?.detail = detail
            })
            .store(in: &cancellables)
    }
}
