//
//  DictionaryExtension.swift
//

import Foundation


extension Dictionary {
    
    func queryString () -> String{
        
        var queryString : String = ""
        var i = 0;
        
        for (key,value) in self {
            
            if (i == 0){
                queryString += "\(key)=\(value)"
            }else{
                queryString += "&\(key)=\(value)"
            }
            i += 1
        }
        return queryString
    }
    
}
