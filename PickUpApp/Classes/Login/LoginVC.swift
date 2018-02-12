//
//  LoginVC.swift
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

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail : AMTextField?
    @IBOutlet weak var txtPassword : AMTextField?
    
    @IBOutlet weak var btnForgetPassword : UIButton?
    @IBOutlet weak var btnRememberMe : UIButton?
    @IBOutlet weak var btnLogin : UIButton?
    @IBOutlet weak var btnFacebook : UIButton?
    
    @IBOutlet weak var viewforgetContainer : UIView!
    @IBOutlet weak var txtForgetEmail : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        btnRememberMe?.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5 )

        // Do any additional setup after loading the view.
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true

        
//        txtEmail?.text = "dilip.arvaa.n@gmail.com"
//        txtPassword?.text = "dilip@123"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let email = UserDefaults.standard.object(forKey: "loginEmail")  as? String{
            txtEmail?.text = email
        }
        if let pass = UserDefaults.standard.object(forKey: "loginPassword") as? String{
            txtPassword?.text = pass
            
        }
        
        self.btnRememberMe?.isSelected = txtPassword?.isEmpty == false ? true : false
        
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

    
    func moveToHomeScreen(){
        let tabVC = getController(storyBoard: StoryBoardName.home, controllerIdentifier: TabViewController.className)
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
    
    //MARK: -  Action method
    
    @IBAction func btnLoginClicked(_ sender : UIButton) {
        if isValidData() {
            loginAPICall()
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
    
    
    
    
    
    @IBAction func btnRememberMeClicked(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnForgetPasswordClicked(_ sender : UIButton) {
        viewforgetContainer.frame = self.view.bounds
        self.view.addSubview(viewforgetContainer)
        
    }
    
    @IBAction func btnHideForgetPasswordView(_ sender : UIButton) {
        viewforgetContainer.removeFromSuperview()
    }
    
    @IBAction func btnForgetPasswordsubmit(_ sender : UIButton) {
        if (txtForgetEmail!.text?.isValidEmail() == false){
            AlertView.showOKMessageAlert("Please enter valid email address", viewcontroller: self)
        }
        else{
            forgetPassword(email: txtForgetEmail!.text!.trimSpace)
        }
    }

    @IBAction func btnRegisterClicked(_ sender : UIButton) {
        let ragisterVC = getController(storyBoard: StoryBoardName.startUP, controllerIdentifier: RegisterVC.className)
        self.navigationController?.pushViewController(ragisterVC, animated: true)
    }
    
    //MARK: -  Support Method
   
    func clearAllFeild() {
        self.txtPassword?.text = ""
        self.txtEmail?.text = ""
        self.txtForgetEmail?.text = ""
    }
    
    
    func isValidData() -> Bool{
        
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
        return true
    }
    
    //MARK: -  API Call
    
    func loginAPICall(){
       
        
        let url = WebService.createURLForWebService(WebService.Login)
        let parameter = [Request.email:txtEmail!.text!.trimSpace,Request.password:txtPassword!.text!.trimSpace,Request.fcmId:"Not Done Yet?"]
        
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
            
            print("response \(response)")
            if let userInfo = response as? [String : Any] {
                if self.btnRememberMe?.isSelected ==  true {
                
                    UserDefaults.standard.set(self.txtEmail!.text!.trimSpace, forKey: "loginEmail")
                    UserDefaults.standard.set(self.txtPassword!.text!.trimSpace, forKey: "loginPassword")
                    
                }
                else{
                    UserDefaults.standard.set("", forKey: "loginEmail")
                    UserDefaults.standard.set("", forKey: "loginPassword")
                }
                AppData.shared.saveUserInfo(userInfo)
                
                UserDefaults.standard.set(userInfo["token"] as? String, forKey: "DeviceToken")
                print( userInfo["token"] as? String)
                appUser = AppData.shared.getUserInfo()
            }
            
            
            DispatchQueue.main.async(execute: {
                self.moveToHomeScreen()
                self.clearAllFeild()
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
        parameter[Request.fcmId] = "Not Done Yet"
        
        SVProgressHUD.dismiss()
        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
            if let userInfo = response as? [String : Any] {
                AppData.shared.saveUserInfo(userInfo)
            }
            DispatchQueue.main.async(execute: {
                self.moveToHomeScreen()
                SVProgressHUD.dismiss()
                self.clearAllFeild()
            });
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
        
    }

    
    func getFBUserData()
    {
        
        
        FBSDKGraphRequest.init(graphPath: "me?fields=id,name,email,first_name,last_name,cover,picture.type(large),gender,birthday,hometown", parameters: nil).start(completionHandler: { (connection , result , error ) in
            
            if(error == nil){
                
                DispatchQueue.main.async {
                    let dictionary = result as! NSDictionary
                    
                    print("FB Dic \(dictionary)")

                    let firstName = dictionary.value(forKey: "first_name") as? String ?? ""
                    let last_name = dictionary.value(forKey: "last_name") as? String ?? ""
                    let email = dictionary.value(forKey: "email") as? String ?? ""
                    let fbid = dictionary.value(forKey: "id") as? String ?? ""

                    
                    if email == "" {
                        
                        let alert = UIAlertController(title: "", message: "App not able to fatch your email from Facebook, please provide us email to connect", preferredStyle: .alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextField { (textField) in
                            textField.placeholder = "Email"
                        }
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                            
                            if textField.isEmpty == true{
                                AlertView.showOKMessageAlert("Please provide email address", viewcontroller: self)
                                return
                            }
                            if textField.text?.trimSpace.isValidEmail() == false {
                                AlertView.showOKMessageAlert("Please provide valid email address", viewcontroller: self)
                                return
                            }
                            
                            if fbid != "" {
                                self.socialloginAPICall(firstName: firstName, lastName: last_name, email: textField.text!, fbID: fbid)
                            }
                            else{
                                AlertView.showOKMessageAlert("There is some issue with your facebook. app is not able get your facebook id. Please check yout facebook setting", viewcontroller: self)
                            }

                            
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {  (_) in
                            
                        }))
                        
                        // 4. Present the alert.
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        if fbid != "" {
                            self.socialloginAPICall(firstName: firstName, lastName: last_name, email: email, fbID: fbid)
                        }
                        else{
                            AlertView.showOKMessageAlert("There is some issue with your facebook. app is not able get your facebook id. Please check yout facebook setting", viewcontroller: self)
                        }
                    }
                    
//                    print("Name : \(dictionary.value(forKey: "name")!)")
//                    print("FB ID : \(dictionary.value(forKey: "id")!)")
//                    print( "Email : \(dictionary.value(forKey: "email")!)" )
                    
//
                    
                }
                
            }else{
                SVProgressHUD.dismiss()
                
                print("Somthig Went Wrong..!")
                
            }
        })
        
    }
    
    
    
    func forgetPassword( email : String){
        
        let url = WebService.createURLForWebService(WebService.ForgotPassword)
        var parameter : [String:Any] = [:]
        parameter[Request.email] = email
        SVProgressHUD.show()

        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
            
            DispatchQueue.main.async(execute: {
                self.viewforgetContainer.removeFromSuperview()
                self.clearAllFeild()
                SVProgressHUD.showSuccess(withStatus: "Reset Password instruction send to your email address")
            });
            
        }) { (errorString) in
//            SVProgressHUD.showError(withStatus: errorString)
            SVProgressHUD.showSuccess(withStatus: "Reset Password instruction send to your email address")
        }
        
    }
}


