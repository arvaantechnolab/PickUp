//
//  User.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 01/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class Sport: NSObject, Mappable, NSCoding  {
   
    var id : Int?
    var name : String?
    var icon : String?
    var icon_hover : String?
    var no_of_player : [String]?
    var updated_at : String?
    var created_at : String?
    
    var iconImage : UIImage?
    var selectedIconImage : UIImage?
    
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
        self.icon                = aDecoder.decodeObject(forKey: "icon") as? String
        self.icon_hover          = aDecoder.decodeObject(forKey: "icon_hover") as? String
        self.no_of_player        = aDecoder.decodeObject(forKey: "no_of_player") as? [String]
        self.updated_at          = aDecoder.decodeObject(forKey: "updated_at") as? String
        self.created_at          = aDecoder.decodeObject(forKey: "created_at") as? String
    }
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(icon_hover, forKey: "icon_hover")
        aCoder.encode(no_of_player, forKey: "no_of_player")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(created_at, forKey: "created_at")
    }
    
    //==========================================
    //MARK: - Mappable Protocol Methods
    //==========================================
    
    
    func mapping(map: Map) {
        
        id                    <- map["id"]
        name                  <- map["name"]
        icon                  <- map["icon"]
        icon_hover            <- map["icon_hover"]
        no_of_player          <- map["no_of_player"]
        updated_at            <- map["updated_at"]
        created_at            <- map["created_at"]
    }

    
    
    init(name : String, selecedImage : UIImage , normalImage : UIImage) {
        
        
        self.name = name
        self.iconImage = normalImage
        self.selectedIconImage = selecedImage
    }
    
    
}

