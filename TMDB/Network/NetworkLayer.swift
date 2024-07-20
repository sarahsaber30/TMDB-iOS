//
//  NetworkLayer.swift
//  TMDB
//
//  Created by Sarah Saber on 19/07/2024.
//

import Foundation
import Combine

class MovieService : MovieServiceProtocol {
    
    func fetchMovies(from endpoint: Endpoint) -> AnyPublisher<[Movie], Error> {
        
        guard let url = URL(string: endpoint.url) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let mimeType = response.mimeType, mimeType == "application/json" else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .handleEvents(receiveOutput: { movies in
                            CacheUtility.shared.saveMovies(movies, for: endpoint)
                        })
                        .catch { _ -> AnyPublisher<[Movie], Error> in
                            if let cachedMovies = CacheUtility.shared.loadMovies(for: endpoint) {
                                return Just(cachedMovies)
                                    .setFailureType(to: Error.self)
                                    .eraseToAnyPublisher()
                            }
                            return Fail(error: URLError(.notConnectedToInternet))
                                .eraseToAnyPublisher()
                        }
            .mapError { error in
                return error as? NetworkError ?? NetworkError.unknown(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
