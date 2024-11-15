enum NumeralSystem: String, CaseIterable, Identifiable {
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
