import Foundation
import AVFoundation

final class AudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    func startBackgroundMusic() {
        guard audioPlayer == nil || audioPlayer?.isPlaying == false else { return }
        guard let url = Bundle.main.url(forResource: "meditation", withExtension: "mp3") else {
            print("Missing meditation.mp3 in bundle")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.5
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Audio playback error: \(error)")
        }
    }

    func pauseBackgroundMusic() {
        audioPlayer?.pause()
    }

    func resumeBackgroundMusic() {
        audioPlayer?.play()
    }

    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}