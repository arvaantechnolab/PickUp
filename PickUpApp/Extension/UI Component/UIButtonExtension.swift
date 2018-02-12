//
//  UIButtonExtension.swift
//

import Foundation
import UIKit

extension UIButton{
    
    func alignTextUnderImage() {
        guard let imageView = imageView else {
            return
        }
        
        self.contentVerticalAlignment = .top
        self.contentHorizontalAlignment = .center
        let imageLeftOffset = (self.bounds.width - imageView.bounds.width) / 2 //put image in center
        let titleTopOffset = imageView.bounds.height + 5
        self.imageEdgeInsets = UIEdgeInsetsMake(10, imageLeftOffset, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset, -imageView.bounds.width, 0, 0)
    }

}
