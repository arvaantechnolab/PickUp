//
//  GameDetailCell.swift
//  PickUpApp
//
//  Created by Arvaan on 02/02/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import Cosmos

class GameDetailCell: UITableViewCell {
    
    @IBOutlet var imgProfileIcon: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var starRating: CosmosView!
    @IBOutlet var profileView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
