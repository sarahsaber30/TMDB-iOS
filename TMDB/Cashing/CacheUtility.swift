//
//  CacheUtility.swift
//  TMDB
//
//  Created by Sarah Saber on 20/07/2024.
//

import Foundation

class CacheUtility {
    static let shared = CacheUtility()
    
    private init() {}
    
    func saveMovies(_ movies: [Movie], for endpoint: Endpoint) {
        let key = cacheKey(for: endpoint)
        if let encodedData = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    func loadMovies(for endpoint: Endpoint) -> [Movie]? {
        let key = cacheKey(for: endpoint)
        if let savedData = UserDefaults.standard.data(forKey: key),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            return decodedMovies
        }
        return nil
    }
    
    func cacheKey(for endpoint: Endpoint) -> String {
        return "movies_\(endpoint.rawValue)"
    }
}
