//
//  NSMutableDataExtension.swift
//

import Foundation

extension NSMutableData {
    
    //==========================================
    //MARK: - To append string as a NSData
    //==========================================
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}
