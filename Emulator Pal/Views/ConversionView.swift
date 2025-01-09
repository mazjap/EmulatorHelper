import SwiftUI

struct ConversionView: View {
    @Bindable private var model: ConversionViewModel
    
    init(model: ConversionViewModel) {
        self.model = model
    }
    
    var body: some View {
        ContentHeader("Conversion") {
            HStack {
                Button {
                    model.swapConversionTypes()
                } label: {
                    Label("Swap types", systemImage: "repeat")
                }
                .labelStyle(.iconOnly)
                
                Spacer()
                
                FloatingToggle()
            }
        } content: {
            HStack {
                Picker("From", selection: $model.convertFromType) {
                    ForEach(NumeralSystem.allCases) { rep in
                        Text(rep.rawValue.capitalized)
                            .tag(rep)
                    }
                }
                
                Picker("To", selection: $model.convertToType) {
                    ForEach(NumeralSystem.allCases) { rep in
                        Text(rep.rawValue.capitalized)
                            .tag(rep)
                    }
                }
            }
            .pickerStyle(.menu)
            
            TextField("Enter number", text: $model.valueToConvert)
                .background {
                    if model.userFacingError == .invalid {
                        Rectangle()
                            .stroke(Color.red, lineWidth: 1)
                    }
                }
            
            HStack {
                Text(model.convertToType.rawValue.capitalized + " number:")
                
                let convertedValue = model.convertedValue
                
                Text(convertedValue)
                    .textSelection(.enabled)
                
                Spacer()
                
                CopyButton(textToCopy: convertedValue)
                    .disabled(convertedValue.isEmpty)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ConversionView(model: ConversionViewModel())
        .environment(AppSettingsViewModel(keepWindowOnTopDefaultValue: true))
}
