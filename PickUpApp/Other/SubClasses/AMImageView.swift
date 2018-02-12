//
//  AMImageView.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 29/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

class AMImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var isMasking : Bool = false
    
    @IBInspectable var maskColor : UIColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isMasking == true  {
            self.image = self.image?.maskWithColor(color: maskColor)
        }
    }
    
    
}
