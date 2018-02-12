//
//  CALayerExtension.swift
//

import UIKit

private var AssociatedObjectHandle: UInt8 = 0

extension CALayer   {
    var tag:Int{
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
