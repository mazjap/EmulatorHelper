import SwiftUI

struct BinaryManipulationView: View {
    @Bindable private var model: BinaryManipulationViewModel
    @State private var indexFromOne: Bool = true
    @FocusBinding private var focusedField: Field?
    
    enum Field: Hashable {
        case shiftLeftButton
        case shiftRightButton
        case copyButton
        case increaseBitCountButton
        case decreaseBitCountButton
        case setAllButton
        case flipButton
        case clearAllButton
        case bit(UInt8)
    }
    
    init(model: BinaryManipulationViewModel, focusedField: FocusBinding<Field?>) {
        self.model = model
        self._focusedField = focusedField
    }
    
    var body: some View {
        ContentHeader("Binary Manipulation") {
            Toggle("Index From 1", isOn: $indexFromOne)
        } content: {
            ZStack {
                HStack {
                    Button("<<", action: model.shiftLeft)
                        .focusable()
                        .focused($focusedField, equals: .shiftLeftButton)
                    
                    Text("Shift")
                    
                    Button(">>", action: model.shiftRight)
                        .focusable()
                        .focused($focusedField, equals: .shiftRightButton)
                    
                    Spacer(minLength: 0)
                    
                    Button("+", action: model.increaseBitCount)
                        .focusable()
                        .focused($focusedField, equals: .increaseBitCountButton)
                    
                    Text("Count")
                    
                    Button("-", action: model.decreaseBitCount)
                        .focusable()
                        .focused($focusedField, equals: .decreaseBitCountButton)
                }
                
                Button {
                    copyToClipboard(model.binaryStringRepresentation)
                } label: {
                    Label("Copy text", systemImage: "document.on.document")
                        .labelStyle(.iconOnly)
                }
                .focusable()
                .focused($focusedField, equals: .copyButton)
            }
            .buttonRepeatBehavior(.enabled)
            
            ZStack {
                HStack {
                    Button("Set All", action: model.setAllBits)
                        .focusable()
                        .focused($focusedField, equals: .setAllButton)
                    
                    Spacer(minLength: 0)
                    
                    Button("Clear All", action: model.clearAllBits)
                        .focusable()
                        .focused($focusedField, equals: .clearAllButton)
                }
                
                Button {
                    model.flipAllBits()
                } label: {
                    Label("Flip all bits", systemImage: "repeat")
                        .labelStyle(.iconOnly)
                }
                .focusable()
                .focused($focusedField, equals: .flipButton)
            }
            
            HStack {
                Spacer(minLength: 0)
                
                VStack {
                    HStack(spacing: 3) {
                        ForEach((0..<model.binaryBitCount).reversed(), id: \.self) { bitIndex in
                            VStack {
                                Text("\(bitIndex + (indexFromOne ? 1 : 0))")
                                
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
                                .focusable()
                                .focused($focusedField, equals: .bit(UInt8(bitIndex)))
                            }
                            .accessibilityElement(children: .combine)
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
    @Previewable @FocusState var focusedField: BinaryManipulationView.Field?
    
    BinaryManipulationView(model: BinaryManipulationViewModel(), focusedField: $focusedField)
}
