# MeditationTimer (iOS, SwiftUI)

Minimal meditation timer with preset durations (5, 10, 15, 20, 30 minutes), optional looping background music, pause/resume, progress ring, and large countdown.

## Features
- Preset durations via segmented control
- Optional looping background sound (e.g., Ocean Waves, Rain, Forest)
- Start, Pause, Resume, Reset controls
- Progress ring and MM:SS countdown
- Works when screen is locked (enable background audio)

## Project structure
- `MeditationTimerApp.swift`: App entry point
- `Views/ContentView.swift`: Main UI
- `ViewModels/MeditationViewModel.swift`: Timer logic and state
- `Audio/AudioManager.swift`: AVAudioPlayer-based looping playback
- `Models/MeditationSettings.swift`: Duration and track models + defaults
- `Utilities/Formatters.swift`: Time formatting helper

## Getting started
1. Open the folder in Xcode and create a new iOS App project named "MeditationTimer" using SwiftUI and Swift.
2. Replace the auto-generated files with the ones in this folder, or add these files to your project target.
3. Add audio files to your app bundle for the default tracks:
   - `OceanWaves.mp3`
   - `Rain.mp3`
   - `Forest.mp3`

   You can change the list in `Models/MeditationSettings.swift` or add more.

4. Enable background audio (so music continues with the screen locked):
   - In Xcode target > Signing & Capabilities > + Capability > Background Modes
   - Check "Audio, AirPlay, and Picture in Picture"

5. Build & run on a device. Start a session, pick a track, lock the screen if you like.

## Notes
- If you don't add the audio files, the app will compile, but music playback will be skipped (with a log message).
- You can disable/enable mixing with other audio in `AudioManager.configureSession()` by adjusting the `.mixWithOthers` option.
- To support custom durations, add more items to `DefaultSettings.durations` or replace with a text field/stepper.

## Minimum requirements
- iOS 16+
- Xcode 15+