import SwiftUI

struct HomeView: View {
    @State private var program: MeditationProgram = .calmBreathPreset()
    @State private var isPresentingSession: Bool = false
    @State private var showSoundPicker: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                List {
                    Section(header: Text("Intervals")) {
                        ForEach($program.intervals) { $interval in
                            HStack(spacing: 12) {
                                TextField("Name", text: $interval.name)
                                    .textFieldStyle(.roundedBorder)
                                Spacer(minLength: 8)
                                Stepper(value: $interval.durationSeconds, in: 1...(60 * 120)) {
                                    Text("\(interval.durationSeconds / 60)m \(interval.durationSeconds % 60)s")
                                        .monospacedDigit()
                                }
                            }
                        }
                        .onDelete { indexSet in
                            program.intervals.remove(atOffsets: indexSet)
                        }
                        .onMove { from, to in
                            program.intervals.move(fromOffsets: from, toOffset: to)
                        }

                        Button {
                            program.intervals.append(IntervalItem(name: "New Interval", durationSeconds: 60))
                        } label: {
                            Label("Add Interval", systemImage: "plus.circle.fill")
                        }
                    }

                    Section(header: Text("Background")) {
                        HStack {
                            Text("Sound")
                            Spacer()
                            Button(program.backgroundSound.displayName) {
                                showSoundPicker = true
                            }
                            .buttonStyle(.bordered)
                        }
                        HStack {
                            Text("Volume")
                            Slider(
                                value: Binding(
                                    get: { Double(program.backgroundVolume) },
                                    set: { program.backgroundVolume = Float($0) }
                                ),
                                in: 0...1
                            )
                        }
                    }

                    Section(header: Text("Presets")) {
                        Button("Calm Breathing") { program = .calmBreathPreset() }
                        Button("Pomodoro 25–5") { program = .pomodoroPreset() }
                    }
                }
                .listStyle(.insetGrouped)
                .toolbar { EditButton() }

                Button {
                    isPresentingSession = true
                } label: {
                    Text("Start Session")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .navigationTitle("Zen Intervals")
            .sheet(isPresented: $showSoundPicker) {
                SoundPickerView(selectedSound: $program.backgroundSound)
            }
            .navigationDestination(isPresented: $isPresentingSession) {
                SessionView(viewModel: SessionViewModel(program: program))
            }
        }
    }
}

#Preview {
    HomeView()
}