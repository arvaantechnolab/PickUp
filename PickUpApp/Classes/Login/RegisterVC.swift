//
//  RegisterVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 26/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit
import IQKeyboardManagerSwift


class RegisterVC: UIViewController {

    @IBOutlet weak var txtFirstName : AMTextField?
    @IBOutlet weak var txtLastName : AMTextField?
    @IBOutlet weak var txtEmail : AMTextField?
    @IBOutlet weak var txtPassword : AMTextField?
    @IBOutlet weak var txtConfirmPassword : AMTextField?
    
    @IBOutlet weak var btnSignup : UIButton?
    @IBOutlet weak var btnFacebook : UIButton?
    @IBOutlet weak var btnBack : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        btnBack?.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3  )
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: -  Action method
    
    
    @IBAction func btnBackClicked(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegisterClicked(_ sender : UIButton) {
        if isValidData() {
            registerUser()
        }
    }
    
    @IBAction func btnFacebookClicked(_ sender : UIButton) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["user_about_me", "email" , "user_birthday","user_hometown"], from: self) { (loginResult, error) in
            if error != nil
            {
                print(error?.localizedDescription)
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else
            {
                
                if loginResult?.grantedPermissions == nil
                {
                    print("Login Permissions not granted")
                    SVProgressHUD.showError(withStatus: "Login Permissions not granted")
                    return
                }
                
                if (loginResult?.grantedPermissions.contains("email"))!
                {
                    
                    self.getFBUserData()
                    
                    
                }
            }
        }
    }
    
    
    func getFBUserData()
    {
        
        
        FBSDKGraphRequest.init(graphPath: "me?fields=id,name,email,first_name,last_name,cover,picture.type(large),gender,birthday,hometown", parameters: nil).start(completionHandler: { (connection , result , error ) in
            
            if(error == nil){
                
                DispatchQueue.main.async {
                    let dictionary = result as! NSDictionary
                    
                    print(dictionary)
                    print("Name : \(dictionary.value(forKey: "name")!)")
                    print("FB ID : \(dictionary.value(forKey: "id")!)")
                    print("Email : \(dictionary.value(forKey: "email")!)" )
                    
                    let firstName = dictionary.value(forKey: "first_name") as? String ?? ""
                    let last_name = dictionary.value(forKey: "last_name") as? String ?? ""
                    let email = dictionary.value(forKey: "email") as? String ?? ""
                    let fbid = dictionary.value(forKey: "id") as? String ?? ""
                    
                    if fbid != ""  {
                        self.socialloginAPICall(firstName: firstName, lastName: last_name, email: email, fbID: fbid)
                    }
                    
                }
                
            }else{
                SVProgressHUD.dismiss()
                
                print("Somthig Went Wrong..!")
                
            }
        })
        
    }
    
    
    func isValidData() -> Bool{
        
        
        if (txtFirstName!.isEmpty){
            AlertView.showOKMessageAlert("Please enter first name", viewcontroller: self)
            return false
        }
        
        if txtLastName!.isEmpty {
            AlertView.showOKMessageAlert("Please enter last name", viewcontroller: self)
            return false;
        }
        if (txtEmail!.isEmpty){
            AlertView.showOKMessageAlert("Please enter valid email address", viewcontroller: self)
            return false
        }
        if (txtEmail!.text?.isValidEmail() == false){
            AlertView.showOKMessageAlert("Please enter valid email address", viewcontroller: self)
            return false
        }
        
        if txtPassword!.isEmpty {
            AlertView.showOKMessageAlert("Please enter password", viewcontroller: self)
            return false;
        }
        if txtConfirmPassword!.isEmpty {
            AlertView.showOKMessageAlert("Please enter confirm password", viewcontroller: self)
            return false;
        }
        
        if txtPassword?.text != txtConfirmPassword?.text {
            AlertView.showOKMessageAlert("Password does not match.", viewcontroller: self)
            return false;
        }
        
        
        return true
    }
    
    func moveToHomeScreen(){
        let tabVC = getController(storyBoard: StoryBoardName.home, controllerIdentifier: TabViewController.className)
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
    
    func registerUser(){
        
        let url = WebService.createURLForWebService(WebService.Register)
        var parameter : [String:Any] = [:]
        parameter[Request.email] = txtEmail!.text!.trimSpace
        parameter[Request.first_name] = txtFirstName!.text!.trimSpace
        parameter[Request.last_name] = txtLastName!.text!.trimSpace
        parameter[Request.password] = txtPassword!.text!.trimSpace
        parameter[Request.confirm_password] = txtConfirmPassword!.text!.trimSpace
        
        
        SVProgressHUD.show()
        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
            
            DispatchQueue.main.async(execute: {
                
                AlertView.showAlert(APP_NAME, strMessage: "Registration completed\n Please check your mail to verify email address", button: ["OK"], viewcontroller: self, blockButtonClicked: { (index) in
                    DispatchQueue.main.async(execute: {
                        self.navigationController?.popViewController(animated: true)
                    });
                })
                
                SVProgressHUD.dismiss()
            });
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
    
    func socialloginAPICall(firstName : String, lastName : String, email : String, fbID : String){
        
        
        let url = WebService.createURLForWebService(WebService.SocialLogin)
        var parameter : [String:Any] = [:]
        parameter[Request.email] = email
        parameter[Request.first_name] = firstName
        parameter[Request.last_name] = lastName
        parameter[Request.facebook_id] = fbID
        
        
        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
            if let userInfo = response as? [String : Any] {
                AppData.shared.saveUserInfo(userInfo)
            }
            DispatchQueue.main.async(execute: {
                self.moveToHomeScreen()
                SVProgressHUD.dismiss()
            });
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
        
    }

    
}
