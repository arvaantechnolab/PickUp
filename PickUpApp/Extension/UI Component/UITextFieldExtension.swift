//
//  UITextFieldExtension.swift
//

import UIKit
private var AssociatedObjectHandle: UInt8 = 0

extension UITextField {

    var isEmpty : Bool {
        get {
            if self.text == nil {
                return true
            }
            return self.text!.isEmpty
        }
    }
    
    var isPasteEnable:Bool{
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return isPasteEnable
        }
        
        return true
    }
    
    func disablePasteFeature() {
        
    }

}
