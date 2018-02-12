//
//  FriendVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 08/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class FriendVC: BaseViewController {

    @IBOutlet weak var tblFriend : UITableView!
    @IBOutlet weak var txtSearch : AMTextField!
    
    var totalFriend = 0
    var totalSearchFriend = 0
    
    var arrFriends: [Friend] = []
    var arrSearchFriend : [Friend] = []
    
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Friend List"
        getFriendList()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: -  API call
    
    func getFriendList() {
        
        let url = WebService.createURLForWebService(WebService.UserFriendList)
        SVProgressHUD.show()
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, responseKey: Response.data, successHandler: { (response) in
         
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                self.getFriendRequest()
                if let res = response as? [String : Any] {
                    if let data = res[Response.records] as? [[String:Any]] {
                        self.arrFriends = Mapper<Friend>().mapArray(JSONArray: data)
                    }
                }
                
            })
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
    func getFriendRequest() {
        let url = WebService.createURLForWebService(WebService.FriendRequestList)
        SVProgressHUD.show()
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, responseKey: Response.data, successHandler: { (response) in
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if let res = response as? [String : Any] {
                    if let data = res[Response.records] as? [[String:Any]] {
                        self.arrFriends = Mapper<Friend>().mapArray(JSONArray: data) + self.arrFriends
                    }
                }
                self.arrSearchFriend = self.arrFriends
                self.tblFriend.reloadData()
                
            })
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
    func searchFriendList(strTrem : String) {
        
        var url = WebService.createURLForWebService(WebService.SearchFriend)
        
        var parameter : [String:String] = [:]
        parameter[Request.query] = strTrem
        url = url + NetworkManager.shared.queryString(parameter)
        
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, responseKey: Response.data, successHandler: { (response) in
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if let res = response as? [String : Any] {
                    if let data = res[Response.records] as? [[String:Any]] {
                        self.arrSearchFriend = Mapper<Friend>().mapArray(JSONArray: data)
                    }
                }
                self.tblFriend.reloadData()
            })
            
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
}


extension FriendVC : UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.trimSpace == "" {
            arrSearchFriend = arrFriends
        }
        else{
            searchFriendList(strTrem: (textField.text?.trimSpace)!);
        }
        textField.resignFirstResponder()
        tblFriend.reloadData()
        
        return true
    }
    
}

extension FriendVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrSearchFriend.count > 0 ? arrSearchFriend.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrSearchFriend.count > 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.className, for: indexPath) as! FriendCell
            let friend = arrSearchFriend[indexPath.row];
            cell.lblName.text = friend.name
            cell.delegate = self
            cell.indexPath = indexPath
            cell.imgProfilePic.setImageWithActivity(friend.profile_picture_thumb, .white)
            cell.selectionStyle = .none
            cell.acceptDeclientView.isHidden = (friend.friendStatus == .get) ? false : true
            cell.btnRemove.isHidden = (friend.friendStatus == .friend) ? false : true
            cell.btnAdd.isHidden = (friend.friendStatus == .none) ? false : true
            
            return cell;
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.className, for: indexPath) as! EmptyCell
            if txtSearch.isEmpty {
                cell.lblEmpty?.text = "You have no friend"
            }
            else{
                cell.lblEmpty?.text = "No result found"
            }
            cell.selectionStyle = .none

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = getController(storyBoard: StoryBoardName.startUP, controllerIdentifier: ProfileVC.className) as! ProfileVC
        profile.friendProfile = arrSearchFriend[indexPath.row];
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(profile, animated: true)
    }
}

extension FriendVC : FriendCellDelegate {
    
    func friendAdd(indexPath : IndexPath?){
        selectedIndexPath = indexPath
        if indexPath != nil {
            let friend = arrSearchFriend[indexPath!.row];
            sendFriendRequest(friend.id!)
        }
    }
    
    func friendRemoved(indexPath: IndexPath?) {
        selectedIndexPath = indexPath
        if indexPath != nil {
            let friend = arrSearchFriend[indexPath!.row];
            removeFriendRequest(friend.id!)
        }
    }
    
    func friendRequestDecline(indexPath: IndexPath?) {
        selectedIndexPath = indexPath
        if indexPath != nil {
            let friend = arrSearchFriend[indexPath!.row];
            declineFriendRequest(friend.id!)
        }
    }
    
    func friendRequestAccepted(indexPath: IndexPath?) {
        selectedIndexPath = indexPath
        if indexPath != nil {
            let friend = arrSearchFriend[indexPath!.row];
            acceptFriendRequest(friend.id!)
        }
    }
    
    
    func sendFriendRequest(_ userID : Int) {
        let url = WebService.createURLForWebService(WebService.sendFriendRequest) + "\(userID)"
        commonFriendOprationAPICall(url, nil,.add)
    }
    
    func acceptFriendRequest(_ userID : Int) {
        let url = WebService.createURLForWebService(WebService.acceptDeclineFriendRequest) + "\(userID)"
        commonFriendOprationAPICall(url, [Request.friendRequestAnswer: "1"],.accept)
    }
    
    func declineFriendRequest(_ userID : Int) {
        let url = WebService.createURLForWebService(WebService.acceptDeclineFriendRequest)  + "\(userID)"
        commonFriendOprationAPICall(url, [Request.friendRequestAnswer: "0"],.decline)
    }
    
    func removeFriendRequest(_ userID : Int) {
        let url = WebService.createURLForWebService(WebService.removeFriend) + "\(userID)"
        commonFriendOprationAPICall(url, [Request.friendRequestAnswer: "0"],.remove)
    }
    
    func blockUser(_ userID : Int) {
        let url = WebService.createURLForWebService(WebService.UserBlock) + "\(userID)"
        commonFriendOprationAPICall(url, nil,.none)
    }
    
    func unblockUser(_ userID : Int) {
        let url = WebService.createURLForWebService(WebService.UserUnblock) + "\(userID)"
        commonFriendOprationAPICall(url, nil,.none)
    }
    
    
    func commonFriendOprationAPICall(_ url : String ,_ parameter : [String:String]?,_ action : UserAPIAction) {
        
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, responseKey:  Response.message, successHandler: { (response) in
            print("FriendOprationAPICall Response \(response)")
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                
            })
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
    
    func performFriendAction(_ action : UserAPIAction) {
        
        if selectedIndexPath != nil {
        
            if txtSearch.isEmpty  {
                
            }
            
        }
        tblFriend.reloadData()
//        if (action == .accept) {
//            self.friendProfile?.user_friend = FriendStatusConstant.friend
//            self.delegate?.friendRequestAccepted?(self.friendProfile!)
//        }
//        if (action == .add) {
//            self.friendProfile?.user_friend = FriendStatusConstant.request_sent
//            self.delegate?.friendAddedAsFriend?(self.friendProfile!)
//        }
//        if (action == .decline) {
//            self.friendProfile?.user_friend = FriendStatusConstant.request_none
//            self.delegate?.friendRequestDecline?(self.friendProfile!)
//        }
//        if (action == .remove) {
//            self.friendProfile?.user_friend = FriendStatusConstant.request_none
//            self.delegate?.friendRemoved?(self.friendProfile!)
//        }
//
//        self.setMenuOption()
//        self.getFriendList()
    }
    
    func performFriendAction(_ action : UserAPIAction, object : Friend) {
        
        
        
        
        
    }
}
