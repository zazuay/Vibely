//
//  Model.swift
//  Vibely
//
//  Created by Nadya on 18/10/26.
//

import SwiftUI
import Combine

enum Mood: String, CaseIterable, Identifiable, Codable {
    case happy, sad, energetic, calm

    var id: String { rawValue }

    var title: String {
        switch self {
        case .happy: return "Happy"
        case .sad: return "Sad"
        case .energetic: return "Energetic"
        case .calm: return "Calm"
        }
    }

    var symbol: String {
        switch self {
        case .happy: return "sun.max.fill"
        case .sad: return "cloud.rain.fill"
        case .energetic: return "bolt.fill"
        case .calm: return "leaf.fill"
        }
    }

    var colors: [Color] {
        switch self {
        case .happy: return [Color.yellow, Color.orange]
        case .sad: return [Color.indigo, Color.blue]
        case .energetic: return [Color.red, Color.pink]
        case .calm: return [Color.teal, Color.green]
        }
    }
}

struct Song: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let artist: String
    let mood: Mood
    let confidence: Double
    let spotifyURL: URL
}

final class SongStore: ObservableObject {
    @Published private(set) var songs: [Song] = []
    @Published var errorMessage: String?

    init() {
        load()
    }

    func load() {
        guard let url = Bundle.main.url(forResource: "songs", withExtension: "json") else {
            errorMessage = "songs.json tidak ditemukan. Pastikan file sudah ditambahkan ke target aplikasi."
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Song].self, from: data)
            songs = decoded
        } catch {
            errorMessage = "Gagal membaca songs.json: \(error.localizedDescription)"
        }
    }

    func filteredSongs(for mood: Mood) -> [Song] {
        let filtered = songs.filter { $0.mood == mood }
        return filtered.sorted { $0.confidence > $1.confidence }
    }
}
