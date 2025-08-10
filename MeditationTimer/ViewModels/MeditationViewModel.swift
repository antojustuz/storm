import Foundation
import Combine
import SwiftUI

final class MeditationViewModel: ObservableObject {
    // MARK: - Published State
    @Published var availableDurations: [MeditationDuration] = DefaultSettings.durations
    @Published var availableTracks: [MusicTrack] = DefaultSettings.tracks

    @Published var selectedDuration: MeditationDuration
    @Published var selectedTrack: MusicTrack?

    @Published var remainingSeconds: Int
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var progress: Double = 0.0 // 0.0 ... 1.0

    // MARK: - Private
    private var timerCancellable: AnyCancellable?
    private var targetEndDate: Date?

    // MARK: - Init
    init() {
        let initialDuration = DefaultSettings.durations.first ?? MeditationDuration(minutes: 5)
        self.selectedDuration = initialDuration
        self.remainingSeconds = initialDuration.seconds
        self.selectedTrack = nil
    }

    // MARK: - Intent
    func start() {
        guard !isRunning else { return }
        isRunning = true
        isPaused = false
        remainingSeconds = selectedDuration.seconds
        progress = 0
        targetEndDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))

        AudioManager.shared.play(track: selectedTrack)
        startTicking()
    }

    func pause() {
        guard isRunning, !isPaused else { return }
        isPaused = true
        snapshotRemainingFromTargetEndDate()
        stopTicking()
        AudioManager.shared.pause()
    }

    func resume() {
        guard isRunning, isPaused else { return }
        isPaused = false
        targetEndDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        startTicking()
        AudioManager.shared.resume()
    }

    func reset() {
        stopTicking()
        isRunning = false
        isPaused = false
        remainingSeconds = selectedDuration.seconds
        progress = 0
        targetEndDate = nil
        AudioManager.shared.stop()
    }

    // MARK: - Timer
    private func startTicking() {
        stopTicking()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func stopTicking() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func tick() {
        guard isRunning, !isPaused else { return }
        guard let end = targetEndDate else { return }

        let now = Date()
        let secondsLeft = max(0, Int(ceil(end.timeIntervalSince(now))))
        remainingSeconds = secondsLeft

        let total = max(1, selectedDuration.seconds)
        progress = 1 - (Double(remainingSeconds) / Double(total))

        if secondsLeft <= 0 {
            finish()
        }
    }

    private func snapshotRemainingFromTargetEndDate() {
        guard let end = targetEndDate else { return }
        remainingSeconds = max(0, Int(ceil(end.timeIntervalSinceNow)))
        targetEndDate = nil
    }

    private func finish() {
        stopTicking()
        isRunning = false
        isPaused = false
        remainingSeconds = 0
        progress = 1
        targetEndDate = nil
        AudioManager.shared.stop()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}