import SwiftUI

struct ContentHeader<Content, AdditionalHeaderContent>: View where Content: View, AdditionalHeaderContent: View {
    let title: LocalizedStringKey
    let additionalHeaderContent: () -> AdditionalHeaderContent
    let content: () -> Content
    
    init(_ title: LocalizedStringKey, @ViewBuilder additionalHeaderContent: @escaping () -> AdditionalHeaderContent, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.additionalHeaderContent = additionalHeaderContent
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.title)
                
                Spacer()
                
                additionalHeaderContent()
            }
            
            content()
        }
    }
}

extension ContentHeader where AdditionalHeaderContent == EmptyView {
    init(_ title: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        self.init(title, additionalHeaderContent: { EmptyView() }, content: content)
    }
}

#Preview {
    VStack {
        ContentHeader("Programming") {
            Toggle("Hello There", isOn: .constant(true))
        } content: {
            HStack {
                Text("Hello,")
                
                Text("World!")
            }
            
            Text("Wow")
        }
        
        ContentHeader("Red") {
            Color.red
        }
    }
}
