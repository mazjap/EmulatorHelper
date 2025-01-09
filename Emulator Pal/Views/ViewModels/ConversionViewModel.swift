import Foundation

enum ConversionError {
    case invalid
}

@Observable
@MainActor
class ConversionViewModel {
    var valueToConvert = ""
    var convertFromType = NumeralSystem.hexadecimal
    var convertToType = NumeralSystem.decimal
    var userFacingError: ConversionError?
    
    var convertedValue: String {
        let valueStringWithoutPrefix = valueToConvert
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .withoutPrefix(convertFromType.optionalPrefix)
        
        guard !valueStringWithoutPrefix.isEmpty else {
            userFacingError = nil
            return ""
        }
        
        let integerValue = Int128(valueStringWithoutPrefix, radix: convertFromType.radix)
        
        if let integerValue {
            userFacingError = nil
            return convertToType.optionalPrefix + String(integerValue, radix: convertToType.radix).uppercased()
        }
        
        userFacingError = .invalid
        return ""
    }
    
    func swapConversionTypes() {
        let oldFrom = convertFromType
        
        convertFromType = convertToType
        convertToType = oldFrom
    }
}
