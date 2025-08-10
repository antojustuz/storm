# Meditation Timer (iOS, SwiftUI)

A simple meditation timer with:
- Countdown timer with selectable duration
- One-tap pause for 5 or 10 minutes (auto-resume)
- Background meditation music playback (loops)
- Local notifications for session end and pause-resume reminders

## Requirements
- Xcode 15+ (iOS 16 target by default)
- A Mac to build and run the app on a simulator or device

## Project Setup
1. Open Xcode and create a new project:
   - iOS > App
   - Product Name: MeditationTimer
   - Interface: SwiftUI
   - Language: Swift
   - Uncheck Core Data / Tests if you don’t need them

2. In the new project, create these groups to mirror the folder structure below:
   - `App`
   - `Views`
   - `ViewModels`
   - `Managers`
   - `Resources`

3. Copy files from this repo into your Xcode project:
   - `App/MeditationTimerApp.swift`
   - `Views/ContentView.swift`
   - `ViewModels/TimerViewModel.swift`
   - `Managers/AudioManager.swift`
   - `Managers/LocalNotificationManager.swift`
   - `Resources/meditation.mp3` (add your own audio file named exactly `meditation.mp3`)

4. Enable background audio in Xcode:
   - Select your app target > Signing & Capabilities > + Capability > Background Modes
   - Check: `Audio, AirPlay, and Picture in Picture`

5. App permissions:
   - Local notifications: The app requests authorization on first launch. No Info.plist key is required for local notifications.

6. Build & Run
   - Choose an iOS Simulator (or a physical device) and Run.

## How it works
- Choose a duration (e.g., 10/15/20/30/45/60 minutes) and press Start.
- Music starts and loops in the background.
- Use `Pause 5m` or `Pause 10m` to pause the session and auto-resume after that interval. Music is paused during the pause and resumes automatically.
- You will receive a local notification when the session ends or a pause finishes (if the app is in the background).

## Customizations
- Replace `Resources/meditation.mp3` with your track.
- Edit default durations in `ContentView.swift`.
- Change audio behavior (e.g., mix with other audio) via `AudioManager.swift`.

## Folder Structure
```
MeditationTimer/
  App/
    MeditationTimerApp.swift
  Views/
    ContentView.swift
  ViewModels/
    TimerViewModel.swift
  Managers/
    AudioManager.swift
    LocalNotificationManager.swift
  Resources/
    meditation.mp3  (add your own file)
```

## Notes
- Timers can be throttled in background. This app keeps audio playing in the background to maintain better timing fidelity and also re-computes remaining time on resume to stay accurate.
- Background execution is best-effort; iOS may still suspend under certain conditions. Local notifications are used as a fallback for user awareness.