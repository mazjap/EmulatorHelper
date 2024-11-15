import SwiftUI

struct MathView: View {
    @Bindable private var model: MathViewModel
    
    init(model: MathViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Math")
                .font(.title)
            
            Picker("Representation", selection: $model.numeralSystem) {
                ForEach(NumeralSystem.allCases) { rep in
                    Text(rep.rawValue.capitalized)
                        .tag(rep)
                }
            }
            
            HStack {
                TextField("Operand", text: $model.firstMathValue)
                    .background {
                        if case let .invalidOperand(operand) = model.userFacingError,
                           operand.contains(.first) {
                            Rectangle()
                                .stroke(Color.red, lineWidth: 1)
                        }
                    }
                
                Picker(selection: $model.mathOperator) {
                    ForEach(Math.allCases) { operation in
                        Text(operation.rawValue)
                            .tag(operation)
                    }
                } label: {
                    EmptyView()
                }
                .frame(width: NSFont.systemFontSize * 3)
                
                TextField("Operand", text: $model.secondMathValue)
                    .background {
                        if case let .invalidOperand(operand) = model.userFacingError,
                           operand.contains(.second) {
                            Rectangle()
                                .stroke(Color.red, lineWidth: 1)
                        }
                    }
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
                
                CopyButton(textToCopy: string ?? "")
                    .disabled(string == nil)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MathView(model: MathViewModel())
}
