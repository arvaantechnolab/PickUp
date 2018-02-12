//
//  HeaderView.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 28/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

@objc protocol HeaderDelegate : NSObjectProtocol{
    
    @objc optional func leftIconClicked()
    @objc optional func rightIconClicked()
    
}


class HeaderView: UIView {

    @IBOutlet weak var lblTitle : UILabel?
    @IBOutlet weak var btnLeft : UIButton?
    @IBOutlet weak var btnRight : UIButton?
    
    var delegate : HeaderDelegate?
    
    static func GetHeaderView() -> HeaderView?{
        if let arr = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil) {
            if arr.count > 0 {
                if let view = arr[0] as? HeaderView{
                    return view;
                }
            }
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLeft?.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5 )
    }
    
    
    @IBAction func btnLeftClicked(_ sender : UIButton) {
        delegate?.leftIconClicked?()
    }

    @IBAction func btnRightClicked(_ sender : UIButton) {
        delegate?.rightIconClicked?()
    }
}
