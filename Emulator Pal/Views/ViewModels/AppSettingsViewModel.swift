import Foundation

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
        }
    }
    
    init(keepWindowOnTopDefaultValue: Bool) {
        self.keepWindowOnTop = userDefaults.bool(
            usingKey: AppSettingsKey.keepWindowOnTop.rawValue,
            defaultValue: keepWindowOnTopDefaultValue
        )
    }
}
