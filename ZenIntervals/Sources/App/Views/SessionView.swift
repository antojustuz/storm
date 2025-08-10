import SwiftUI
import UIKit

struct SessionView: View {
    @ObservedObject var viewModel: SessionViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.currentInterval?.name ?? viewModel.program.name)
                .font(.title2)
                .foregroundStyle(.secondary)

            Text(SessionViewModel.format(seconds: viewModel.remainingSeconds))
                .font(.system(size: 72, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .padding(.top, 12)

            if let next = viewModel.nextInterval {
                Label("Next: \(next.name) • \(SessionViewModel.format(seconds: next.durationSeconds))", systemImage: "forward.end")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 24) {
                Button { viewModel.skipToPrevious() } label: {
                    Image(systemName: "backward.fill").font(.title2)
                }

                Button {
                    if viewModel.isRunning { viewModel.pause() } else { viewModel.start() }
                } label: {
                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .padding()
                }
                .buttonStyle(.borderedProminent)

                Button { viewModel.skipToNext() } label: {
                    Image(systemName: "forward.fill").font(.title2)
                }
            }

            Button {
                viewModel.reset()
                dismiss()
            } label: {
                Text("End Session").foregroundStyle(.red)
            }
            .padding(.top, 16)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            if !viewModel.isRunning && !viewModel.isCompleted {
                viewModel.start()
            }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            viewModel.pause()
        }
        .background(
            LinearGradient(colors: [.indigo.opacity(0.2), .mint.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SessionView(viewModel: SessionViewModel(program: .calmBreathPreset()))
}