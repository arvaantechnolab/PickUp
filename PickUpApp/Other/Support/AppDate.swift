//
//  AppDate.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 01/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

final class AppData: NSObject {
    
    static let shared = AppData()
    
    //==========================================
    //MARK: - Variables
    //==========================================
    
    
    //==========================================
    //MARK: - Helper Methods
    //==========================================
    
    func saveModel(_ model : AnyObject, forKey key : String) {
        
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: model)
        UserDefaults.standard.set(encodedObject, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    func getModelForKey(_ key : String) -> AnyObject? {
        
        let encodedObject = UserDefaults.standard.object(forKey: key) as? Data
        let savedModel = encodedObject != nil ? NSKeyedUnarchiver.unarchiveObject(with: encodedObject!) : nil
        return savedModel as AnyObject?
    }
    
    func removeModelForKey(_ key : String){
        
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
}

extension AppData {
    
    func saveUserInfo(_ userInfo : [String : Any]){
        if let user = Mapper<User>().map(JSON: userInfo) {
            if appUser != nil {
                user.token = appUser?.token
            }
            saveModel(user, forKey: UserDefaultsKey.user)
        }
        
    }
    
    func getUserInfo() -> User? {
        return getModelForKey(UserDefaultsKey.user) as? User
    }
}
