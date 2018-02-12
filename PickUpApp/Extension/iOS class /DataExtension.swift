//
//  DataExtension.swift
//

import UIKit

extension Data{
    
    var toString : String? {
        get {
            let str = String(data: self, encoding: .utf8)
            return str
        }
    }

    func storeToRandomFile(_ fileExtension : String) {

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        let fileName = "Random_\(arc4random() % 10000).\(fileExtension)"
        let filePath = "\(documentsPath)/\(fileName)"
        
        FileManager.default.createFile(atPath: filePath, contents: self, attributes: nil)
        
        print("filePath  \(filePath)")
        
    }
}
