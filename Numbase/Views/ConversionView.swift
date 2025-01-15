import SwiftUI

struct ConversionView: View {
    @Bindable private var model: ConversionViewModel
    @FocusBinding private var focusedField: Field?
    
    enum Field: Hashable {
        case swapButton
        case floatingWindowToggle
        case fromMenu
        case toMenu
        case input
        case copyButton
    }
    
    init(model: ConversionViewModel, focusedField: FocusBinding<Field?>) {
        self.model = model
        self._focusedField = focusedField
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
                .focusable()
                .focused($focusedField, equals: .swapButton)
                
                Spacer()
                
                FloatingToggle()
                    .focusable()
                    .focused($focusedField, equals: .floatingWindowToggle)
            }
        } content: {
            HStack {
                Menu {
                    ForEach(NumeralSystem.allCases) { rep in
                        Button(rep.rawValue.capitalized) {
                            model.convertFromType = rep
                        }
                        .focusable()
                    }
                } label: {
                    Text("From: \(model.convertFromType.rawValue.capitalized)")
                }
                .focusable()
                .focused($focusedField, equals: .fromMenu)
                .keyboardShortcut(.return)
                
                Menu {
                    ForEach(NumeralSystem.allCases) { rep in
                        Button(rep.rawValue.capitalized) {
                            model.convertToType = rep
                        }
                    }
                } label: {
                    Text("To: \(model.convertToType.rawValue.capitalized)")
                }
                .focusable()
                .focused($focusedField, equals: .fromMenu)
                .keyboardShortcut(.return)
            }
            
            TextField("Enter number", text: $model.valueToConvert)
                .focused($focusedField, equals: .input)
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
                
                Button {
                    copyToClipboard(convertedValue)
                } label: {
                    Label("Copy text", systemImage: "document.on.document")
                        .labelStyle(.iconOnly)
                }
                .disabled(convertedValue.isEmpty)
                .focusable()
                .focused($focusedField, equals: .copyButton)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @FocusState var focusedField: ConversionView.Field?
    
    ConversionView(model: ConversionViewModel(), focusedField: $focusedField)
        .environment(AppSettingsViewModel(keepWindowOnTopDefaultValue: true))
}
