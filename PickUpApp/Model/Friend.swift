//
//  User.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 01/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class Friend: User {
   
    var user_block : Int?
    var user_friend : String?
    
    //==========================================
    //MARK: - Initializer Method
    //==========================================
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    //==========================================
    //MARK: - NSCoder Initializer Methods
    //==========================================
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.user_block                  = aDecoder.decodeObject(forKey: "user_block") as? Int
        self.user_friend                 = aDecoder.decodeObject(forKey: "user_friend") as? String
        
    }

    
    
    
    override func encode(with aCoder: NSCoder) {

        super.encode(with: aCoder)
        aCoder.encode(user_block, forKey: "user_block")
        aCoder.encode(user_friend, forKey: "user_friend")
    }
    
    //==========================================
    //MARK: - Mappable Protocol Methods
    //==========================================
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        user_block                    <- map["user_block"]
        user_friend                   <- map["user_friend"]
    }
   
    var friendStatus : FriendStatus {
        get {
            return FriendStatus(fromRawValue: user_friend ?? "")
        }
    }
    
}

