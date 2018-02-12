//
//  Team.swift
//  PickUpApp
//
//  Created by Arvaan on 10/02/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class Team: NSObject, Mappable, NSCoding {

    var id : Int?
    var name : String?
    var icon : String?
    var mode : String?
    var sport_type_id : Int?
    var sport_type : Sport?
    var user : User?
    var is_my_team : String?
    var created_at : String?
    var updated_at : String?
    
    
    
    //==========================================
    //MARK: - Initializer Method
    //==========================================
    
    required init?(map: Map) {
        
    }
    
    //==========================================
    //MARK: - NSCoder Initializer Methods
    //==========================================
    
    required init?(coder aDecoder: NSCoder) {
        
        self.id                  = aDecoder.decodeObject(forKey: "id") as? Int
        self.name                = aDecoder.decodeObject(forKey: "name") as? String
        self.icon               = aDecoder.decodeObject(forKey: "icon") as? String
        self.mode                = aDecoder.decodeObject(forKey: "mode") as? String
        self.sport_type_id          = aDecoder.decodeObject(forKey: "icon_hover") as? Int
        self.sport_type          =   aDecoder.decodeObject(forKey: "sport_type") as? Sport
        self.user          =   aDecoder.decodeObject(forKey: "user") as? User
        
        self.is_my_team          = aDecoder.decodeObject(forKey: "is_my_team") as? String
        self.updated_at          = aDecoder.decodeObject(forKey: "updated_at") as? String
        self.created_at          = aDecoder.decodeObject(forKey: "created_at") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(mode, forKey: "mode")
        aCoder.encode(sport_type_id, forKey: "sport_type_id")
        aCoder.encode(sport_type, forKey: "sport_type")
       
        aCoder.encode(user, forKey: "user")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(is_my_team, forKey: "created_at")
    }
    
    //==========================================
    //MARK: - Mappable Protocol Methods
    //==========================================
    
    
    func mapping(map: Map) {
        
        id                       <- map["id"]
        name                     <- map["name"]
        icon                     <- map["icon"]
        mode                     <- map["mode"]
        sport_type_id            <- map["sport_type_id"]
        sport_type               <- map["sport_type"]
        user                    <- map["user"]
       
        updated_at               <- map["updated_at"]
        created_at               <- map["created_at"]
        is_my_team               <- map["is_my_team"]
    }
}
