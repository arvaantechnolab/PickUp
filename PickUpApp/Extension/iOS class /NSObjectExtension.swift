//
//  NSObjectExtension.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 27/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import Foundation

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
        
}
