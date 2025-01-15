import Foundation

@Observable
@MainActor
class BinaryManipulationViewModel {
    var binaryBitCount = 8
    var binaryNumber: UInt128 = 0
    
    var binaryStringRepresentation: String {
        let binaryString = String(binaryNumber, radix: 2)
        
        return "0b" + String(repeating: "0", count: binaryBitCount - binaryString.count) + binaryString
    }
    
    var decimalStringRepresentation: String {
        String(binaryNumber, radix: 10)
    }
    
    var signedDecimalStringRepresentation: String {
        let lastBit: UInt128 = 1 << (binaryBitCount - 1)
        
        if binaryNumber & lastBit != 0 {
            let withoutLastBit = binaryNumber - lastBit
            return "-\(String(lastBit - withoutLastBit, radix: 10))"
        } else {
            return String(binaryNumber, radix: 10)
        }
    }
    
    var hexidecimalStringRepresentation: String {
        NumeralSystem.hexadecimal.optionalPrefix + String(binaryNumber, radix: 16).uppercased()
    }
    
    var octalStringRepresentation: String {
        NumeralSystem.octal.optionalPrefix + String(binaryNumber, radix: 8)
    }
    
    func shiftLeft() {
        binaryNumber <<= 1
        binaryNumber &= ~(1 << binaryBitCount)
    }
    
    func shiftRight() {
        binaryNumber >>= 1
        binaryNumber &= ~(1 << binaryBitCount)
    }
    
    func increaseBitCount() {
        guard binaryBitCount < 128 else { return }
        binaryBitCount += 1
    }
    
    func decreaseBitCount() {
        guard binaryBitCount > 1 else { return }
        
        binaryBitCount -= 1
        binaryNumber &= ~(1 << binaryBitCount)
    }
    
    func setAllBits() {
        let lastBit: UInt128 = (1 << (binaryBitCount - 1))
        binaryNumber |= (lastBit - 1 | lastBit)
    }
    
    func clearAllBits() {
        binaryNumber = 0
    }
    
    func toggleBit(at bitIndex: Int) {
        let digitToModify: UInt128 = (1 << bitIndex)
        
        let isSet = binaryNumber & digitToModify != 0
        
        if isSet {
            binaryNumber &= ~digitToModify
        } else {
            binaryNumber |= digitToModify
        }
    }
    
    func flipAllBits() {
        if binaryBitCount == 128 {
            binaryNumber = ~binaryNumber
        } else {
            let bitmap: UInt128 = (1 << binaryBitCount) - 1
            let invertedNumber = ~binaryNumber
            binaryNumber = invertedNumber & bitmap
        }
    }
}
