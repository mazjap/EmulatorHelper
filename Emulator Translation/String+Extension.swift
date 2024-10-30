extension String {
    func withoutPrefix(_ prefix: String) -> String {
        if hasPrefix(prefix) {
            return String(self[index(startIndex, offsetBy: prefix.count)...])
        }
        
        return self
    }
}
