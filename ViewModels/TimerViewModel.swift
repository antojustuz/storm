import Foundation
import Combine

final class TimerViewModel: ObservableObject {
    enum SessionState {
        case idle
        case running(endDate: Date)
        case paused(remaining: TimeInterval, resumeDate: Date)
        case finished
    }

    @Published var sessionState: SessionState = .idle
    @Published var remainingDisplay: String = "00:00"
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false

    private var ticker: AnyCancellable?

    // Dependencies
    private var audioManagerRef: AudioManager?
    private var notificationManagerRef: LocalNotificationManager?

    // Notification identifiers
    let endNotificationId = "meditation.end"
    let pauseResumeNotificationId = "meditation.resume"

    func configure(audioManager: AudioManager, notificationManager: LocalNotificationManager) {
        self.audioManagerRef = audioManager
        self.notificationManagerRef = notificationManager
    }

    func start(minutes: Int) {
        guard let audioManager = audioManagerRef, let notificationManager = notificationManagerRef else { return }
        let duration: TimeInterval = TimeInterval(minutes * 60)
        let endDate = Date().addingTimeInterval(duration)
        sessionState = .running(endDate: endDate)
        isRunning = true
        isPaused = false
        audioManager.startBackgroundMusic()
        scheduleEndNotification(endDate: endDate, notificationManager: notificationManager)
        startTicker()
    }

    func cancel() {
        guard let notificationManager = notificationManagerRef, let audioManager = audioManagerRef else { return }
        sessionState = .idle
        isRunning = false
        isPaused = false
        stopTicker()
        notificationManager.cancelAll()
        audioManager.stopBackgroundMusic()
        remainingDisplay = "00:00"
    }

    func pauseForFiveMinutes() {
        pauseFor(minutes: 5)
    }

    func pauseForTenMinutes() {
        pauseFor(minutes: 10)
    }

    private func pauseFor(minutes: Int) {
        guard case let .running(endDate) = sessionState else { return }
        guard let notificationManager = notificationManagerRef, let audioManager = audioManagerRef else { return }
        let remaining = max(0, endDate.timeIntervalSinceNow)
        let resumeDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
        sessionState = .paused(remaining: remaining, resumeDate: resumeDate)
        isPaused = true
        stopTicker()
        audioManager.pauseBackgroundMusic()
        // Cancel end notification and schedule resume reminder
        notificationManager.cancelNotification(id: endNotificationId)
        notificationManager.scheduleNotification(
            id: pauseResumeNotificationId,
            title: "Pause ended",
            body: "Your meditation will resume now.",
            fireAt: resumeDate
        )
        startTicker() // to update UI countdown for pause
    }

    func resumeAfterPause() {
        guard case let .paused(remaining, _) = sessionState else { return }
        guard let audioManager = audioManagerRef, let notificationManager = notificationManagerRef else { return }
        let newEndDate = Date().addingTimeInterval(remaining)
        sessionState = .running(endDate: newEndDate)
        isPaused = false
        audioManager.resumeBackgroundMusic()
        notificationManager.cancelNotification(id: pauseResumeNotificationId)
        scheduleEndNotification(endDate: newEndDate, notificationManager: notificationManager)
    }

    private func scheduleEndNotification(endDate: Date, notificationManager: LocalNotificationManager) {
        notificationManager.scheduleNotification(
            id: endNotificationId,
            title: "Session complete",
            body: "Your meditation session has ended.",
            fireAt: endDate
        )
    }

    private func startTicker() {
        stopTicker()
        ticker = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func stopTicker() {
        ticker?.cancel()
        ticker = nil
    }

    private func tick() {
        switch sessionState {
        case .idle:
            remainingDisplay = "00:00"
            isRunning = false
        case .running(let endDate):
            let remaining = max(0, endDate.timeIntervalSinceNow)
            remainingDisplay = Self.format(time: remaining)
            isRunning = true
            if remaining <= 0 {
                sessionState = .finished
                isRunning = false
                stopTicker()
                audioManagerRef?.stopBackgroundMusic()
                remainingDisplay = "00:00"
            }
        case .paused(let remaining, let resumeDate):
            let untilResume = max(0, resumeDate.timeIntervalSinceNow)
            remainingDisplay = "Pause: " + Self.format(time: untilResume)
            if untilResume <= 0 {
                // Auto-resume
                resumeAfterPause()
            }
        case .finished:
            isRunning = false
        }
    }

    static func format(time: TimeInterval) -> String {
        let total = Int(time)
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}