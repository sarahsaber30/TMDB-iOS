
import SwiftUI


struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    let endpoint: Endpoint
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    HStack {
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 150) // Fixed size for poster images
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 100, height: 150)
                            }
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(movie.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(movie.releaseDate!)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                    }
                }
            }
            .navigationTitle(endpoint.rawValue.capitalized)
            .onAppear {
                viewModel.fetchMovies(endpoint: endpoint)
            }
        }
    }
}


