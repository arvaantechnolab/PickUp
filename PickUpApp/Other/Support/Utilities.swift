//
//  Utilities.swift
//  Knitd
//
//  Created by Arvaan on 16/03/16.
//  Copyright © 2016 Arvaan. All rights reserved.
//
//MARK: - GTNotification Alert Banner
/**
 Alert Type Enum for GTNotification Alert Banner
 
 - SUCCESS:        Success Response
 - FAILURE:        Failure Response
 - INTERNET_ERROR: Interner Reachability Issue
 */

enum AlertType : Int {
    
    case success = 0
    case failure = 1
    case internet_ERROR = 2
}

import UIKit


class Utilities: NSObject{
    
    
    //==========================================
    //MARK: - Email Validation
    //==========================================
    
    
    class func validateEmailString(_ emailString:String)->Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: emailString)
    }
    
    class func validateSpecialCharacter(_ input:String)->Bool
    {
        let regEx = "[A-Za-z0-9]*"
        let testResult = NSPredicate(format:"SELF MATCHES %@", regEx)
        return testResult.evaluate(with: input)
    }
    
    
//    //=================================================================
//    //MARK: - To Display Error Message using GTNotification Banner View
//    //=================================================================
//    
//    class func showAlertWithMessage(_ title : String, andMessage message : String, andAlertType alertType: AlertType , withDismissHandler dismissHandler: () -> Void)
//    {
//        
//        let notification: GTNotification = GTNotification()
//        notification.image = UIImage(named: "NotificationAlertIcon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        notification.blurEnabled = false
//        notification.blurEffectStyle = UIBlurEffectStyle.dark
//        notification.tintColor = UIColor.white
//        notification.animation = GTNotificationAnimation.slide
//        notification.title = title
//        notification.message = message
//        
//        switch (alertType) {
//        case AlertType.success:
//            notification.backgroundColor =  Alert_Background_Color_Success
//            break;
//            
//        case AlertType.failure:
//            notification.backgroundColor = Alert_Background_Color_Failure
//            break;
//            
//        case AlertType.internet_ERROR:
//            notification.backgroundColor = Alert_Background_Color_Internet_Failure
//            break;
//        }
//        
//        // Show the notification
//        DispatchQueue.main.async { 
//        
//            GTNotificationManager.sharedInstance.showNotification(notification)
//        }
//        
//        dismissHandler()
//        
//    }
//    
//    class func showAlertWithMessage < T: UIViewController> (_ title : String, andMessage message : String, andAlertType alertType: AlertType , delegate : T, withDismissHandler dismissHandler: () -> Void) where T: GTNotificationDelegate 
//    {
//        
//        let notification: GTNotification = GTNotification()
//        notification.image = UIImage(named: "NotificationAlertIcon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        notification.blurEnabled = false
//        notification.blurEffectStyle = UIBlurEffectStyle.dark
//        notification.tintColor = UIColor.white
//        notification.animation = GTNotificationAnimation.slide
//        notification.title = title
//        notification.message = message
//        //print("DELEGATE: \(delegate)")
//        notification.delegate = delegate
//        
//        switch (alertType) {
//        case AlertType.success:
//            notification.backgroundColor =  Alert_Background_Color_Success
//            break;
//            
//        case AlertType.failure:
//            notification.backgroundColor = Alert_Background_Color_Failure
//            break;
//            
//        case AlertType.internet_ERROR:
//            notification.backgroundColor = Alert_Background_Color_Internet_Failure
//            break;
//        }
//        
//        // Show the notification
//        DispatchQueue.main.async {
//            
//            GTNotificationManager.sharedInstance.showNotification(notification)
//        }
//        
//        dismissHandler()
//        
//    }
    
   
    //=======================================================
    //MARK: - To Save/Retrieve Objects to/from NSUserDefaults
    //=======================================================
    
    class func saveObjectToUserDefaults(_ value:AnyObject?, forKey key:String)
    {
        if value != nil
        {
            UserDefaults.standard.set(value, forKey: key);
            UserDefaults.standard.synchronize();
        }
    }
    
    
    class func getObjectFromUserDefaultsForKey(_ key:String) -> AnyObject?
    {
        return UserDefaults.standard.object(forKey: key) as AnyObject?;
    }
    
    
    class func removeObjectFromUserDefaultsForKey(_ key:String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize();
    }
    
 
    //==========================================
    //MARK: - To Convert Date To String
    //==========================================
 
    class func convertDateToStringWithFormat(_ date:Date, format:String)->String?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = format;
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let str = formatter.string(from: date);
        return str;
    }
    
    
    class func changeDate(_ date : String, fromDateFormat : String , toDateFormat : String) -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat
    
        let yourDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat =  toDateFormat  //"dd MMM,yyyy"
        return dateFormatter.string(from: yourDate!)
        
    }
    

   
    class func convertStringToDate(_ strDate:String, dateFormat:String) -> Date?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
       // formatter.timeZone = TimeZone.autoupdatingCurrent
        let date = formatter.date(from: strDate);
        
        return date;
    }
    
    class func changeTimeFormatTo12Hour(_ time : String?) -> String {
    
        if(time != nil){
            
            let dateFormatter  :DateFormatter = DateFormatter()
            
            //24 Hour Date Format
            dateFormatter.dateFormat = "HH:mm:ss"
            
            let time  = dateFormatter.date(from: time!)
            
            //Set 12 Hour Format
            dateFormatter.dateFormat = "hh:mm a"
            
            let  timeToReturn = dateFormatter.string(from: time!)
            
            //print("12 Hour Format: \(timeToReturn)")
            return timeToReturn
            
        }
        return ""
        
    }
    
    class func changeTimeFormatTo24Hour(_ time: String) -> String {
        
        let dateFormatter  :DateFormatter = DateFormatter()
        
        //12 Hour Date Format
        dateFormatter.dateFormat = "hh:mm a"
        
        let time  = dateFormatter.date(from: time)
        
        //Set 24 Hour Format
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let  timeToReturn = dateFormatter.string(from: time!)
        
        //print("24 Hour Format: \(timeToReturn)")
        return timeToReturn
        
    }
    
    
    class func convertUTCStringToDate(_ strDate:String, dateFormat:String) -> Date?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        
        formatter.timeZone = TimeZone(abbreviation: "GMT+02:00")
        
        let date = formatter.date(from: strDate);
        return date;
    }
    
    class func convertStringToDate(_ strDate : String, dateForamt : String) -> Date
    {
        
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateForamt;
        formatter.timeZone = TimeZone(abbreviation: "GMT") //NSTimeZone.defaultTimeZone()
        
        let myDate = formatter.date(from: strDate);
        return myDate!
        
    }
    
    
    class func convertLocalStringToUTCDate(_ date:Date, dateFormat:String) -> String?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        formatter.timeZone = TimeZone(abbreviation: "GMT+02:00")
        
        let str = formatter.string(from: date);
        return str;
    }
    
    class func convertDateToString(_ date:Date, dateFormat:String) -> String?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        //formatter.timeZone = TimeZone.current
        print(date)
        let str = formatter.string(from: date);
        let dtr = daySuffix(from: date)

        return str;
    }
    class func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        print(dayOfMonth)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    class func getDateTimeInLocalTimezone(_ date : String, time : String,fromDateFormat : String , toDateFormat : String) -> (String?, String?){
        
        
        let dateTime = "\(date) \(time)"
        
        let localDate = Utilities.convertUTCStringToDate(dateTime, dateFormat: "yyyy-MM-dd HH:mm:ss")!
        let localDateTime = Utilities.convertDateToStringWithFormat(localDate, format: "yyyy-MM-dd HH:mm:ss")!
        
        let date = localDateTime.components(separatedBy: " ").first! as String
        let time = localDateTime.components(separatedBy: " ").last! as String

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat
        
        let yourDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat =  toDateFormat  //"dd MMM,yyyy"
        let strDate = dateFormatter.string(from: yourDate!)
        let strTime = Utilities.changeTimeFormatTo12Hour(time)
        
        return(strDate, strTime)
        
    }
    
    class func getDateTimeInUTCTimezone(_ date : String, time : String,fromDateFormat : String , toDateFormat : String) -> (String?, String?){
        
        let dateTime = "\(date) \(time)"
        let localDate = Utilities.convertStringToDate(dateTime, dateForamt: "yyyy-MM-dd HH:mm:ss")
        let strUTCDate = Utilities.convertLocalStringToUTCDate(localDate, dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        let date = strUTCDate!.components(separatedBy: " ").first! as String
        let time = strUTCDate!.components(separatedBy: " ").last! as String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat
        
        let yourDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat =  toDateFormat  //"dd MMM,yyyy"
        let strDate = dateFormatter.string(from: yourDate!)
        let strTime = Utilities.changeTimeFormatTo12Hour(time)
        
        return(strDate, strTime)
    }
 
    class func getViewControllerFromStoryboard(_ storyboard : String,identifire : String) -> UIViewController{
        let storyBoard = UIStoryboard(name: storyboard, bundle: nil);
        return storyBoard.instantiateViewController(withIdentifier: identifire);
    }
    
    class func getHeightForTextView(_ textView: UITextView, forText strText: String) -> CGFloat {
        let temp: UITextView = UITextView(frame: textView.frame)
        temp.font = textView.font
        temp.text = strText
        let fixedWidth: CGFloat = temp.frame.size.width
        let newSize: CGSize = temp.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        return (newSize.height)
    }
    
    class func classNameAsString(_ obj: Any) -> String {
        
        //prints more readable results for dictionaries, arrays, Int, etc
        return String(describing: type(of: (obj) as AnyObject)).components(separatedBy: "__").last!
    }
    
    class func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }
    
    class func printParameter(_ parameter : [String : Any]?, _ title : String = "Parameter") {
        if parameter == nil {
            return
        }
        
        print("\n\n\n\n-----------------------\(title)----------------------------\n")
        for (key,value) in parameter! {
            print("\(key):\(value)")
        }
        print("\n-----------------------*********----------------------------\n")
    }
    
}
