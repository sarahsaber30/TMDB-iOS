//
//  MovieDetailView.swift
//  TMDB
//
//  Created by Sarah Saber on 19/07/2024.


import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            Text(movie.title)
                .font(.largeTitle)
                .padding()
            Text(movie.overview)
                .padding()
            Spacer()
        }
        .navigationTitle(movie.title)
    }
}
