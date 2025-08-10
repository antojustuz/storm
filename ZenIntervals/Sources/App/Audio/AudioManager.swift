import Foundation
import AVFAudio
import AudioToolbox

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private init() {}

    private var backgroundPlayer: AVAudioPlayer?
    private var bellPlayer: AVAudioPlayer?

    @Published var isSessionConfigured: Bool = false

    func configureSession() {
        guard !isSessionConfigured else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            isSessionConfigured = true
        } catch {
            print("[Audio] Session configuration failed: \(error)")
        }
    }

    func playBackground(sound: BackgroundSound, volume: Float) {
        guard let fileName = sound.fileName else {
            stopBackground()
            return
        }
        configureSession()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("[Audio] Background file not found: \(fileName)")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = max(0, min(1, volume))
            player.prepareToPlay()
            player.play()
            backgroundPlayer = player
        } catch {
            print("[Audio] Failed to start background: \(error)")
        }
    }

    func setBackgroundVolume(_ volume: Float) {
        backgroundPlayer?.volume = max(0, min(1, volume))
    }

    func stopBackground() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }

    func playBell() {
        if let url = Bundle.main.url(forResource: "bell.wav", withExtension: nil) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = 1.0
                player.prepareToPlay()
                player.play()
                bellPlayer = player
                return
            } catch {
                print("[Audio] Bell playback failed: \(error)")
            }
        }
        // Fallback to system sound if bundled bell is missing
        AudioServicesPlaySystemSound(1005)
    }
}