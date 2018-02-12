//
//  Webservice.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 29/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import Foundation
internal struct WebService {
    
    //MARK: - BaseURL
    
    #if DEBUG
        static let url: String = "http://139.59.24.105/pickup/"
        static let version  = "public/api/"
    #else
        static let url: String = "http://139.59.24.105/pickup/"
        static let version  = "public/api/"
    #endif
    
    
    
    static let baseURL = "\(url)\(version)"
    
    //Login/Register
    static let Login : String                   = "login"
    static let Register : String                = "register"
    static let SocialLogin : String             = "social-login"
    static let ForgotPassword : String          = "forgot-password"
    
    //User
    static let UpdateProfilePicture : String    = "update-profile-picture"
    static let UpdateProfile : String           = "update-profile"
    static let GetUserDetails : String          = "user/details?"
    
    static let UserBlock : String               = "user-block/"
    static let UserUnblock : String             = "user-unblock/"
    static let UserBlockList : String           = "user-block-list?"
    static let changePassword:String            = "change-password"
    
    
    //Friend
    static let UserFriendList : String          = "user-friend?"
    static let SearchFriend : String            = "user-search?"
    static let FriendRequestList : String       = "user-friend/request/list"
    
    static let sendFriendRequest : String            = "user-friend/request/"
    static let acceptDeclineFriendRequest : String   = "user-friend/request-answer/"
    static let removeFriend : String                 = "user-friend/remove/"
    
    //Game
    
    static let SportType : String               = "sport-type-list"
    static let CreateGame : String              = "game-create"
    static let GameList : String                = "game-list?"
    static let GamePlayerList : String          = "game-player"
    static let TeamList : String                = "team-list"
    static let TeamDetail : String              = "team-details"
    static let TeamMyList : String              = "team-mylist"
    
    
    //To Create URL for Web Service
    internal static func createURLForWebService(_ webServiceName : String) -> String {
        
        let URL:String = String(format: "\(WebService.baseURL)\(webServiceName)");
        return URL;
    }
    
}




internal struct Request {
    
    static let email : String                       = "email"
    static let password : String                    = "password"
    static let confirm_password : String            = "c_password"
    static let name : String                        = "name"
    static let first_name : String                  = "first_name"
    static let last_name : String                   = "last_name"
    static let facebook_id : String                 = "facebook_id"
    static let mobile_no : String                   = "mobile_no"
    static let username : String                    = "username"
    static let gender : String                      = "gender"
    static let date_of_birth : String               = "date_of_birth"
    static let query : String                       = "query"
    static let friendRequestAnswer : String         = "answer"
    static let newPassword:String                   = "new_password"
    static let fcmId:String                         = "fcm_id"

    static let latitude : String                    = "latitude"
    static let longitude : String                   = "longitude"
    static let address : String                     = "address"
    
    static let sport_type_id : String               = "sport_type_id"
    static let no_of_player : String                = "no_of_player"
    static let match_time : String                  = "match_time"
    
    static let deviceToken : String                 = "device_token"
    static let profile_pic: String                  = "profile_pic"
    static let image : String                       = "image"
    static let images : String                      = "image[]"
    static let social_type : String                 = "social_type"
    static let google_id : String                   = "google_id"
    static let dob : String                         = "birth_date"
    static let user_id: String                      = "user_id"
    static let friend_id : String                   = "friend_id"
    static let profile_url : String                 = "profile_url"
    static let text : String                        = "text"
    static let video : String                       = "video"
    static let videos : String                      = "video[]"
    static let video_thumbs : String                = "video_thumb[]"
    static let file : String                        = "file"
    static let comment : String                     = "comment"
    static let description : String                 = "description"
    static let is_notification : String             = "is_notification"
    
    static let block_id: String                     = "block_id"
}

internal struct Response {
    
    static let status_code : String         = "status_code"
    static let message : String             = "message"
    static let data : String                = "data"
    static let result : String              = "results"
    static let friends : String             = "friends"
    static let friend_request : String      = "friend_request"
    static let records : String             = "records"
    static let others : String              = "others"
    static let total_records : String       = "total_records"
    
    
}



internal struct Header {
    
    struct Key {
        static let kClientKey       = "clientkey"
        static let kClientSecret    = "clientsecret"
        static let kToken           = "token"
        static let kAccept           = "Accept"
        static let kAuthorization    = "Authorization"
    }
    
    struct Value {
        
        
    }
    
    
    //To Set Header Fields
    static func createHeader() -> [String:String] {
        
        var headers : [String:String]? = [:]
        print(UserDefaults.standard.value(forKey: "DeviceToken") as? String)
        headers![Key.kAccept] = "application/json"

        if appUser != nil {
            print("Bearer \(appUser!.token!)")
            headers![Key.kAuthorization] = "Bearer \(appUser!.token!)"            
        }
        else if UserDefaults.standard.value(forKey: "DeviceToken") as? String != nil
        {
            
            let devToken = UserDefaults.standard.value(forKey: "DeviceToken") as! String
             headers![Key.kAuthorization] = "Bearer \(devToken)"
            print(headers)
            //print(AppData.shared.getModelForKey())
        }
        
        return headers!
    }
}


struct WebServiceCallErrorMessage {
    
    static let ErrorInvalidDataFormatMessage = "Please try again , server not reachable";
    static let ErrorServerNotReachableMessage = "Server Not Reachable";
    static let ErrorInternetConnectionNotAvailableMessage = "Opss, looks like you don't have internet access at the moment...";
    static let ErrorTitleInternetConnectionNotAvailableMessage = "Network Error";
    static let ErrorNoDataFoundMessage = "No Data Available";
}
