//
//  ProfileVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 29/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

enum UserAPIAction : Int {
    case none = 0,
    accept,
    decline,
    remove,
    add
}

@objc protocol ProfileDelegate : NSObjectProtocol{
    
    @objc optional func friendRequestAccepted(_ friend : Friend)
    @objc optional func friendRequestDecline(_ friend : Friend)
    @objc optional func friendRemoved(_ friend : Friend)
    @objc optional func friendAddedAsFriend(_ friend : Friend)
}


class ProfileVC: UIViewController {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var txtMobile : AMTextField!
    @IBOutlet weak var txtEmail : AMTextField!
    @IBOutlet weak var txtGender : AMTextField!
    
    @IBOutlet weak var imgProfile : UIImageView!
    
    
    
    @IBOutlet weak var btnEditProfile : UIButton!
    @IBOutlet weak var btnMenu : UIButton!
    
    @IBOutlet weak var collectionOfSport : UICollectionView!
    
    var selectedSportIndex = -1;
    
    var delegate : ProfileDelegate?
    
    var friendProfile : Friend?
    var userProfile : User?
    var playerProfile : Player?
    
    var arrMenuOption : [String] = []
    var arrUserSport : [Sport] = []
    
    var isFriendRequest = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedSportIndex = 0
        arrUserSport = getArrarSport()
        collectionOfSport.reloadData()
        
        txtMobile.leftImage = "phone-icon"
        txtGender.leftImage = "male-yellow"
        txtEmail.leftImage = "mail-yellow"
        btnMenu.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0)
        setUserInfo()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInfo()

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserInfo (){
        
        if  userProfile != nil {

            let name = userProfile?.name ?? ""
            let gender = userProfile?.gender ?? ""
            let mobile_no = userProfile?.mobile_no ?? ""
            let email = userProfile?.email ?? ""

            
            lblName.text = name
            txtEmail.text = email
            txtGender.text = gender
            txtMobile.text = mobile_no == "" ? "Not Provided" : mobile_no
            
            imgProfile?.setImageWithActivity(userProfile?.profile_picture_thumb, UIActivityIndicatorViewStyle.gray)
            btnMenu.isHidden = true;
        }
        
        else if friendProfile != nil {
            let name = friendProfile?.name ?? ""
            let gender = friendProfile?.gender ?? ""
            let mobile_no = friendProfile?.mobile_no ?? ""
            let email = friendProfile?.email ?? ""
            
            
            lblName.text = name
            txtEmail.text = email
            txtGender.text = gender
            txtMobile.text = mobile_no == "" ? "Not Provided" : mobile_no
            
            imgProfile?.setImageWithActivity(friendProfile?.profile_picture_thumb, UIActivityIndicatorViewStyle.gray)
            btnEditProfile.isHidden = true
            
            self.setMenuOption()
            
        }
        
        else if playerProfile != nil {
            let name = playerProfile?.first_name ?? ""
            let gender = playerProfile?.gender ?? ""
            let mobile_no = playerProfile?.mobile_no ?? ""
            let email = playerProfile?.email ?? ""
            
            
            lblName.text = name
            txtEmail.text = email
            txtGender.text = gender
            txtMobile.text = mobile_no == "" ? "Not Provided" : mobile_no
            
            imgProfile?.setImageWithActivity(playerProfile?.profile_picture_thumb, UIActivityIndicatorViewStyle.gray)
            btnEditProfile.isHidden = true
           
        }
        
    }
    
    func getArrarSport() -> [Sport]{
        
        var arr : [Sport] = []
        arr.append(Sport(name: "Basketball", selecedImage: #imageLiteral(resourceName: "basketballSelected"), normalImage: #imageLiteral(resourceName: "basketball")))
        arr.append(Sport(name: "Volleyball", selecedImage: #imageLiteral(resourceName: "vollyballSelected"), normalImage: #imageLiteral(resourceName: "vollyball")))
        arr.append(Sport(name: "Football", selecedImage: #imageLiteral(resourceName: "footballSelected"), normalImage: #imageLiteral(resourceName: "football")))
        
        return arr
    }
    
    func setMenuOption() {
        
        self.arrMenuOption = []
        
        if let friend = friendProfile?.friendStatus {
            
            if friend == .friend {
                arrMenuOption.append("Remove From Friend")
            }
            else if friend == .get {
                arrMenuOption.append("Accept")
                arrMenuOption.append("Decline")
            }
            else if friend == .none{
                arrMenuOption.append("Add As Friend")
            }
        }
        
        
        if let block = friendProfile?.user_block {
            if block == 1{
                arrMenuOption.append("Unblock")
            }
            else{
                arrMenuOption.append("Block")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func btnEditProfileClicked() {
        let editProfile = getController(storyBoard: StoryBoardName.startUP, controllerIdentifier: EditProfileVC.className) as! EditProfileVC
        editProfile.delegate = self
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    @IBAction func btnMenuClicked() {
        AlertView.showActionSheetWithCancelButton(true, title: "Menu", buttons: arrMenuOption, viewcontroller: self) { (index) in
           self.handleMenuAction(index: index)
        }
    }
    

    @IBAction func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    //MARK: -  API call
    
    func handleMenuAction(index : Int) {
        print("friendProfile!.id! \(friendProfile?.id)")
        switch arrMenuOption[index] {
        case "Add As Friend" :
            sendFriendRequest(friendProfile!.id!)
            break
        case "Remove From Friend" :
            removeFriendRequest(friendProfile!.id!)
            break
        case "Accept" :
            acceptFriendRequest(friendProfile!.id!)
            break
        case "Decline" :
            declineFriendRequest(friendProfile!.id!)
            break
        case "Unblock" :
            blockUser(friendProfile!.id!)
            break
        case "Block" :
            unblockUser(friendProfile!.id!)
            break
        default :
            print("no option found")
            
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
                if (action == .accept) {
                    self.friendProfile?.user_friend = FriendStatusConstant.friend
                    self.delegate?.friendRequestAccepted?(self.friendProfile!)
                }
                if (action == .add) {
                    self.friendProfile?.user_friend = FriendStatusConstant.request_sent
                    self.delegate?.friendAddedAsFriend?(self.friendProfile!)
                }
                if (action == .decline) {
                    self.friendProfile?.user_friend = FriendStatusConstant.request_none
                    self.delegate?.friendRequestDecline?(self.friendProfile!)
                }
                if (action == .remove) {
                    self.friendProfile?.user_friend = FriendStatusConstant.request_none
                    self.delegate?.friendRemoved?(self.friendProfile!)
                }
                
                self.setMenuOption()
                
            })
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
    
}

extension ProfileVC : EditProfileDelegate {
    func profileEdited() {
        
        userProfile = appUser
        
    }
}

extension ProfileVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUserSport.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SportCell.className, for: indexPath) as! SportCell
        cell.lblName?.text = arrUserSport[indexPath.row].name
        if indexPath.row == selectedSportIndex {
            cell.imgIcon?.image = arrUserSport[indexPath.row].selectedIconImage
        }
        else{
            cell.lblName?.text = ""
            cell.imgIcon?.image = arrUserSport[indexPath.row].iconImage
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedSportIndex = indexPath.row
        collectionOfSport.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
             layout collectionViewLayout: UICollectionViewLayout,
                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == selectedSportIndex {
            return CGSize(width: collectionView.frame.size.height + 100, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: collectionView.frame.size.height  + 14, height: collectionView.frame.size.height)
        }
        
    }
    
}
