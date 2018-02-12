//
//  LeagueMatchCell.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 02/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

class LeagueMatchCell: UITableViewCell {

    @IBOutlet weak var imgTeam1 : UIImageView!
    @IBOutlet weak var imgTeam2 : UIImageView!
    @IBOutlet weak var lblTeam1Name : UILabel!
    @IBOutlet weak var lblTeam2Name : UILabel!
    
    @IBOutlet var imgGameImage: UIImageView!
    
    @IBOutlet weak var lblGame : UILabel!
    @IBOutlet weak var lblLocationName : UILabel!
    @IBOutlet weak var imgGameIcon : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
