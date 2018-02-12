//
//  BoolExtension.swift
//

import Foundation


extension Bool {
    func intValue() -> Int {
        if self {
            return 1
        }
        return 0
    }
}
