//
//  FriendCell.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 09/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import Cosmos

@objc protocol FriendCellDelegate : NSObjectProtocol{
    
    @objc optional func friendRequestAccepted(indexPath : IndexPath?)
    @objc optional func friendRequestDecline(indexPath : IndexPath?)
    @objc optional func friendRemoved(indexPath : IndexPath?)
    @objc optional func friendAdd(indexPath : IndexPath?)
}


class FriendCell: UITableViewCell {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgProfilePic : UIImageView!
    @IBOutlet weak var startRating : CosmosView!
    @IBOutlet weak var btnRemove : UIButton!
    @IBOutlet weak var btnAdd : UIButton!
    
    @IBOutlet weak var acceptDeclientView : UIView!
    
    var delegate : FriendCellDelegate?
    var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func btnAcceptedClicked() {
        delegate?.friendRequestAccepted?(indexPath: indexPath)
    }
    
    @IBAction func btnDeclienClicked() {
        delegate?.friendRequestDecline?(indexPath: indexPath)
    }
    
    @IBAction func btnRemoveClicked() {
        delegate?.friendRemoved?(indexPath: indexPath)
    }

    @IBAction func btnAddClicked() {
        delegate?.friendAdd?(indexPath: indexPath)
    }
}
