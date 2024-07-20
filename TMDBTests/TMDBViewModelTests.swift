//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Sarah Saber on 19/07/2024.
//


import XCTest
import Combine
@testable import TMDB

class MovieViewModelTests: XCTestCase {
    
    var viewModel: MovieViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = MovieViewModel(service: MockMovieService())
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchMoviesSuccess() {
        let expectation = XCTestExpectation(description: "Movies fetched successfully")
        
        let mockService = MockMovieService()
        viewModel.service = mockService
        
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, mockService.mockMovies.count)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMovies(endpoint: .nowPlaying)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMoviesFailure() {
        let expectation = XCTestExpectation(description: "Movies fetch failed")
        
        let mockService = MockMovieService()
        mockService.shouldReturnError = true
        viewModel.service = mockService
        
        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMovies(endpoint: .nowPlaying)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

class MockMovieService: MovieServiceProtocol {
    
    var shouldReturnError = false
    let mockMovies = [
        Movie(id: 1, title: "Movie 1", overview: "2024-01-01", posterPath: nil, releaseDate: "Overview 1"),
        Movie(id: 2, title: "Movie 2", overview: "2024-02-01", posterPath: nil, releaseDate: "Overview 2")
    ]
    
    func fetchMovies(from endpoint: Endpoint) -> AnyPublisher<[Movie], Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        } else {
            return Just(mockMovies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
