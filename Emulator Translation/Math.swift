enum Math: String, CaseIterable, Identifiable {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "×"
    case division = "÷"
    
    var id: String {
        rawValue
    }
}
