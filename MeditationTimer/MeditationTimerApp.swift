import SwiftUI

@main
struct MeditationTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MeditationViewModel())
        }
    }
}