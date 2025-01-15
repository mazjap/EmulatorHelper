import AppKit

@discardableResult
func copyToClipboard(_ textToCopy: String) -> Bool {
    let pasteboard = NSPasteboard.general
    
    pasteboard.prepareForNewContents()
    
    let successfulCopy = pasteboard.setString(textToCopy, forType: .string)
    
    if !successfulCopy {
        NSLog("Failed to copy \"\(textToCopy)\" to clipboard")
    }
    
    return successfulCopy
}
