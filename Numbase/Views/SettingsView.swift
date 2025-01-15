import SwiftUI

struct FloatingToggle: View {
    @Environment(AppSettingsViewModel.self) private var settingsModel
    
    var body: some View {
        Toggle(isOn: Bindable(settingsModel).keepWindowOnTop) {
            Text("Floating Window")
        }
    }
}

#Preview {
    FloatingToggle()
        .environment(AppSettingsViewModel(keepWindowOnTopDefaultValue: true))
}
