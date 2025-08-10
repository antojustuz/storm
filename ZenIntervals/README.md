# Zen Intervals — iOS Meditation Timer

A beautiful SwiftUI meditation timer with customizable intervals and background sounds.

## Features
- Custom interval sequences (add/remove/reorder)
- Presets (Calm Breathing, Pomodoro)
- Background audio: ocean, rain, forest, white noise, or silence
- Optional bell at interval transitions
- Clean, modern SwiftUI UI with big timer and controls

## Requirements
- Xcode 15+
- iOS 16+

## Project Setup (Xcode)
1. Open Xcode and create a new iOS App project (SwiftUI, Swift). Name it `ZenIntervals` (or any name you prefer).
2. Quit Xcode for a moment. In Finder, locate your new project folder.
3. Copy the `Sources` and `Resources` folders from this repository's `ZenIntervals` directory into your Xcode project folder (same level as your `.xcodeproj`).
4. Reopen the project in Xcode. In the Project Navigator, right-click your app target group and choose:
   - Add Files to "YourApp" → add all files from `Sources` and `Resources` (ensure "Copy items if needed" is checked).
5. In your app's General settings, set the minimum iOS to 16.0 (or later).
6. Capabilities → enable Background Modes → check `Audio, AirPlay, and Picture in Picture`.
7. Add audio files to the target (see below). Build and run on a device or simulator.

## Audio Files
Place these files in `Resources/Audio/` and add them to the app target in Xcode. You can use your own recordings or royalty-free sounds with the exact names:
- `ocean.wav`
- `rain.wav`
- `forest.wav`
- `white_noise.wav`
- `bell.wav` (short chime for interval transitions)

Notes:
- You can use `.mp3` instead; update `BackgroundSound.fileName` accordingly.
- The app gracefully handles missing files by logging and falling back to a system sound for the bell.

## App Structure
- `Sources/App/MeditationApp.swift`: App entry point
- `Sources/App/Models/*`: Data models (`IntervalItem`, `MeditationProgram`, `BackgroundSound`)
- `Sources/App/Audio/AudioManager.swift`: Background playback and bell
- `Sources/App/ViewModels/SessionViewModel.swift`: Timer and session logic
- `Sources/App/Views/*`: SwiftUI screens

## Customization Tips
- Add more presets in `MeditationProgram`.
- Extend `BackgroundSound` with your own tracks.
- Adjust UI styling in `HomeView` and `SessionView`.

## Known Limitations
- When the app is in the background, interval timers do not continue counting down precisely without additional background strategies. This starter relies on foreground usage with background audio enabled. For more advanced behavior, consider local notifications or background tasks.

## License
MIT