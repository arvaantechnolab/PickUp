//
//  TeamDetailVC.swift
//  PickUpApp
//
//  Created by Arvaan on 10/02/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper
import Cosmos

class TeamDetailVC: BaseViewController {

    @IBOutlet var BannerImage: UIImageView!
    @IBOutlet var ratingStar: CosmosView!
    @IBOutlet var sportIconImage: UIImageView!
    @IBOutlet var teamDetailTableView: UITableView!
    @IBOutlet var lblWin: UILabel!
    @IBOutlet var lblLoss: UILabel!
    @IBOutlet var lblRanking: UILabel!
    
    var teamDetail: [Team] = []
    var arrTeamDetail: [Game_Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
        
        let profileURL = teamDetail.first?.icon
        BannerImage.setImageWithActivity(profileURL, UIActivityIndicatorViewStyle.white)
        sportIconImage.image = UIImage(named: "modModeCellIcon")
        
        if let sportURL = teamDetail.first?.sport_type?.icon_hover {
            sportIconImage.setImageWithActivity(sportURL, UIActivityIndicatorViewStyle.white)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Team Details"
        getTeamDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: -  API Call
    
    func getTeamDetail() {
        
        let parameter =  String(teamDetail.first!.id!)
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
                    self.arrTeamDetail = Mapper<Game_Player>().mapArray(JSONArray: res as! [[String : Any]])
                    print(self.arrTeamDetail.count)
                    self.teamDetailTableView.reloadData()
                }
                
                //                if let res = response as? [String : Any] {
                //                    if let data = res[Response.data] as? [[String:Any]] {
                //                        print(data)
                //                        self.arrGames = Mapper<Game_Player>().mapArray(JSONArray: data)
                //                        print(self.arrGames.count)
                //                    }
                //                }
                self.teamDetailTableView.reloadData()
               
            })
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
    
}

extension TeamDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTeamDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamDetailCell.className, for: indexPath)
            
            if let mofCell = cell as? TeamDetailCell{
                
                mofCell.lblName.text = arrTeamDetail.first?.players?.first?.first_name
                let profileURL = arrTeamDetail.first?.players?.first?.profile_picture_thumb
                mofCell.imgProfile?.setImageWithActivity(profileURL, UIActivityIndicatorViewStyle.white)

            }
            return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileDetail = getController(storyBoard: StoryBoardName.startUP, controllerIdentifier: ProfileVC.className) as! ProfileVC
        profileDetail.playerProfile = arrTeamDetail.first?.players?.first
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(profileDetail, animated: true)
    }
}

