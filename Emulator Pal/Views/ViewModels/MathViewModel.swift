import Foundation

struct Operand: OptionSet {
    var rawValue: UInt8
    
    static let first = Operand(rawValue: 1 << 0)
    static let second = Operand(rawValue: 1 << 1)
    static let both = Operand([.first, .second])
}

enum MathError {
    case invalidOperand(Operand)
    case divideByZero
}

@Observable
class MathViewModel {
    var numeralSystem = NumeralSystem.hexadecimal
    var firstMathValue = ""
    var mathOperator: Math = .addition
    var secondMathValue = ""
    var userFacingError: MathError?
    
    var mathResult: String? {
        let firstMathValueWithoutPrefix = firstMathValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .withoutPrefix(numeralSystem.optionalPrefix)
        let secondMathValueWithoutPrefix = secondMathValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .withoutPrefix(numeralSystem.optionalPrefix)
        
        var operandToChillOn = Operand([])
        
        // Go easy on empty values
        switch (firstMathValueWithoutPrefix, secondMathValueWithoutPrefix) {
        case ("", ""):
            userFacingError = nil
            return nil
        case ("", _):
            operandToChillOn.insert(.first)
        case (_, ""):
            operandToChillOn.insert(.second)
        default: break
        }
        
        let operand1 = Int128(firstMathValueWithoutPrefix, radix: numeralSystem.radix)
        let operand2 = Int128(secondMathValueWithoutPrefix, radix: numeralSystem.radix)
        
        // Early exit if one or more operands are missing/inconvertable
        guard let operand1, let operand2 else {
            switch (operand1, operand2) {
            case (.none, .none):
                userFacingError = .invalidOperand(.both.subtracting(operandToChillOn))
                return nil
            case (.none, .some):
                userFacingError = .invalidOperand(.first.subtracting(operandToChillOn))
                return nil
            case (.some, .none):
                userFacingError = .invalidOperand(.second.subtracting(operandToChillOn))
                return nil
            default: // should never hit this case due to guard
                return nil
            }
        }
        
        // Early exit if division by 0 would occur
        if [.mod, .division].contains(mathOperator), operand2 == 0 {
            userFacingError = .divideByZero
            return nil
        }
        
        // Clear error after error checks succeed
        userFacingError = nil
        
        let number: Int128 = switch mathOperator {
        case .addition: operand1 + operand2
        case .subtraction: operand1 - operand2
        case .multiplication: operand1 * operand2
        case .division: operand1 / operand2
        case .mod: operand1 % operand2
        case .logicalAnd: operand1 & operand2
        case .logicalOr: operand1 | operand2
        case .logicalXor: operand1 ^ operand2
        }
        
        // Add prefix and uppercase
        let resultString = String(number, radix: numeralSystem.radix).uppercased()
        
        return (resultString.hasPrefix("-") ? "-" : "") +
            numeralSystem.optionalPrefix +
            resultString.withoutPrefix("-")
    }
}
