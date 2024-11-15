import SwiftUI

struct CopyButton: View {
    let textToCopy: String
    
    var body: some View {
        Button {
            let pasteboard = NSPasteboard.general
            
            pasteboard.prepareForNewContents()
            
            let successfulCopy = pasteboard.setString(textToCopy, forType: .string)
            
            if !successfulCopy {
                NSLog("Failed to copy \"\(textToCopy)\" to clipboard")
            }
        } label: {
            Image(systemName: "document.on.document")
        }
    }
}

#Preview {
    CopyButton(textToCopy: "Hello, World!")
        .onAppear {
            NSPasteboard.general.declareTypes([.string], owner: nil)
        }
}
