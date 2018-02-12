//
//  LeagueMatchGameDetailVC.swift
//  PickUpApp
//
//  Created by Arvaan on 10/02/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import MapKit
import ObjectMapper

class LeagueMatchGameDetailVC: BaseViewController {

    @IBOutlet var imgGameIcon: UIImageView!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCkeckIn: UILabel!
    @IBOutlet var lblPlayer: UILabel!
    @IBOutlet var lblTotalPlayer: UILabel!
    @IBOutlet var leagueModeTableView: UITableView!
    
    var gameDetail: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
        
        if let sportURL = gameDetail.first?.sport_type?.icon_hover {
            imgGameIcon.setImageWithActivity(sportURL, UIActivityIndicatorViewStyle.white)
        }
        
        lblDateTime.text = gameDetail.first?.match_time
        lblAddress.text = gameDetail.first?.address?.components(separatedBy: ",").first
        let numberOfPlayer = gameDetail.first?.no_of_player
        if numberOfPlayer != 0 {
            lblPlayer.text = "\(numberOfPlayer! - 1)/"
        }else{
            lblPlayer.text = "0"
        }
        let totalNumberOfPlayer = gameDetail.first?.no_of_player
        if totalNumberOfPlayer != 0 {
            lblTotalPlayer.text = "\(totalNumberOfPlayer!)"
        }else{
            lblTotalPlayer.text = "0"
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Game Detail LEAGUE Mode"
    }
    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnInviteClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCheckInClick(_ sender: UIButton) {
    }
    

}
