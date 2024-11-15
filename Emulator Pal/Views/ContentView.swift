import SwiftUI

struct ContentView: View {
    @State var contentSize = CGSize.zero
    @Binding var keepOnTop: Bool
    
    @State private var conversionModel = ConversionViewModel()
    @State private var mathModel = MathViewModel()
    @State private var binaryManipulationModel = BinaryManipulationViewModel()
    
    var body: some View {
        VStack(spacing: 3) {
            ConversionView(model: conversionModel, keepOnTop: $keepOnTop)
            
            Divider()
            
            MathView(model: mathModel)
            
            Divider()
            
            BinaryManipulationView(model: binaryManipulationModel)
        }
        .padding(.vertical)
        .font(.body)
        .frame(minWidth: 350, minHeight: contentSize.height)
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.size, initial: true) {
                        contentSize = geometry.size
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var isOnTop = false
    
    ContentView(keepOnTop: $isOnTop)
}
