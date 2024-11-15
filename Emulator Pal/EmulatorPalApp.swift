import SwiftUI

@main
struct EmulatorPalApp: App {
    @AppStorage("floating_window") private var keepOnTop = true
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(keepOnTop: $keepOnTop)
                .onAppear {
                    NSPasteboard.general.declareTypes([.string], owner: appDelegate)
                }
        }
        .windowResizability(.contentSize)
        .windowLevel(keepOnTop ? .floating : .normal)
    }
}
