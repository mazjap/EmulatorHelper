import SwiftUI

@main
struct EmulatorPalApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var settingsModel = AppSettingsViewModel(keepWindowOnTopDefaultValue: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView(keepOnTop: $settingsModel.keepWindowOnTop)
                .onAppear {
                    NSPasteboard.general.declareTypes([.string], owner: appDelegate)
                }
        }
        .windowResizability(.contentSize)
        .windowLevel(settingsModel.keepWindowOnTop ? .floating : .normal)
    }
}
