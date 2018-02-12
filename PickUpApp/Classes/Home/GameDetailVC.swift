//
//  GameDetailVC.swift
//  PickUpApp
//
//  Created by Arvaan on 02/02/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import MapKit
import ObjectMapper

class GameDetailVC: BaseViewController {
    
    
    var gameDetail: [Game] = []
   
    var arrGames: [Game_Player] = []
    
    var userProfile : User?
    @IBOutlet var tableGameDetailPlayerList: UITableView!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCheckin: UILabel!
    @IBOutlet var lblPlayerCount: UILabel!
    @IBOutlet var lblTotalPlayerCount: UILabel!
    @IBOutlet var imgGameIcon: UIImageView!
    
    
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
            lblPlayerCount.text = "\(numberOfPlayer! - 1)/"
        }else{
            lblPlayerCount.text = "0"
        }
        let totalNumberOfPlayer = gameDetail.first?.no_of_player
        if totalNumberOfPlayer != 0 {
            lblTotalPlayerCount.text = "\(totalNumberOfPlayer!)"
        }else{
            lblTotalPlayerCount.text = "0"
        }
        //setArrayInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Game Detail MOF Mode"
        
        getGameList()
    }
    
    //MARK: -  API Call
    
    func getGameList() {
        
        let parameter =  String(gameDetail.first!.id!)
        let url = WebService.createURLForWebService(WebService.GamePlayerList) + "/" + parameter
        print(url)
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, successHandler: { (response) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if   let res = response as? NSArray
                {
                    self.arrGames = Mapper<Game_Player>().mapArray(JSONArray: res as! [[String : Any]])
                                            print(self.arrGames.count)
                     self.tableGameDetailPlayerList.reloadData()
                }
                
//                if let res = response as? [String : Any] {
//                    if let data = res[Response.data] as? [[String:Any]] {
//                        print(data)
//                        self.arrGames = Mapper<Game_Player>().mapArray(JSONArray: data)
//                        print(self.arrGames.count)
//                    }
//                }
                self.tableGameDetailPlayerList.reloadData()
               // self.addAnnotationToMap()
            })
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }

    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnInviteClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCheckInClick(_ sender: UIButton) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GameDetailVC : UITableViewDelegate , UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let numberOfPlayer = gameDetail.first?.no_of_player
        let player = numberOfPlayer! - 1
        let totalNumberOfPlayer = gameDetail.first?.no_of_player
        let total = totalNumberOfPlayer! - player
        let remainingTotal = totalNumberOfPlayer! - total
        
        if (section == 0){
            return total
        }
        else{
            return remainingTotal
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: GameDetailCell.className, for: indexPath)
            
            if let mofCell = cell as? GameDetailCell{
         
                mofCell.lblName.text = arrGames.first?.players?.first?.first_name
                let profileURL = arrGames.first?.players?.first?.profile_picture_thumb
                mofCell.imgProfileIcon?.setImageWithActivity(profileURL, UIActivityIndicatorViewStyle.white)
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: JoinActiveCell.className, for: indexPath)
             if let JoinActiveCell = cell as? JoinActiveCell{
                if appUser?.id == arrGames.first?.players?.first?.id {
                    JoinActiveCell.lblTitle.text = "INVITE"
                }
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.row == 0 && indexPath.section == 0  {
        let profileDetail = getController(storyBoard: StoryBoardName.startUP, controllerIdentifier: ProfileVC.className) as! ProfileVC
        profileDetail.playerProfile = arrGames.first?.players?.first
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(profileDetail, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
}

