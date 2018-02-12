//
//  AlertView.swift
//  Knitd
//
//  Created by Arvaan Techno-lab Pvt Ltd on 10/02/16.
//  Copyright © 2016 ArvaanTechnolabs. All rights reserved.
//

import UIKit


typealias buttonClicked = (NSInteger) -> Void

class AlertAction : UIAlertAction{
    
    var  tag : NSInteger?
    
}

class AlertView: NSObject {
    
    static let sharedInstance = AlertView()
    fileprivate override init() {} //This prevents others from using the default '()' initializer for
    
    var alertController : UIAlertController?
    
    
    
    class func showOKTitleAlert(_ strTitle : String, viewcontroller : UIViewController){
        
        AlertView.showAlert(strTitle.localizedString(), strMessage: "", button: NSMutableArray(object: "Ok".localizedString()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showOKMessageAlert(_ strMessage : String, viewcontroller : UIViewController){
        AlertView.showAlert(APP_NAME, strMessage: strMessage, button:  NSMutableArray(object: "Ok".localizedString()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showOKTitleMessageAlert(_ strTitle : String,strMessage : String, viewcontroller : UIViewController){
        AlertView.showAlert(strTitle.localizedString(), strMessage: strMessage, button:  NSMutableArray(object: "Ok".localizedString()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showYesNoTitleMessageAlert(_ strTitle : String,strMessage : String, viewcontroller : UIViewController,blockButtonClicked : buttonClicked?){
        let arr = NSMutableArray();
        
        arr.add("Yes".localizedString());
        arr.add("No".localizedString());
        
        AlertView.showAlert(strTitle.localizedString(), strMessage: strMessage, button:  NSMutableArray(objects: arr),viewcontroller : viewcontroller, blockButtonClicked: blockButtonClicked)
    }
    
    
   
    class func showAlert(_ strTitle : String,strMessage : String,button:NSMutableArray, viewcontroller : UIViewController, blockButtonClicked : buttonClicked?){
        
        print(strTitle);
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertControllerStyle.alert);
        alert.view.tintColor = UIColor.black
        
        for i in 0  ..< button.count {

            let str = button.object(at: i) as? String;
            let action = AlertAction(title: str, style: UIAlertActionStyle.default) { (a) -> Void in
               
                blockButtonClicked?((a as! AlertAction).tag!)
            }
            
            action.tag = i
            alert.addAction(action);
        }
        
        viewcontroller.present(alert, animated: true) { () -> Void in
            
        }
        
    }
    
    class func showActionSheetWithCancelButton(_ isCancelButton : Bool, title : String?,buttons:[String],viewcontroller : UIViewController, blockButtonClicked : buttonClicked?){
        
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = UIColor.black
        for i in 0  ..< buttons.count {
            
            let str = buttons[i];
            let action = AlertAction(title: str, style: UIAlertActionStyle.default) { (action) -> Void in
                
                blockButtonClicked?((action as! AlertAction).tag!)
            }
            
            action.tag = i
            alert.addAction(action);
        }
        
        if isCancelButton{

            let cancelAction = AlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { (action) in
                //blockButtonClicked?((action as! AlertAction).tag!)
            })
            cancelAction.tag = buttons.count
            alert.addAction(cancelAction)
        }
        
        viewcontroller.present(alert, animated: true) { () -> Void in
        }
    }
}
