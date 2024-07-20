//
//  Endpoint.swift
//  TMDB
//
//  Created by Sarah Saber on 19/07/2024.
//



enum Endpoint: String {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case upcoming = "upcoming"
    
    var url: String {
        return "\(API.baseURL)\(self.rawValue)?api_key=\(API.key)&language=en-US"
    }
}
