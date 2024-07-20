//
//  MovieServiceProtocol.swift
//  TMDB
//
//  Created by Sarah Saber on 20/07/2024.
//

import Foundation
import Combine

protocol MovieServiceProtocol {
    func fetchMovies(from endpoint: Endpoint) -> AnyPublisher<[Movie], Error>
}


