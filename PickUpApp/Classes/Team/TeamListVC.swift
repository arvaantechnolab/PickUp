//
//  TeamListVC.swift
//  PickUpApp
//
//  Created by Arvaan on 10/02/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class TeamListVC: BaseViewController {

    @IBOutlet var teamListTableView: UITableView!
    
    var arrTeam: [Team] = []
    var arrTeam1: [Team] = []
    
    var offset = 0
    var totalCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Teams"
        getTeamList(offset)
        
    }
    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func btnCreateGameClick(_ sender: UIButton) {
        
    }
    
    //MARK: -  API Call
    
    func getTeamList( _ offSet:Int) {
        
        arrTeam.removeAll()
        let parameter : [String: Any] = ["offset" : "\(offSet)"]
        let url = WebService.createURLForWebService(WebService.TeamList) //+ "\(parameter.queryString())"
        
        print(url)
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, successHandler: { (response) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if let res = response as? [String : Any] {
                    print(res["total_counts"] as? Int)
                    self.totalCount = (res["total_counts"] as? Int)!
                    print(self.totalCount)
                    
                    if let data = res[Response.records] as? [[String:Any]] {
                        //self.arrGames = Mapper<Game>().mapArray(JSONArray: data)
                        let maparr =  Mapper<Team>().mapArray(JSONArray: data)
                        for data in maparr
                        {
                            self.arrTeam.append(data)
                        }
                    }
                }
                self.teamListTableView.reloadData()
            })
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    func getTeamList1( _ offSet:Int) {
        
        let parameter : [String: Any] = ["offset" : "\(offSet)"]
        let url = WebService.createURLForWebService(WebService.TeamList) + "\(parameter.queryString())"
        
        print(url)
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, successHandler: { (response) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if let res = response as? [String : Any] {
                    print(res["total_counts"] as? Int)
                    self.totalCount = (res["total_counts"] as? Int)!
                    print(self.totalCount)
                    
                    if let data = res[Response.records] as? [[String:Any]] {
                        //self.arrGames = Mapper<Game>().mapArray(JSONArray: data)
                        let newArr =  Mapper<Team>().mapArray(JSONArray: data)
                        for data in newArr
                        {
                            self.arrTeam1.append(data)
                        }
                        if self.arrTeam1.count != 0
                        {
                            for data in self.arrTeam1
                            {
                                self.arrTeam.append(data)
                            }
                        }
                    }
                }
                self.teamListTableView.reloadData()
               
            })
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }

}

extension TeamListVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTeam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamListCell.className, for: indexPath)
        
        if let teamCell = cell as? TeamListCell{
            
            let gameObject = arrTeam[indexPath.row]
            if arrTeam.count >= 20
            {
                
                if indexPath.row == arrTeam.count - 1
                {
                    if arrTeam.count != totalCount
                    {
                        if arrTeam.count <= totalCount
                        {
                            getTeamList1(arrTeam.count)
                        }
                        
                    }
                }
            }
            
            let profileURL = gameObject.icon
            teamCell.imgProfileIcon.setImageWithActivity(profileURL, UIActivityIndicatorViewStyle.white)
            teamCell.lblName.text = gameObject.name
            teamCell.imgIcon.image = UIImage(named: "modModeCellIcon")
            
            if let sportURL = gameObject.sport_type?.icon_hover {
                teamCell.imgIcon.setImageWithActivity(sportURL, UIActivityIndicatorViewStyle.white)
            }

        }
        
        
        cell.selectionStyle = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let teamDetail = getController(storyBoard: StoryBoardName.team, controllerIdentifier: TeamDetailVC.className) as! TeamDetailVC
        
        teamDetail.teamDetail = [arrTeam[indexPath.row]]
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(teamDetail, animated: true)
        
    }
    
    
    
}
