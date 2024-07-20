//
//  CacheUtilityTests.swift
//  TMDBTests
//
//  Created by Sarah Saber on 20/07/2024.
//

import XCTest
@testable import TMDB

class CacheUtilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clean up UserDefaults before each test to ensure a fresh start.
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    override func tearDown() {
        // Clean up UserDefaults after each test.
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        super.tearDown()
    }

    func testSaveMovies() {
        let movies = [Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: nil, releaseDate: "2024-07-19")]
        let endpoint = Endpoint.nowPlaying
        
        CacheUtility.shared.saveMovies(movies, for: endpoint)
        
        let key = CacheUtility.shared.cacheKey(for: endpoint)
        XCTAssertNotNil(UserDefaults.standard.data(forKey: key), "Data should be saved in UserDefaults")
    }

    func testLoadMovies() {
        let movies = [Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: nil, releaseDate: "2024-07-19")]
        let endpoint = Endpoint.nowPlaying
        
        let key = CacheUtility.shared.cacheKey(for: endpoint)
        if let encodedData = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
        
        let loadedMovies = CacheUtility.shared.loadMovies(for: endpoint)
        XCTAssertNotNil(loadedMovies, "Movies should be loaded from UserDefaults")
        XCTAssertEqual(loadedMovies?.count, movies.count, "The count of loaded movies should match the count of saved movies")
        XCTAssertEqual(loadedMovies?.first?.title, movies.first?.title, "The title of the loaded movie should match the title of the saved movie")
    }
}

