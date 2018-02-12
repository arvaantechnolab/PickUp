//
//  UIImageViewExtension.swift
//

import Foundation
import SDWebImage
import UIKit

extension UIImageView {
    
    
    //==========================================
    //MARK: - Apply Corner Radius
    //==========================================
    
    func applyCornerRadius () {
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.layer.masksToBounds = true
        
    }
    
    open override func layoutSubviews() {
        
        let activityView : UIActivityIndicatorView? = self.viewWithTag(10) as? UIActivityIndicatorView
        if activityView != nil {
            activityView?.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        }

    }
    
    func setImageWithActivity(_ url :String? , _ style : UIActivityIndicatorViewStyle){
        if url != nil {
            
            var activityView : UIActivityIndicatorView? = self.viewWithTag(10) as? UIActivityIndicatorView
            if activityView == nil {
                
                activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityView?.tag = 10
            }
            activityView?.activityIndicatorViewStyle = style
            activityView?.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            self.addSubview(activityView!)
            activityView?.startAnimating()
            
            self.sd_setImage(with: URL(string:url!), placeholderImage: nil, options: .refreshCached, completed: { (image, erroe, catchType, url) in
                self.image = image
                activityView?.removeFromSuperview()
            })
            
        }
    }
    
}



