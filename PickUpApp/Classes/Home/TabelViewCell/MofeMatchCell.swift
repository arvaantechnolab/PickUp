//
//  MofeMatchCell.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 02/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

class MofeMatchCell: UITableViewCell {

    @IBOutlet weak var lblGame : UILabel!
    @IBOutlet weak var lblLocationName : UILabel!
    @IBOutlet weak var lblNumberOfPlayer : UILabel!
    @IBOutlet weak var imgGameIcon : UIImageView!
    @IBOutlet weak var imgGameMode : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
