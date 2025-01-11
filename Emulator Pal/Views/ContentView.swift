import SwiftUI

struct ContentView: View {
    @State private var conversionModel = ConversionViewModel()
    @State private var mathModel = MathViewModel()
    @State private var binaryManipulationModel = BinaryManipulationViewModel()
    @State private var contentSize = CGSize.zero
    
    @FocusState private var conversionField: ConversionView.Field?
    @FocusState private var mathField: MathView.Field?
    @FocusState private var binaryManipulationField: BinaryManipulationView.Field?
    
    var body: some View {
        VStack(spacing: 3) {
            ConversionView(model: conversionModel, focusedField: $conversionField)
            
            Divider()
            
            MathView(model: mathModel, focusedField: $mathField)
            
            Divider()
            
            BinaryManipulationView(model: binaryManipulationModel, focusedField: $binaryManipulationField)
        }
        .padding(.bottom)
        .font(.body)
        .frame(minWidth: 350, minHeight: contentSize.height)
        .background {
            GeometryReader { geometry in
                Color(NSColor.windowBackgroundColor)
                    .onChange(of: geometry.size, initial: true) {
                        contentSize = geometry.size
                    }
                    .onTapGesture {
                        conversionField = nil
                        mathField = nil
                        binaryManipulationField = nil
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppSettingsViewModel(keepWindowOnTopDefaultValue: true))
}
