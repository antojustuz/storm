import Foundation

struct MeditationDuration: Identifiable, Hashable, Equatable {
    let id: UUID = UUID()
    let minutes: Int

    var seconds: Int { minutes * 60 }
    var label: String { "\(minutes) min" }
}

struct MusicTrack: Identifiable, Hashable, Equatable {
    let id: UUID = UUID()
    let fileName: String
    let fileExtension: String
    let displayName: String
}

enum DefaultSettings {
    static let durations: [MeditationDuration] = [5, 10, 15, 20, 30].map { MeditationDuration(minutes: $0) }

    static let tracks: [MusicTrack] = [
        MusicTrack(fileName: "OceanWaves", fileExtension: "mp3", displayName: "Ocean Waves"),
        MusicTrack(fileName: "Rain", fileExtension: "mp3", displayName: "Rain"),
        MusicTrack(fileName: "Forest", fileExtension: "mp3", displayName: "Forest")
    ]
}