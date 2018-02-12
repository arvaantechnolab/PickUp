//
//  StringExtension.swift
//

import Foundation
import MobileCoreServices

extension String
{
    //==========================================
    //MARK: - To get Length of String
    //==========================================
  
    var length: Int {
        return self.characters.count
    }
    
    //==========================================
    //MARK: - To get Float value from String
    //==========================================
    
    var floatValue: Float {
        let balance = self.replacingOccurrences(of: ",", with: "")
        return Float(balance)!
    }
    
//    func CGFloatValue() -> CGFloat {
//        
//        guard let doubleValue = Double(self) else {
//            return 0
//        }
//        
//        return CGFloat(doubleValue)
//    }
    
    //==========================================
    //MARK: - To get Double value from String
    //==========================================
    
    func toDouble() -> Double? {
        
        // return NSNumberFormatter().numberFromString(self)?.doubleValue
        let balance = self.replacingOccurrences(of: ",", with: "")
        return Double(balance)
    }
    
    
    //==========================================
    //MARK: - To get Int value from String
    //==========================================
    
    func toInt() -> Int? {
        // return NSNumberFormatter().numberFromString(self)?.doubleValue
        let balance = self.replacingOccurrences(of: ",", with: "")
        return Int(balance)
    }
    
    
    //==========================================
    //MARK: - To get Bool value from String
    //==========================================
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    
    //==========================================
    //MARK: - To get Number value from String
    //==========================================
    
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    
    //==========================================
    //MARK: - To get Localized String from String
    //==========================================
    
    func localizedString()->String{
        
        return  NSLocalizedString(self, tableName: "Messages", bundle: Bundle.main, value: "", comment: "") as String;
    }
    
    
    //==================================================
    //MARK: - To get Replaced String with another String
    //==================================================
    
    func replacementOfString(_ stringToReplace:String,stringByReplace:String) -> String{
        let newString = self.replacingOccurrences(of: stringToReplace, with: stringByReplace, options: NSString.CompareOptions.literal, range: nil)
        return newString
    }
    
    //==========================================
    //MARK: - To get UInt value from String
    //==========================================
    
    func toUInt() -> UInt? {
        if self.characters.contains("-") {
            return nil
        }
        return self.withCString { cptr -> UInt? in
            var endPtr : UnsafeMutablePointer<Int8>? = nil
            errno = 0
            let result = strtoul(cptr, &endPtr, 10)
            if errno != 0 || endPtr?.pointee != 0 {
                return nil
            } else {
                return result
            }
        }
    }
    
    //==========================================
    //MARK: - To Get NSString from String
    //==========================================
  
    var ns: NSString {
        return self as NSString
    }
    
    
    //==========================================
    //MARK: - To Get Path Extension of String
    //==========================================
    
    var pathExtension: String? {
        return ns.pathExtension
    }
    
    //==========================================
    //MARK: - To Get mime type of file or filePath
    //==========================================
    
    var mimeTypeForPath : String? {

        let pathExtension = self.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return nil
    }
    
    //==============================================
    //MARK: - To Get last Path component from String
    //==============================================
    
    var lastPathComponent: String? {
        return ns.lastPathComponent
    }
    
    //==========================================
    //MARK: - To Get trim string
    //==========================================
    
    var trimSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
    
    //==============================================
    //MARK: - To Get last 2 Digit from Number
    //==============================================
    
    func last2Digit()->String{
        let trimmedString: String = (self as NSString).substring(from: max(self.length-2,0))
        return trimmedString
    }
    
    
    //==============================================
    //MARK: - Subscript to Get Character at Index
    //==============================================
    
    subscript(integerIndex: Int) -> Character {
        let index = characters.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    
    //==========================================================
    //MARK: - Subscript to Get Range of String From given String
    //==========================================================
    
    subscript(integerRange: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return String(self[range])
    }

    
    func isStringOnlyAlphabet() -> Bool{
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.characters.count)) != nil {
            return false
        }
        return true
    }
    
    
    func isStringOnlyAlphabetAndComma() -> Bool{
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z ,].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.characters.count)) != nil {
            return false
        }
        return true
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end > 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start > 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
    
    ////==========================================
    //MARK: - Encoding and Decoding
    //============================================
    
    func decodeString(str : String) -> String{
        let wI = NSMutableString( string: str )
        CFStringTransform( wI, nil, "Any-Hex/Java" as NSString, true )
        return wI as String
        
    }
    
    func encodeString(str :  String) -> String{
        let eS = NSMutableString( string: str )
        CFStringTransform( eS, nil, "Any-Hex/Java" as NSString, false)
        return eS as String
    }
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
