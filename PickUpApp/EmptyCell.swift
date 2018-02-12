//
//  EmptyCell.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 22/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {

    @IBOutlet weak var lblEmpty : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
