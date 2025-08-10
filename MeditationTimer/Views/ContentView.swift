import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: MeditationViewModel

    init(viewModel: MeditationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Meditation")
                .font(.largeTitle).bold()

            VStack(alignment: .leading, spacing: 12) {
                Text("Duration")
                    .font(.headline)
                Picker("Duration", selection: $viewModel.selectedDuration) {
                    ForEach(viewModel.availableDurations) { duration in
                        Text(duration.label).tag(duration)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(viewModel.isRunning)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Music")
                    .font(.headline)
                Picker("Music", selection: $viewModel.selectedTrack) {
                    Text("None").tag(MusicTrack?.none)
                    ForEach(viewModel.availableTracks) { track in
                        Text(track.displayName).tag(MusicTrack?.some(track))
                    }
                }
                .pickerStyle(.navigationLink)
                .disabled(viewModel.isRunning)
            }

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 14)
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.purple, .blue]), center: .center), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.25), value: viewModel.progress)

                VStack(spacing: 8) {
                    Text(formatSecondsAsMMSS(viewModel.remainingSeconds))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text(viewModel.isRunning ? (viewModel.isPaused ? "Paused" : "In Progress") : "Ready")
                        .foregroundColor(.secondary)
                }
            }
            .frame(height: 260)
            .padding(.top, 8)

            HStack(spacing: 16) {
                if !viewModel.isRunning {
                    Button(action: viewModel.start) {
                        Label("Start", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    if viewModel.isPaused {
                        Button(action: viewModel.resume) {
                            Label("Resume", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button(action: viewModel.pause) {
                            Label("Pause", systemImage: "pause.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                    Button(role: .destructive, action: viewModel.reset) {
                        Label("Reset", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }

            Spacer(minLength: 0)
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: MeditationViewModel())
}