import SwiftUI

enum Representation: String, CaseIterable, Identifiable {
    case decimal
    case binary
    case hexadecimal
    case octal
    
    var id: String { rawValue }
    
    var radix: Int {
        switch self {
        case .decimal: 10
        case .binary: 2
        case .hexadecimal: 16
        case .octal: 8
        }
    }
    
    var optionalPrefix: String {
        switch self {
        case .decimal: ""
        case .binary: "0b"
        case .hexadecimal: "0x"
        case .octal: "0o"
        }
    }
}

enum Math: String, CaseIterable, Identifiable {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "×"
    case division = "÷"
    
    var id: String {
        rawValue
    }
}

enum MathResult {
    case math(Int128)
    case div0
}

struct ContentView: View {
    @State var valueToTranslate = ""
    @State var selectedFrom: Representation = .hexadecimal
    @State var selectedTo: Representation = .decimal
    
    @State var mathRepresentation = Representation.hexadecimal
    @State var firstMathValue = ""
    @State var mathOperator: Math = .addition
    @State var secondMathValue = ""
    
    @State var contentSize = CGSize.zero
    
    var body: some View {
        VStack(spacing: 3) {
            conversion
            
            Divider()
            
            math
        }
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
    
    private var conversion: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Conversion")
                .font(.title)
            
            HStack {
                Picker("From", selection: $selectedFrom) {
                    ForEach(Representation.allCases) { rep in
                        Text(rep.rawValue.capitalized)
                            .tag(rep)
                    }
                }
                
                Picker("To", selection: $selectedTo) {
                    ForEach(Representation.allCases) { rep in
                        Text(rep.rawValue.capitalized)
                            .tag(rep)
                    }
                }
            }
            .pickerStyle(.menu)
            
            TextField("Enter number", text: $valueToTranslate)
            
            HStack {
                Text(selectedTo.rawValue.capitalized + " number:")
                
                if let result = Int128(valueToTranslate.withoutPrefix(selectedFrom.optionalPrefix), radix: selectedFrom.radix) {
                    Text(selectedTo.optionalPrefix + String(result, radix: selectedTo.radix).uppercased())
                } else {
                    Text("")
                }
            }
        }
        .padding()
    }
    
    private var math: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Math")
                .font(.title)
            
            Picker("Representation", selection: $mathRepresentation) {
                ForEach(Representation.allCases) { rep in
                    Text(rep.rawValue.capitalized)
                        .tag(rep)
                }
            }
            
            
            HStack {
                TextField("Operand", text: $firstMathValue)
                    .layoutPriority(1)
                
                Picker(selection: $mathOperator) {
                    ForEach(Math.allCases) { operation in
                        Text(operation.rawValue)
                            .tag(operation)
                    }
                } label: {
                    EmptyView()
                }
                .frame(width: NSFont.systemFontSize * 3)
                
                TextField("Operand", text: $secondMathValue)
                    .layoutPriority(1)
            }
            
            HStack {
                Text("=")
                
                if let operand1 = Int128(firstMathValue.withoutPrefix(mathRepresentation.optionalPrefix), radix: mathRepresentation.radix),
                   let operand2 = Int128(secondMathValue.withoutPrefix(mathRepresentation.optionalPrefix), radix: mathRepresentation.radix)
                {
                    let result: MathResult = switch mathOperator {
                    case .addition: .math(operand1 + operand2)
                    case .subtraction: .math(operand1 - operand2)
                    case .multiplication: .math(operand1 * operand2)
                    case .division:
                        if operand2 == 0 {
                            .div0
                        } else {
                            .math(operand1 / operand2)
                        }
                    }
                    
                    if case let .math(number) = result {
                        Text(mathRepresentation.optionalPrefix + String(number, radix: mathRepresentation.radix).uppercased())
                    } else if case .div0 = result {
                        Text("Divide by zero error 😠 Do better")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
