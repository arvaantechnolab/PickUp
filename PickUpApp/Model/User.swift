//
//  User.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 01/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class User: NSObject, Mappable, NSCoding {

    var id : Int?
    var first_name : String?
    var last_name : String?
    var user_name : String?
    var mobile_no : String?
    var email : String?
    var gender : String?
    var date_of_birth : String?
    
    var profile_picture_thumb : String?
    var profile_picture : String?
    
    var is_set_password : String?
    var created_at : String?
    var facebook_id : String?
    var is_block : String?
    var is_verified : String?
    var token : String?
    
    //==========================================
    //MARK: - Initializer Method
    //==========================================
    
    required init?(map: Map) {
        
    }
    
    //==========================================
    //MARK: - NSCoder Initializer Methods
    //==========================================
    
    required init?(coder aDecoder: NSCoder) {
        
        self.id                      = aDecoder.decodeObject(forKey: "id") as? Int
        self.first_name              = aDecoder.decodeObject(forKey: "first_name") as? String
        self.last_name               = aDecoder.decodeObject(forKey: "last_name") as? String
        self.user_name               = aDecoder.decodeObject(forKey: "user_name") as? String
        self.mobile_no               = aDecoder.decodeObject(forKey: "mobile_no") as? String
        self.email                   = aDecoder.decodeObject(forKey: "email") as? String
        self.gender                  = aDecoder.decodeObject(forKey: "gender") as? String
        self.date_of_birth           = aDecoder.decodeObject(forKey: "date_of_birth") as? String
        self.profile_picture_thumb   = aDecoder.decodeObject(forKey: "profile_picture_thumb") as? String
        self.profile_picture         = aDecoder.decodeObject(forKey: "profile_picture") as? String
        self.is_set_password         = aDecoder.decodeObject(forKey: "is_set_password") as? String
        self.created_at              = aDecoder.decodeObject(forKey: "created_at") as? String
        self.facebook_id             = aDecoder.decodeObject(forKey: "facebook_id") as? String
        self.is_block                = aDecoder.decodeObject(forKey: "is_block") as? String
        self.is_verified             = aDecoder.decodeObject(forKey: "is_verified") as? String
        self.token                   = aDecoder.decodeObject(forKey: "token") as? String

    }

    
    
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(id, forKey: "id")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(user_name, forKey: "user_name")
        aCoder.encode(mobile_no, forKey: "mobile_no")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(date_of_birth, forKey: "date_of_birth")
        aCoder.encode(profile_picture_thumb, forKey: "profile_picture_thumb")
        aCoder.encode(profile_picture, forKey: "profile_picture")
        aCoder.encode(is_set_password, forKey: "is_set_password")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(facebook_id, forKey: "facebook_id")
        aCoder.encode(is_block, forKey: "is_block")
        aCoder.encode(is_verified, forKey: "is_verified")
        aCoder.encode(token, forKey: "token")

    }
    
    //==========================================
    //MARK: - Mappable Protocol Methods
    //==========================================
    
    
    func mapping(map: Map) {
        
        id                          <- map["id"]
        first_name                  <- map["first_name"]
        last_name                   <- map["last_name"]
        user_name                   <- map["username"]
        
        mobile_no                   <- map["mobile_no"]
        email                       <- map["email"]
        gender                      <- map["gender"]
        date_of_birth               <- map["date_of_birth"]
        profile_picture_thumb       <- map["profile_picture_thumb"]
        profile_picture             <- map["profile_picture"]
        is_set_password             <- map["is_set_password"]
        created_at                  <- map["created_at"]
        facebook_id                 <- map["facebook_id"]
        is_block                    <- map["is_block"]
        is_verified                 <- map["is_verified"]
        token                       <- map["token"]
    }
    
    
    class func getUserToken() -> String {
        if appUser !=  nil {
            if appUser?.token != nil {
                return appUser!.token!
            }
        }
        print("token not found")
        return ""
    }
    
}

extension User {
    var name : String? {
        get{
            let fName = first_name ?? ""
            let lName = last_name ?? ""
            return "\(fName) \(lName)"
        }
    }
}
