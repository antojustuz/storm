import Foundation
import Combine

final class SessionViewModel: ObservableObject {
    @Published var program: MeditationProgram
    @Published var currentIntervalIndex: Int = 0
    @Published var remainingSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false

    private var timerCancellable: AnyCancellable?
    private var tickPublisher = Timer.publish(every: 1, on: .main, in: .common)

    init(program: MeditationProgram) {
        self.program = program
        self.remainingSeconds = program.intervals.first?.durationSeconds ?? 0
    }

    var currentInterval: IntervalItem? {
        guard currentIntervalIndex < program.intervals.count else { return nil }
        return program.intervals[currentIntervalIndex]
    }

    var nextInterval: IntervalItem? {
        guard currentIntervalIndex + 1 < program.intervals.count else { return nil }
        return program.intervals[currentIntervalIndex + 1]
    }

    func start() {
        guard !isRunning else { return }
        isCompleted = false
        AudioManager.shared.playBackground(sound: program.backgroundSound, volume: program.backgroundVolume)
        AudioManager.shared.configureSession()
        isRunning = true
        tickPublisher = Timer.publish(every: 1, on: .main, in: .common)
        timerCancellable = tickPublisher.autoconnect().sink { [weak self] _ in
            self?.tick()
        }
    }

    func pause() {
        isRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func reset() {
        pause()
        currentIntervalIndex = 0
        remainingSeconds = program.intervals.first?.durationSeconds ?? 0
        isCompleted = false
        AudioManager.shared.stopBackground()
    }

    func skipToNext() {
        guard currentIntervalIndex + 1 < program.intervals.count else {
            finish()
            return
        }
        currentIntervalIndex += 1
        remainingSeconds = program.intervals[currentIntervalIndex].durationSeconds
        AudioManager.shared.playBell()
    }

    func skipToPrevious() {
        guard currentIntervalIndex > 0 else { return }
        currentIntervalIndex -= 1
        remainingSeconds = program.intervals[currentIntervalIndex].durationSeconds
    }

    private func tick() {
        guard isRunning else { return }
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            return
        }
        if currentInterval?.bellEnabled == true {
            AudioManager.shared.playBell()
        }
        if currentIntervalIndex + 1 < program.intervals.count {
            currentIntervalIndex += 1
            remainingSeconds = program.intervals[currentIntervalIndex].durationSeconds
        } else {
            finish()
        }
    }

    private func finish() {
        isRunning = false
        isCompleted = true
        timerCancellable?.cancel()
        timerCancellable = nil
        AudioManager.shared.stopBackground()
    }

    static func format(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}