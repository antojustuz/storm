import Foundation

struct IntervalItem: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var durationSeconds: Int
    var bellEnabled: Bool

    init(id: UUID = UUID(), name: String, durationSeconds: Int, bellEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.durationSeconds = max(1, durationSeconds)
        self.bellEnabled = bellEnabled
    }
}