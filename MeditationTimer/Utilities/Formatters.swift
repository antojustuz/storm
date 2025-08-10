import Foundation

func formatSecondsAsMMSS(_ seconds: Int) -> String {
    let clamped = max(0, seconds)
    let minutes = clamped / 60
    let seconds = clamped % 60
    return String(format: "%02d:%02d", minutes, seconds)
}