import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var notificationManager: LocalNotificationManager
    @EnvironmentObject var timerViewModel: TimerViewModel

    @State private var selectedMinutes: Int = 15
    private let presetDurations: [Int] = [10, 15, 20, 30, 45, 60]

    var body: some View {
        VStack(spacing: 24) {
            Text("Meditation Timer")
                .font(.largeTitle).bold()

            Text(timerViewModel.remainingDisplay)
                .font(.system(size: 48, weight: .medium, design: .rounded))
                .monospacedDigit()

            Picker("Duration", selection: $selectedMinutes) {
                ForEach(presetDurations, id: \.self) { minutes in
                    Text("\(minutes) min").tag(minutes)
                }
            }
            .pickerStyle(.segmented)
            .disabled(timerViewModel.isRunning && !timerViewModel.isPaused)

            HStack(spacing: 16) {
                Button(action: startOrStop) {
                    Text(timerViewModel.isRunning ? "Stop" : "Start")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button("Pause 5m") {
                    timerViewModel.pauseForFiveMinutes()
                }
                .disabled(!(timerViewModel.isRunning && !timerViewModel.isPaused))

                Button("Pause 10m") {
                    timerViewModel.pauseForTenMinutes()
                }
                .disabled(!(timerViewModel.isRunning && !timerViewModel.isPaused))
            }

            if timerViewModel.isPaused {
                Button("Resume now") {
                    timerViewModel.resumeAfterPause()
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            timerViewModel.configure(audioManager: audioManager, notificationManager: notificationManager)
        }
    }

    private func startOrStop() {
        if timerViewModel.isRunning {
            timerViewModel.cancel()
        } else {
            timerViewModel.start(minutes: selectedMinutes)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AudioManager())
        .environmentObject(LocalNotificationManager())
        .environmentObject(TimerViewModel())
}