//
//  SettingCell.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 10/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

@objc protocol SettingDelegate : NSObjectProtocol{
    
    @objc optional func switchValueChange(_ indexPath : IndexPath?)
    
}


class SettingCell: UITableViewCell {

    @IBOutlet weak var lblMenu : UILabel!
    @IBOutlet weak var switchButton : UISwitch!
    
    var indexPath : IndexPath?
    var delegate : SettingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchValueChange(_ sender : UISwitch) {
        delegate?.switchValueChange?(indexPath)
    }
    
}
