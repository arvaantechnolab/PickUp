//
//  SideMenuVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 28/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

enum MenuOption:Int{
    
    case myprofile = 0,
    team,
    games,
    friends,
    setting,
    notification
    
}

class MenuContainerView : UIView {
    
    override var frame: CGRect {
        didSet {
            //print("new frame \(oldValue) \(frame)")
        }
    }
}

class SideMenuVC: UIViewController {
    
    @IBOutlet var menuContainerView: MenuContainerView!
    @IBOutlet var tblMenu : UITableView?
    @IBOutlet var lblName : UILabel?
    @IBOutlet var imgProfile: UIImageView?
    
    
    var arrMenu : [[String : Any]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMenuArray()
        self.view.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserInfo(){
        
        if appUser != nil{
            lblName?.text = appUser?.name
            if let profileURL = appUser?.profile_picture_thumb {
                imgProfile?.setImageWithActivity(profileURL, UIActivityIndicatorViewStyle.white)
            }
        }
        
    }
    
    func createMenuArray(){
        
        arrMenu.append(["title":"My Profile","icon":"my-profile-icon"])
        arrMenu.append(["title":"Team","icon":"team-preview-icon"])
        arrMenu.append(["title":"Games","icon":"games-preview-icon"])
        arrMenu.append(["title":"Friends","icon":"friends-preview-icon"])
        arrMenu.append(["title":"Setting","icon":"setting-preview-icon"])
        arrMenu.append(["title":"Notification","icon":"notification-preview-icon"])
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnShowProfileClicked() {
        let profile = getController(storyBoard: StoryBoardName.startUP, controllerIdentifier: ProfileVC.className) as! ProfileVC
        profile.userProfile = appUser
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(profile, animated: true)
    }
    
    func showFriendVC() {
        let friendVC = getController(storyBoard: StoryBoardName.friend, controllerIdentifier: FriendVC.className)
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(friendVC, animated: true)
    }
    
    func showGameVC() {
        let gameScreen = getController(storyBoard: StoryBoardName.home, controllerIdentifier: HomeVC.className)
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(gameScreen, animated: true)
    }
    
    func showSettingVC() {
        let settingScreen = getController(storyBoard: StoryBoardName.home, controllerIdentifier: SettingVC.className)
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(settingScreen, animated: true)
    }
    
    func showTeamVC() {
        let teamScreen = getController(storyBoard: StoryBoardName.team, controllerIdentifier: TeamListVC.className)
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(teamScreen, animated: true)
    }
    
    func openingSideMenu(){
        
        //Set Side Menu Content
//        isCommunitiTapped = false
//        menuArray = createArrayOfMenus()
//        iconArray = iconArrayOfFilters()
//        tableView.reloadData()
//        setSideMenuContent()
      
        tblMenu?.reloadData()
        setUserInfo()
        
    }
    
    func closingSideMenu()
    {
        
    }
    
    @IBAction func btnClosingSideMenuClicked(){
        mainNavController?.sideMenuClosePressed()
    }

}


extension SideMenuVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblMenuName?.text = arrMenu[indexPath.row]["title"] as? String
        
        if let imageName = arrMenu[indexPath.row]["icon"] as? String {
            cell.imgIcon?.image = UIImage(named : imageName)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == MenuOption.myprofile.rawValue {
            btnShowProfileClicked()
        }
        else if indexPath.row == MenuOption.friends.rawValue {
            showFriendVC()
        }
        else if indexPath.row == MenuOption.games.rawValue {
            showGameVC()
        }
        else if indexPath.row == MenuOption.setting.rawValue {
            showSettingVC()
        }
        else if indexPath.row == MenuOption.team.rawValue {
            showTeamVC()
        }
        
        
        btnClosingSideMenuClicked()
    }
}

