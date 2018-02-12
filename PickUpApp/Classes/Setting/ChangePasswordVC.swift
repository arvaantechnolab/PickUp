//
//  ChangePasswordVC.swift
//  PickUpApp
//
//  Created by Amul Patel on 1/12/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class ChangePasswordVC: BaseViewController , UITextFieldDelegate{

    @IBOutlet weak var txtConfirmPassword: AMTextField!
    @IBOutlet weak var txtNewPassword: AMTextField!
    @IBOutlet weak var txtOldPassword: AMTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Change Password"
    }
    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func isValidData() -> Bool{
     
        if txtOldPassword!.isEmpty {
            AlertView.showOKMessageAlert("Please enter old password", viewcontroller: self)
            return false;
        }
        if txtNewPassword!.isEmpty {
            AlertView.showOKMessageAlert("Please enter  password", viewcontroller: self)
            return false;
        }
        if txtConfirmPassword!.isEmpty {
            AlertView.showOKMessageAlert("Please enter confirm password", viewcontroller: self)
            return false;
        }
        
        if txtNewPassword?.text != txtConfirmPassword?.text {
            AlertView.showOKMessageAlert("Password does not match.", viewcontroller: self)
            return false;
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtOldPassword
        {
            txtOldPassword.resignFirstResponder()
            txtNewPassword.becomeFirstResponder()
        }
        else if textField == txtNewPassword
        {
            txtNewPassword.resignFirstResponder()
            txtConfirmPassword.becomeFirstResponder()
        }
        else if textField == txtConfirmPassword
        {
            txtConfirmPassword.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.view.endEditing(true)
        }
        return true
    }
    

    @IBAction func btnChangePasswordTapped(_ sender: UIButton)
    {
        if isValidData()
        {
            let url = WebService.createURLForWebService(WebService.changePassword)
            var parameter : [String:Any] = [:]
            parameter[Request.password] = txtOldPassword!.text!.trimSpace
            parameter[Request.newPassword] = txtNewPassword!.text!.trimSpace
           
            
            
            SVProgressHUD.show()
            NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
                
                DispatchQueue.main.async(execute: {
                    
                    AlertView.showAlert(APP_NAME, strMessage: "Your password update sucessfully", button: ["OK"], viewcontroller: self, blockButtonClicked: { (index) in
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
    }
    

}
