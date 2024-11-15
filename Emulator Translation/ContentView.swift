import SwiftUI

struct ContentView: View {
    @State var valueToTranslate = ""
    @State var selectedFrom: Representation = .hexadecimal
    @State var selectedTo: Representation = .decimal
    
    @State var mathRepresentation = Representation.hexadecimal
    @State var firstMathValue = ""
    @State var mathOperator: Math = .addition
    @State var secondMathValue = ""
    
    @State var binaryBitCount = 8
    @State var binaryNumber: UInt128 = 0
    
    @State var contentSize = CGSize.zero
    
    @Binding var keepOnTop: Bool
    
    var body: some View {
        VStack(spacing: 3) {
            conversion
            
            Divider()
            
            math
            
            Divider()
            
            binaryManipulation
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
    
    private var conversion: some View {
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
                
                let result = Int128(valueToTranslate.withoutPrefix(selectedFrom.optionalPrefix), radix: selectedFrom.radix)
                let string = result.map { selectedTo.optionalPrefix + String($0, radix: selectedTo.radix).uppercased() }
                
                if let string {
                    Text(string)
                        .textSelection(.enabled)
                } else {
                    Text("")
                }
                
                Spacer()
                
                copyButton(textToCopy: string ?? "")
                    .disabled(string == nil)
            }
        }
        .padding(.horizontal)
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
            }
            
            HStack {
                Text("=")
                
                let operand1 = Int128(firstMathValue.withoutPrefix(mathRepresentation.optionalPrefix), radix: mathRepresentation.radix)
                let operand2 = Int128(secondMathValue.withoutPrefix(mathRepresentation.optionalPrefix), radix: mathRepresentation.radix)
                
                let result: MathResult? = operand1.flatMap { op1 in operand2.map { op2 in (op1, op2) } }.map { (operand1, operand2) in
                    switch mathOperator {
                    case .addition: .math(operand1 + operand2)
                    case .subtraction: .math(operand1 - operand2)
                    case .multiplication: .math(operand1 * operand2)
                    case .division:
                        if operand2 == 0 {
                            .div0
                        } else {
                            .math(operand1 / operand2)
                        }
                    case .mod:
                        if operand2 == 0 {
                            .div0
                        } else {
                            .math(operand1 % operand2)
                        }
                    case .logicalAnd: .math(operand1 & operand2)
                    case .logicalOr: .math(operand1 | operand2)
                    case .logicalXor: .math(operand1 ^ operand2)
                    }
                }
                let string: String? = result.flatMap {
                    guard case let .math(number) = $0 else { return nil }
                    
                    return mathRepresentation.optionalPrefix + String(number, radix: mathRepresentation.radix).uppercased()
                }
                    
                if let string {
                    Text(string)
                        .textSelection(.enabled)
                } else if case .div0 = result {
                    Text("Divide by zero error 😠 Do better")
                }
                
                Spacer()
                
                copyButton(textToCopy: string ?? "")
                    .disabled(string == nil)
            }
        }
        .padding(.horizontal)
    }
    
    private var binaryManipulation: some View {
        VStack {
            HStack {
                Text("Binary Manipulation")
                    .font(.title)
                
                Spacer()
            }
            
            HStack {
                Button {
                    binaryNumber <<= 1
                    binaryNumber &= ~(1 << binaryBitCount)
                } label: {
                    Text("<<")
                }
                
                Text("Shift Bits")
                
                Button {
                    binaryNumber >>= 1
                    binaryNumber &= ~(1 << binaryBitCount)
                } label: {
                    Text(">>")
                }
                
                Spacer(minLength: 0)
                
                Button {
                    if binaryBitCount < 128 {
                        binaryBitCount += 1
                    }
                } label: {
                    Text("+")
                }
                .buttonRepeatBehavior(.enabled)
                
                Text("Bit Count")
                
                Button {
                    guard binaryBitCount > 1 else { return }
                    
                    binaryBitCount -= 1
                    binaryNumber &= ~(1 << binaryBitCount)
                } label: {
                    Text("-")
                }
                .buttonRepeatBehavior(.enabled)
            }
            
            HStack {
                Button("Set All") {
                    let lastBit: UInt128 = (1 << (binaryBitCount - 1))
                    binaryNumber |= (lastBit - 1 | lastBit)
                }
                
                Spacer(minLength: 0)
                
                copyButton(textToCopy: {
                    let binaryString = String(binaryNumber, radix: 2)
                    
                    return "0b" + String(repeating: "0", count: binaryBitCount - binaryString.count) + binaryString
                }())
                
                Spacer(minLength: 0)
                
                Button("Clear All") {
                    binaryNumber = 0
                }
            }
            
            HStack(spacing: 3) {
                ForEach((0..<binaryBitCount).reversed(), id: \.self) { bitIndex in
                    VStack {
                        Text("\(bitIndex + 1)")
                        
                        Button {
                            let digitToModify: UInt128 = (1 << bitIndex)
                            
                            let isSet = binaryNumber & digitToModify != 0
                            
                            if isSet {
                                binaryNumber &= ~digitToModify
                            } else {
                                binaryNumber |= digitToModify
                            }
                        } label: {
                            Text("\(binaryNumber & (1 << bitIndex) == 0 ? 0 : 1)")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                        }
                        .onHover { isHovering in
                            if isHovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            
            HStack {
                Text("Dec:")
                Text("\(String(binaryNumber, radix: 10))")
                    .textSelection(.enabled)
                
                let lastBit: UInt128 = 1 << (binaryBitCount - 1)
                
                Text("") // Used for extra spacing
                
                Text("Signed:")
                if binaryNumber & lastBit != 0 {
                    let withoutLastBit = binaryNumber - lastBit
                    Text("-\(String(lastBit - withoutLastBit, radix: 10))")
                        .textSelection(.enabled)
                } else {
                    Text("\(String(binaryNumber, radix: 10))")
                        .textSelection(.enabled)
                }
            }
            
            HStack {
                Text("Hex:")
                Text("\(Representation.hexadecimal.optionalPrefix)\(String(binaryNumber, radix: 16).uppercased())")
                    .textSelection(.enabled)
            }
            
            HStack {
                Text("Oct:")
                Text("\(Representation.octal.optionalPrefix)\(String(binaryNumber, radix: 8))")
                    .textSelection(.enabled)
            }
        }
        .padding(.horizontal)
    }
    
    private func copyButton(textToCopy: String) -> some View {
        Button {
            let pasteboard = NSPasteboard.general
            
            pasteboard.prepareForNewContents()
            
            let successfulCopy = pasteboard.setString(textToCopy, forType: .string)
            
            if !successfulCopy {
                NSLog("Failed to copy \"\(textToCopy)\" to clipboard")
            }
        } label: {
            Image(systemName: "document.on.document")
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var isOnTop = false
    
    ContentView(keepOnTop: $isOnTop)
}
