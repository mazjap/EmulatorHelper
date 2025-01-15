import AppKit

enum AppSettingsKey: String {
    case keepWindowOnTop = "floating_window"
}

@Observable
@MainActor
class AppSettingsViewModel {
    private let userDefaults = UserDefaults.standard
    
    var keepWindowOnTop: Bool {
        didSet {
            userDefaults.set(keepWindowOnTop, forKey: AppSettingsKey.keepWindowOnTop.rawValue)
            updateWindowLevel()
        }
    }
    
    init(keepWindowOnTopDefaultValue: Bool) {
        self.keepWindowOnTop = userDefaults.bool(
            usingKey: AppSettingsKey.keepWindowOnTop.rawValue,
            defaultValue: keepWindowOnTopDefaultValue
        )
        
        // Not ideal, but setting the window level
        // doesn't stick without some delay
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            updateWindowLevel()
        }
    }
    
    private func updateWindowLevel() {
        if let window = NSApplication.shared.windows.first {
            window.level = self.keepWindowOnTop ? .floating : .normal
        }
    }
}
