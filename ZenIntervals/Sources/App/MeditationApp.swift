import SwiftUI

@main
struct ZenIntervalsApp: App {
    @StateObject private var audioManager = AudioManager.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(audioManager)
        }
    }
}