import SwiftUI

@main
struct Emulator_TranslationApp: App {
    @AppStorage("floating_window") private var keepOnTop = true
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(keepOnTop: $keepOnTop)
                .onAppear {
                    NSPasteboard.general.declareTypes([.string], owner: self)
                }
        }
        .windowResizability(.contentSize)
        .windowLevel(keepOnTop ? .floating : .normal)
    }
}
