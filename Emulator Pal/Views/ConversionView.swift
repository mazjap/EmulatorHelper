import SwiftUI

struct ConversionView: View {
    @Bindable private var model: ConversionViewModel
    @Binding private var keepOnTop: Bool
    
    init(model: ConversionViewModel, keepOnTop: Binding<Bool>) {
        self.model = model
        self._keepOnTop = keepOnTop
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Conversion")
                    .font(.title)
                
                Spacer()
                
                Toggle(isOn: $keepOnTop) {
                    Text("Floating Window:")
                }
            }
            
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
    ConversionView(model: ConversionViewModel(), keepOnTop: .constant(true))
}
