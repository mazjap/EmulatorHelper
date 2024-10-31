import SwiftUI

@main
struct Emulator_TranslationApp: App {
    @AppStorage("floating_window") private var keepOnTop = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(keepOnTop: $keepOnTop)
                .onAppear {
                    NSPasteboard.general.declareTypes([.string], owner: self)
                }
        }
        .windowResizability(.contentMinSize)
        .windowLevel(keepOnTop ? .floating : .normal)
    }
}
