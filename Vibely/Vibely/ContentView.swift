//
//  ContentView.swift
//  Vibely
//
//  Created by Nadya on 18/10/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = SongStore()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                if let message = store.errorMessage {
                    Text(message)
                        .foregroundStyle(.red)
                        .padding()
                }

                Text("Bagaimana perasaanmu hari ini?")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Mood.allCases) { mood in
                        NavigationLink(value: mood) {
                            MoodCard(
                                mood: mood,
                                count: store.filteredSongs(for: mood).count
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Vibely")
            .navigationDestination(for: Mood.self) { mood in
                SongListView(mood: mood, songs: store.filteredSongs(for: mood))
            }
        }
    }
}

struct MoodCard: View {
    let mood: Mood
    let count: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: mood.colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 8) {
                Image(systemName: mood.symbol)
                    .font(.largeTitle)
                Text(mood.title)
                    .font(.headline)
                Text("\(count) lagu")
                    .font(.caption)
            }
            .foregroundStyle(.white)
        }
        .frame(height: 140)
        .accessibilityElement(children: .combine)
    }
}

struct SongListView: View {
    let mood: Mood
    @State var songs: [Song]

    var body: some View {
        List(songs) { song in
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.title)
                        .font(.body)
                        .lineLimit(1)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                Link(destination: song.spotifyURL) {
                    Image(systemName: "arrow.up.right.square")
                }
                .accessibilityLabel("Buka \(song.title) di Spotify")
            }
        }
        .navigationTitle(mood.title)
        .toolbar {
            Button {
                songs.shuffle()
            } label: {
                Image(systemName: "shuffle")
            }
            .accessibilityLabel("Acak daftar lagu")
        }
        .overlay {
            if songs.isEmpty {
                ContentUnavailableView(
                    "Belum ada lagu",
                    systemImage: "music.note"
                )
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
