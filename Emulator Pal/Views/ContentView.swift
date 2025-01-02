import SwiftUI

struct ContentView: View {
    @State private var conversionModel = ConversionViewModel()
    @State private var mathModel = MathViewModel()
    @State private var binaryManipulationModel = BinaryManipulationViewModel()
    @State private var contentSize = CGSize.zero
    
    var body: some View {
        VStack(spacing: 3) {
            ConversionView(model: conversionModel)
            
            Divider()
            
            MathView(model: mathModel)
            
            Divider()
            
            BinaryManipulationView(model: binaryManipulationModel)
        }
        .padding(.bottom)
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
    ContentView()
        .environment(AppSettingsViewModel(keepWindowOnTopDefaultValue: true))
}
