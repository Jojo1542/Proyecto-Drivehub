//
//  DNIValidator.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import Foundation

enum TypeOfDocument {
    case dniNie(number: String)
    case dni(number: String)
    case nie(number: String)
}

struct CustomerIdentifierValidator {
    /// You must receive the ID without spaces or dashes
    ///
    /// - Parameter document: kind of document, you have 2 possibilities for now, dni or nie
    /// - Returns: validation bool property
    static func validate(document: TypeOfDocument) -> Bool {
        switch document {
        case .dniNie(let document):
            return self.validateDNI(candidateDNI: document)
        case .dni(let dni):
            return self.validateDNI(candidateDNI: dni)
        case .nie(let nie):
            return self.validateNIE(candidateNIE: nie)
        }
    }
    /// Sum digits values for Int <= 100
    ///
    /// - Parameter value: digit for script
    /// - Returns: result of sum
    static private func digitsSum(_ value:Int) -> Int {
        var currentResult : Int = 0
        var currentValue = value
        if(currentValue <= 100 && currentValue > 10) {
            currentResult += currentValue%10
            currentValue /= 10
            currentResult += currentValue
            return currentResult
        }
        if(currentValue == 10) {
            currentResult += 1
            return currentResult
        }
        return currentResult;
    }
    /// This method it's private and manage script for validate dni, it's called from validate(:) method
    ///
    /// - Parameter candidateDNI: number for the validation
    /// - Returns: return result of validation
    static private func validateDNI(candidateDNI: String) -> Bool {
        guard candidateDNI.count > 7 else { return false }
        let buffer = NSMutableString(string: candidateDNI)
        let opts = NSString.CompareOptions()
        let rng = NSMakeRange(0, 1)
        buffer.replaceOccurrences(of: "X", with: "0", options: opts, range: rng)
        buffer.replaceOccurrences(of: "Y", with: "1", options: opts, range: rng)
        buffer.replaceOccurrences(of: "Z", with: "2", options: opts, range: rng)
        if let baseNumber = Int(buffer.substring(to: 8)) {
            let letterMap1 = "TRWAGMYFPDXBNJZSQVHLCKET"
            let letterMap2 = "TRWAGMYFPDXBNJZSQVHLCKET".lowercased()
            let letterIdx = baseNumber % 23
            //Find case sensitive letter
            var expectedLetter = letterMap1[letterMap1.index(letterMap1.startIndex, offsetBy: letterIdx)]
            var providedLetter = candidateDNI[candidateDNI.index(before: candidateDNI.endIndex)]
            if(expectedLetter == providedLetter){
                return true
            }else{
                expectedLetter = letterMap2[letterMap2.index(letterMap2.startIndex, offsetBy: letterIdx)]
                providedLetter = candidateDNI[candidateDNI.index(before: candidateDNI.endIndex)]
                return expectedLetter == providedLetter
            }
        } else {
            return false
        }
    }
    /// This method it's private and manage script for validate nie, it's called from validate(:) method
    ///
    /// - Parameter candidateNIE: number for the validation
    /// - Returns: result of validation
    static private func validateNIE(candidateNIE: String) -> Bool {
        return self.validateDNI(candidateDNI: candidateNIE)
    }
}
