
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MovieListView(viewModel: MovieViewModel(), endpoint: .nowPlaying)
                .tabItem {
                    Label("Now Playing", systemImage: "film")
                }
            MovieListView(viewModel: MovieViewModel(), endpoint: .popular)
                .tabItem {
                    Label("Popular", systemImage: "star")
                }
            MovieListView(viewModel: MovieViewModel(), endpoint: .upcoming)
                .tabItem {
                    Label("Upcoming", systemImage: "calendar")
                }
        }
    }
}

