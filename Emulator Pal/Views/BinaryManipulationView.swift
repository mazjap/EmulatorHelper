import SwiftUI

struct BinaryManipulationView: View {
    @Bindable private var model: BinaryManipulationViewModel
    
    init(model: BinaryManipulationViewModel) {
        self.model = model
    }
    
    var body: some View {
        ContentHeader("Binary Manipulation") {
            HStack {
                Button("<<", action: model.shiftLeft)
                Text("Shift Bits")
                Button(">>", action: model.shiftRight)
                
                Spacer(minLength: 0)
                
                Button("+", action: model.increaseBitCount)
                Text("Bit Count")
                Button("-", action: model.decreaseBitCount)
            }
            .buttonRepeatBehavior(.enabled)
            
            HStack {
                Button("Set All", action: model.setAllBits)
                
                Spacer(minLength: 0)
                
                CopyButton(textToCopy: model.binaryStringRepresentation)
                
                Spacer(minLength: 0)
                
                Button("Clear All", action: model.clearAllBits)
            }
            
            HStack {
                Spacer(minLength: 0)
                
                VStack {
                    HStack(spacing: 3) {
                        ForEach((0..<model.binaryBitCount).reversed(), id: \.self) { bitIndex in
                            VStack {
                                Text("\(bitIndex + 1)")
                                
                                Button {
                                    model.toggleBit(at: bitIndex)
                                } label: {
                                    Text("\(model.binaryNumber & (1 << bitIndex) == 0 ? 0 : 1)")
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
                        Text(model.decimalStringRepresentation)
                            .textSelection(.enabled)
                        
                        Text("") // Used for extra spacing
                        
                        Text("Signed:")
                        Text(model.signedDecimalStringRepresentation)
                            .textSelection(.enabled)
                    }
                    
                    HStack {
                        Text("Hex:")
                        Text(model.hexidecimalStringRepresentation)
                            .textSelection(.enabled)
                    }
                    
                    HStack {
                        Text("Oct:")
                        Text(model.octalStringRepresentation)
                            .textSelection(.enabled)
                    }
                }
                
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    BinaryManipulationView(model: BinaryManipulationViewModel())
}
