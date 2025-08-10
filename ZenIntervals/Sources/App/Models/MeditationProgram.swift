import Foundation

enum BackgroundSound: String, CaseIterable, Codable, Identifiable, Equatable {
    case silence
    case ocean
    case rain
    case forest
    case whiteNoise

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .silence: return "Silence"
        case .ocean: return "Ocean Waves"
        case .rain: return "Rain"
        case .forest: return "Forest"
        case .whiteNoise: return "White Noise"
        }
    }

    /// File name inside the app bundle. Return nil to indicate no background audio.
    var fileName: String? {
        switch self {
        case .silence: return nil
        case .ocean: return "ocean.wav"
        case .rain: return "rain.wav"
        case .forest: return "forest.wav"
        case .whiteNoise: return "white_noise.wav"
        }
    }
}

struct MeditationProgram: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var intervals: [IntervalItem]
    var backgroundSound: BackgroundSound
    var backgroundVolume: Float

    init(
        id: UUID = UUID(),
        name: String,
        intervals: [IntervalItem],
        backgroundSound: BackgroundSound = .silence,
        backgroundVolume: Float = 0.4
    ) {
        self.id = id
        self.name = name
        self.intervals = intervals
        self.backgroundSound = backgroundSound
        self.backgroundVolume = max(0, min(1, backgroundVolume))
    }

    var totalDurationSeconds: Int {
        intervals.reduce(0) { $0 + $1.durationSeconds }
    }
}

extension MeditationProgram {
    static func calmBreathPreset() -> MeditationProgram {
        MeditationProgram(
            name: "Calm Breathing",
            intervals: [
                IntervalItem(name: "Settle", durationSeconds: 60, bellEnabled: true),
                IntervalItem(name: "Breathe", durationSeconds: 8 * 60, bellEnabled: true),
                IntervalItem(name: "Reflect", durationSeconds: 60, bellEnabled: true)
            ],
            backgroundSound: .rain,
            backgroundVolume: 0.35
        )
    }

    static func pomodoroPreset() -> MeditationProgram {
        MeditationProgram(
            name: "Pomodoro",
            intervals: [
                IntervalItem(name: "Focus", durationSeconds: 25 * 60, bellEnabled: true),
                IntervalItem(name: "Break", durationSeconds: 5 * 60, bellEnabled: true)
            ],
            backgroundSound: .whiteNoise,
            backgroundVolume: 0.3
        )
    }
}