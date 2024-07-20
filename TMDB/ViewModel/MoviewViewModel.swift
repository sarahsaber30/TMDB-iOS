//
//  MoviewViewModel.swift
//  TMDB
//
//  Created by Sarah Saber on 19/07/2024.
//


import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>() // Make sure this is within the class scope
    var service: MovieServiceProtocol

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }

    func fetchMovies(endpoint: Endpoint) {
        service.fetchMovies(from: endpoint)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables) // Ensure 'cancellables' is used in the same class
    }
}
