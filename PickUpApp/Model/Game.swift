//
//  User.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 01/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class Game: NSObject, Mappable, NSCoding  {
   
    var id : Int?
    var name : String?
    var user_id : Int?
    var sport_type_id : Int?
    var sport_type : Sport?
    var teams : [Team]?
    var no_of_player : Int?
    var match_time : String?
    var latitude : String?
    var longitude : String?
    var address : String?
    var is_complated : Int?
    var created_at : String?
    var updated_at : String?
    var mode : String?
    var isTeamAvailable : Bool? = false

    
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
        self.user_id                = aDecoder.decodeObject(forKey: "user_id") as? Int
        self.sport_type_id          = aDecoder.decodeObject(forKey: "icon_hover") as? Int
        self.sport_type          =   aDecoder.decodeObject(forKey: "sport_type") as? Sport
        self.teams          =   aDecoder.decodeObject(forKey: "sport_type") as? [Team]
        
        self.no_of_player        = aDecoder.decodeObject(forKey: "no_of_player") as? Int
        
        self.match_time                = aDecoder.decodeObject(forKey: "match_time") as? String
        self.latitude                = aDecoder.decodeObject(forKey: "latitude") as? String
        self.longitude                = aDecoder.decodeObject(forKey: "longitude") as? String
        self.address                = aDecoder.decodeObject(forKey: "address") as? String
        self.is_complated                = aDecoder.decodeObject(forKey: "is_complated") as? Int
        
        self.updated_at          = aDecoder.decodeObject(forKey: "updated_at") as? String
        self.created_at          = aDecoder.decodeObject(forKey: "created_at") as? String
        self.mode                 = aDecoder.decodeObject(forKey: "mode") as? String
    }
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(sport_type_id, forKey: "sport_type_id")
        aCoder.encode(sport_type, forKey: "sport_type")
        aCoder.encode(teams, forKey: "teams")
        aCoder.encode(no_of_player, forKey: "no_of_player")
        aCoder.encode(match_time, forKey: "match_time")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(is_complated, forKey: "is_complated")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(mode, forKey: "mode")
    }
    
    //==========================================
    //MARK: - Mappable Protocol Methods
    //==========================================
    
    
    func mapping(map: Map) {
        
        id                       <- map["id"]
        name                     <- map["name"]
        user_id                  <- map["user_id"]
        sport_type_id                  <- map["sport_type_id"]
        sport_type                    <- map["sport_type"]
        teams                    <- map["teams"]
        no_of_player                  <- map["no_of_player"]
        match_time                    <- map["match_time"]
        latitude                  <- map["latitude"]
        longitude                    <- map["longitude"]
        address                  <- map["address"]
        is_complated                  <- map["is_complated"]
        updated_at            <- map["updated_at"]
        created_at            <- map["created_at"]
        mode            <- map["mode"]
        
        if (self.mode == "LEAGUE" && (self.teams?.count ?? 0) > 1)  {
            self.isTeamAvailable = true
        }
    }

    
}

