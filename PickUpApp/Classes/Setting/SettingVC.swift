//
//  SettingVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 10/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

enum SettingMenu : Int {
    
    case editProfile = 0,
    notification,
    replyTutorial,
    inviteFriend,
    changePassword,
    help,
    termsAndCondition,
    aboutUs,
    logout,
    deleteAccount
    
}

struct SettingMenuKey {
    static let title = "Title"
    static let option = "Option"
    static let isSwitchNeed = "isSwitchNeed"
}

class SettingVC: BaseViewController {

    @IBOutlet weak var tblSetting: UITableView!
    
    var arrMenuList : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSettingMenuOption()
        tblSetting.reloadData()
        
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Setting"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    

    func createSettingMenuOption() {
     
        var arr : [[String:Any]] = []
        
        arr.append([SettingMenuKey.title:"Edit Profile", SettingMenuKey.option:SettingMenu.editProfile, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"Notification", SettingMenuKey.option:SettingMenu.notification, SettingMenuKey.isSwitchNeed:true])
        arr.append([SettingMenuKey.title:"Replay Tutorial", SettingMenuKey.option:SettingMenu.replyTutorial, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"Invite Friend", SettingMenuKey.option:SettingMenu.inviteFriend, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"Change Password", SettingMenuKey.option:SettingMenu.changePassword, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"Help & Feedback", SettingMenuKey.option:SettingMenu.help, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"Terms & conditions", SettingMenuKey.option:SettingMenu.termsAndCondition, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"About us", SettingMenuKey.option:SettingMenu.aboutUs, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"Logout", SettingMenuKey.option:SettingMenu.logout, SettingMenuKey.isSwitchNeed:false])
        arr.append([SettingMenuKey.title:"Delete Account", SettingMenuKey.option:SettingMenu.deleteAccount, SettingMenuKey.isSwitchNeed:false])
        
        arrMenuList = arr
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.className, for: indexPath) as! SettingCell
        
        let option = arrMenuList[indexPath.row];
        
        cell.lblMenu.text = option[SettingMenuKey.title] as? String
        
        if let needToshow = option[SettingMenuKey.isSwitchNeed] as? Bool
        {
            cell.switchButton.isHidden = !needToshow
        }
        
        
        cell.selectionStyle = .none
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMenu : SettingMenu = SettingMenu(rawValue: indexPath.row)!
        switch selectedMenu {
        case .editProfile:
            editProfile()
            break
        case .notification:
        
            break
            
        case .replyTutorial:
            
            break
        case .inviteFriend:
            
            break
        case .changePassword:
           changePassword()
            break
        case .help:
           
            break
            
        case .termsAndCondition:
            break
            
        case .aboutUs:
           
            break
        case .logout:
            logout()
            break
            
        case .deleteAccount:
            break
          
        }
    
    }
    
    func changePassword()
    {
        let changePasswordScreen = getController(storyBoard: StoryBoardName.home, controllerIdentifier: ChangePasswordVC.className)
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(changePasswordScreen, animated: true)
    }
    
    func editProfile()
    {
        let editProfile = getController(storyBoard: StoryBoardName.startUP, controllerIdentifier: EditProfileVC.className)
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    func logout()
    {
        
        AlertView.showAlert(APP_NAME, strMessage: "Are you sure want logout?", button: ["Logout","Cancel"], viewcontroller: self, blockButtonClicked: { (index) in
            if index == 0
            {
            DispatchQueue.main.async(execute: {
                 AppData.shared.removeModelForKey(UserDefaultsKey.user)
                 self.navigationController?.popToRootViewController(animated: true)
            });
            }
            
        })
       
    }
    
}
