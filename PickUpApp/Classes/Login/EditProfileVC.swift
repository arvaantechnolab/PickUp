//
//  EditProfileVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 29/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD


@objc protocol EditProfileDelegate : NSObjectProtocol{
    
    @objc optional func profileEdited()
    
}


class EditProfileVC: UIViewController {

    @IBOutlet weak var txtUserName : AMTextField?
    @IBOutlet weak var txtLastName : AMTextField?
    @IBOutlet weak var txtFirstName : AMTextField?
    @IBOutlet weak var txtContact : AMTextField?
    @IBOutlet weak var txtDateOfBirth : AMTextField?
    @IBOutlet weak var txtFavorite : AMTextField?
    @IBOutlet weak var txtWinloss : AMTextField?
    @IBOutlet weak var txtPointEarn : AMTextField?
    
    @IBOutlet weak var datePickerContainer : UIView?
    @IBOutlet weak var datePicker : UIDatePicker?
    
    @IBOutlet weak var imgProfile : UIImageView?
    
    @IBOutlet weak var btnUpdateUserProfile : UIButton?
    @IBOutlet weak var btnUpdateProfilePic : UIButton?
    @IBOutlet weak var btnFemale : UIButton?
    @IBOutlet weak var btnMale : UIButton?
    @IBOutlet weak var btnBack : UIButton?
    
    var selectedGender = Gender.male
    var delegate : EditProfileDelegate?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUserInfo()
        txtDateOfBirth?.inputView = datePickerContainer
        
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUserInfo (){
        
        if appUser != nil {
            
            imgProfile?.setImageWithActivity(appUser?.profile_picture_thumb, UIActivityIndicatorViewStyle.gray)
            txtFirstName?.text = appUser?.first_name
            txtLastName?.text = appUser?.last_name
            txtUserName?.text = appUser?.user_name
            txtContact?.text = appUser?.mobile_no
            
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

    //MARK: -  Action method
    
    @IBAction func btnGenderClicked(_ sender : UIButton){
        selectedGender = Gender(rawValue: sender.tag)!
        btnMale?.setImage(selectedGender == .male ? #imageLiteral(resourceName: "radio-selected") : #imageLiteral(resourceName: "radio-unSelected"), for: .normal)
        btnFemale?.setImage(selectedGender == .female ? #imageLiteral(resourceName: "radio-selected") : #imageLiteral(resourceName: "radio-unSelected"), for: .normal)
    }
    
    @IBAction func btnEditProfilePicClicked(){
        AlertView.showActionSheetWithCancelButton(true, title: "", buttons: ["Take Photo","Choose Photo"], viewcontroller: self) { (index) in
            if (index == 0) {
                self.showImagePickerWithSource(.camera)
            }
            else if index ==  1 {
                self.showImagePickerWithSource(.photoLibrary)
            }
        }
    }
    
    @IBAction func btnUpdateUserProfileClicked(){
        
        if txtFirstName!.isEmpty || txtLastName!.isEmpty {
            AlertView.showOKMessageAlert("first name , last name and user name can not be empty", viewcontroller: self);
            return
        }
        
        let url = WebService.createURLForWebService(WebService.UpdateProfile)
        var paramater : [String:Any] = [:]
        paramater[Request.first_name] = txtFirstName!.text!.trimSpace
        paramater[Request.last_name] = txtLastName!.text!.trimSpace
        paramater[Request.mobile_no] = txtContact?.text?.trimSpace
        paramater[Request.username] = txtUserName?.text?.trimSpace
        paramater[Request.date_of_birth] = txtDateOfBirth?.text?.trimSpace
        paramater[Request.gender] = selectedGender.getStringValue()
        
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: paramater, successHandler: { (response) in
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                
                if let res = response as? [String : Any] {
                    AppData.shared.saveUserInfo(res)
                }
                
                if let user = AppData.shared.getUserInfo() {
                    appUser = user
                }
                self.setUserInfo()
                self.delegate?.profileEdited?()
//
//                if let userInfo = response as? [String : Any] {
//                    AppData.shared.saveUserInfo(userInfo)
//                }
                
            })
            
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
        
    }
    
    @IBAction func btnBackClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: -  Image Picker Method
    
    func showImagePickerWithSource (_ source : UIImagePickerControllerSourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) == false {
            AlertView.showOKMessageAlert("Selected source type is not available in your device", viewcontroller: self)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.isEditing = true
        picker.allowsEditing = true
      //  picker.cameraCaptureMode = .photo
        
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    
}

extension EditProfileVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtDateOfBirth == textField {
            txtDateOfBirth?.text = Utilities.convertDateToString(datePicker!.date, dateFormat: DateFormat.DateOfBirth)
        }
    }
}

//MARK: -  UIImagePickerController Delegate
extension EditProfileVC : UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info \(info)")
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            changeProfilePicture(image)
        }
        
    }
    
    func changeProfilePicture(_ image : UIImage){
        
        SVProgressHUD.show()
        let url = WebService.createURLForWebService(WebService.UpdateProfilePicture)
        var parameter : [String : AnyObject] = [:]
        parameter[Request.image] = image
        
        NetworkManager.shared.multipartRequestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
            print("response \(response)")
            if let res = response as? [String:Any] {
                
                if let res = response as? [String : Any] {
                    AppData.shared.saveUserInfo(res)
                }
                
                if let user = AppData.shared.getUserInfo() {
                    appUser = user
                }
                
                self.setUserInfo()
                self.delegate?.profileEdited?()
                if let message = res[Response.message] as? String {
                    SVProgressHUD.showSuccess(withStatus: message)
                    return
                }
             }
//            if let message = (response as? [String:Any])[Response.message] {
//                SVProgressHUD.showSuccess(withStatus: message)
//            }
            SVProgressHUD.dismiss()
            
        }, progressHandler: { (progress) in
            print("progress \(progress)")
            SVProgressHUD.showProgress(progress, status: "Uploading")
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
        
    }
    
}
