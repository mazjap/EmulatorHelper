import SwiftUI

struct MathView: View {
    @Bindable private var model: MathViewModel
    @FocusBinding private var focusedField: Field?
    
    enum Field: Hashable {
        case representationMenu
        case operand1Input
        case operationMenu
        case operand2Input
        case copyButton
    }
    
    init(model: MathViewModel, focusedField: FocusBinding<Field?>) {
        self.model = model
        self._focusedField = focusedField
    }
    
    var body: some View {
        ContentHeader("Math") {
            Spacer()
            
            Menu {
                ForEach(NumeralSystem.allCases) { rep in
                    Button(rep.rawValue.capitalized) {
                        model.numeralSystem = rep
                    }
                    .tag(rep)
                }
            } label: {
                Text("Representation: \(model.numeralSystem.rawValue.capitalized)")
            }
            .focusable()
            .focused($focusedField, equals: .representationMenu)
        } content: {
            HStack {
                TextField("Operand", text: $model.firstMathValue)
                    .background {
                        if case let .invalidOperand(operand) = model.userFacingError,
                           operand.contains(.first) {
                            Rectangle()
                                .stroke(Color.red, lineWidth: 1)
                        }
                    }
                    .focused($focusedField, equals: .operand1Input)
                
                Menu {
                    ForEach(Math.allCases) { operation in
                        Button(operation.rawValue) {
                            model.mathOperator = operation
                        }
                    }
                } label: {
                    Text(model.mathOperator.rawValue)
                }
                .frame(width: NSFont.systemFontSize * 3)
                .focusable()
                .focused($focusedField, equals: .operationMenu)
                
                
                TextField("Operand", text: $model.secondMathValue)
                    .background {
                        if case let .invalidOperand(operand) = model.userFacingError,
                           operand.contains(.second) {
                            Rectangle()
                                .stroke(Color.red, lineWidth: 1)
                        }
                    }
                    .focused($focusedField, equals: .operand2Input)
            }
            
            HStack {
                Text("=")
                
                let string = model.mathResult
                
                if let string {
                    Text(string)
                        .textSelection(.enabled)
                } else if case .divideByZero = model.userFacingError {
                    Text("Divide by zero error 😠 Do better")
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Button {
                    copyToClipboard(string ?? "")
                } label: {
                    Label("Copy text", systemImage: "document.on.document")
                        .labelStyle(.iconOnly)
                }
                .disabled(string == nil || string!.isEmpty)
                .focusable()
                .focused($focusedField, equals: .copyButton)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @FocusState var focusedField: MathView.Field?
    
    MathView(model: MathViewModel(), focusedField: $focusedField)
}
