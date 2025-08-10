import SwiftUI

@main
struct MeditationTimerApp: App {
    @StateObject private var audioManager = AudioManager()
    @StateObject private var notificationManager = LocalNotificationManager()
    @StateObject private var timerViewModel = TimerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .environmentObject(notificationManager)
                .environmentObject(timerViewModel)
                .onAppear {
                    notificationManager.requestAuthorization()
                    timerViewModel.configure(audioManager: audioManager, notificationManager: notificationManager)
                }
        }
    }
}