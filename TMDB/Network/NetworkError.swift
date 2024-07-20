//
//  NetworkError.swift
//  TMDB
//
//  Created by Sarah Saber on 19/07/2024.
//


enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case invalidMimeType
    case unknown(Error)
}
