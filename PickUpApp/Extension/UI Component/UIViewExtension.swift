//
//  UIViewExtension.swift
//

import Foundation
import QuartzCore
import UIKit


typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint : CGPoint {
        get { return points.startPoint }
    }
    
    var endPoint : CGPoint {
        get { return points.endPoint }
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint.init(x: 0.0,y: 1.0), CGPoint.init(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 1,y: 1))
            case .horizontal:
                return (CGPoint.init(x: 0.0,y: 0.5), CGPoint.init(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 0.0,y: 1.0))
            }
        }
    }
}


extension UIView {

    // Shadow
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    fileprivate func addShadow(shadowColor: CGColor = UIColor.black.cgColor, shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0), shadowOpacity: Float = 0.35, shadowRadius: CGFloat = 5.0) {
        
        // *** Set masks bounds to NO to display shadow visible ***
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = shadowColor
        
        // *** *** Use following to add Shadow top, left ***
        //self.avatarImageView.layer.shadowOffset = CGSizeMake(-5.0f, -5.0f);
        
        // *** Use following to add Shadow bottom, right ***
        //self.avatarImageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
        
        // *** Use following to add Shadow top, left, bottom, right ***
         self.layer.shadowOffset = CGSize.zero
         self.layer.shadowRadius = 8.0
        
        // *** Set shadowOpacity to full (1) ***
        self.layer.shadowOpacity = 0.7
        
    }
    
    
    // Corner radius
    @IBInspectable var circle: Bool {
        get {
            return layer.cornerRadius == self.bounds.width*0.5
        }
        set {
            if newValue == true {
                self.cornerRadius = self.bounds.width*0.5
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    
    // Borders
    // Border width
    @IBInspectable
    public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    // Border color
    @IBInspectable
    public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        
        get {
            if let borderColor = layer.borderColor {
                return UIColor(cgColor: borderColor)
            }
            return nil
        }
    }
    
    /// To make round corners using BezierPath
    ///
    /// - Parameters:
    ///   - corners: Set of Corners
    ///   - radius: Radius of Corners
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    /// To apply corner radius to all corners
    ///
    /// - Parameter radius: Radius of Corners
    func applyCornerRadiusWith(radius : CGFloat) {
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
    
    /// To Add Gradient Layer
    ///
    ///   - Parameters:
    ///   - startColor: Gradient Start Color
    ///   - endColor: Gradient End Color
    
    func addGradientLayerWithStartColor(startColor : UIColor , endColor : UIColor, width: CGFloat, height: CGFloat) {
        
        let gradient : CAGradientLayer = CAGradientLayer()
        let startColor = startColor.cgColor;
        let endColor = endColor.cgColor;
        
        gradient.colors = [startColor,endColor]
        gradient.locations = [0.0,1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradient.bounds = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: height)
        gradient.anchorPoint = CGPoint.zero
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation, size: CGSize) -> () {
        
        if self.layer.sublayers != nil {
            
            for layer in self.layer.sublayers! {
                if layer.tag == 10 {
                    return
                }
            }
        }

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: size.width, height: size.height)
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        gradient.tag = 10
        
        if self.layer.sublayers != nil {
        
            for layer in self.layer.sublayers! {
                if layer.tag == 10 {
                    layer.removeFromSuperlayer()
                }
            }
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyShadow(onView layer: CALayer, offsetX x: CGFloat, offsetY y: CGFloat, blur radius: CGFloat, opacity alpha: CGFloat, roundingCorners cornerRadius: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: x, height: y)
        // shadow x and y
        layer.shadowOpacity = Float(alpha)
        layer.shadowRadius = radius
        // blur effect
        layer.shadowPath = shadowPath.cgPath
        
        /*
        layer.shadowOffset = CGSize(width : 0,height : 0);
        layer.shadowOpacity = 5.5;
        layer.shadowRadius = 5.0;
 */
    }

}

extension UIViewController {
    
    func isViewControllerPresented() -> Bool {
        
        return (self.presentingViewController?.presentedViewController == self || self.presentingViewController?.presentedViewController?.childViewControllers.first == self)
    }
    
}
