import Foundation

extension UserDefaults {
    func bool(usingKey key: String, defaultValue: Bool) -> Bool {
        if let storedValue = bool(usingKey: key) {
            return storedValue
        } else {
            setValue(defaultValue, forKey: key)
            return defaultValue
        }
    }
    
    func bool(usingKey key: String) -> Bool? {
        object(forKey: key) as? Bool
    }
}
