enum Math: String, CaseIterable, Identifiable {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "×"
    case division = "÷"
    case logicalAnd = "&"
    case logicalOr = "|"
    case logicalXor = "^"
    
    var id: String {
        rawValue
    }
}
