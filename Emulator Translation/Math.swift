enum Math: String, CaseIterable, Identifiable {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "×"
    case division = "÷"
    case mod = "%"
    case logicalAnd = "&"
    case logicalOr = "|"
    case logicalXor = "^"
    
    var id: String {
        rawValue
    }
}
