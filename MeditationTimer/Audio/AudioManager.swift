import Foundation
import AVFoundation

final class AudioManager {
    static let shared = AudioManager()

    private let audioSession = AVAudioSession.sharedInstance()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func configureSession() {
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Audio session configuration failed: \(error)")
        }
    }

    func play(track: MusicTrack?) {
        guard let track = track else { return }
        configureSession()

        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: track.fileExtension) else {
            print("Audio file not found in bundle: \(track.fileName).\(track.fileExtension)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
            audioPlayer = player
        } catch {
            print("Failed to play audio: \(error)")
        }
    }

    func pause() {
        audioPlayer?.pause()
    }

    func resume() {
        audioPlayer?.play()
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            // no-op
        }
    }
}