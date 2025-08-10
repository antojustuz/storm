import SwiftUI

struct SoundPickerView: View {
    @Binding var selectedSound: BackgroundSound

    var body: some View {
        NavigationStack {
            List {
                ForEach(BackgroundSound.allCases) { sound in
                    HStack {
                        Text(sound.displayName)
                        Spacer()
                        if sound == selectedSound {
                            Image(systemName: "checkmark").foregroundStyle(.accent)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { selectedSound = sound }
                }
            }
            .navigationTitle("Choose Sound")
        }
    }
}

#Preview {
    SoundPickerView(selectedSound: .constant(.rain))
}