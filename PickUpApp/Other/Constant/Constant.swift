//
//  Constant.swift
//

import Foundation
import UIKit

let APP_NAME = "Pick up"

enum Gender : Int {
    
    case male = 1,
    female = 2
 
    func getStringValue() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}

struct LocationKey {
    
    static let kLocationName            = "LocationName"
    static let kLocation                = "Location"
    static let kLatitude                = "Latitude"
    static let kLongitude               = "Longitude"
    static let kCity                    = "City"
    static let kCountry                 = "Country"
    static let kZipCode                 = "zipCode"
    
}

struct FriendStatusConstant {
    static let request_get = "REQUEST_GET"
    static let friend = "FRIEND"
    static let request_sent = "REQUEST_SENT"
    static let request_none = "NONE"
}

enum FriendStatus : Int {
    
    case none = 0,
    friend,
    sent,
    get
    
    init(fromRawValue: String){
        switch fromRawValue {
        case "REQUEST_GET":
            self = .get
        case "FRIEND":
            self = .friend
        case "REQUEST_SENT":
            self = .sent
        default:
            self = .none
        }
    }
    
    
}

enum GameMode : Int {
    case none = 0,
    mof,
    league
}

struct Device {
    
    static let SCREEN = UIScreen.main
    static let IS_IPAD = UI_USER_INTERFACE_IDIOM()      == .pad
    static let IS_IPHONE = UI_USER_INTERFACE_IDIOM()    == .phone
    
    static let SCREEN_SIZE          = SCREEN.bounds.size
    static let SCREEN_WIDTH         = SCREEN.bounds.size.width
    static let SCREEN_HEIGHT        = SCREEN.bounds.size.height
    
    static let IS_IPHONE_4      = SCREEN_WIDTH == 320 || SCREEN_HEIGHT == 480
    static let IS_IPHONE_5S     = SCREEN_WIDTH == 320 || SCREEN_HEIGHT == 568
    static let IS_IPHONE_8      = SCREEN_WIDTH == 375 || SCREEN_HEIGHT == 667
    static let IS_IPHONE_8_PLUS = SCREEN_WIDTH == 414 || SCREEN_HEIGHT == 736
    static let IS_IPHONE_X      = SCREEN_WIDTH == 375 || SCREEN_HEIGHT == 812
    
}

struct Color{
    
    static let LightOrange = UIColor.RGBColor(red: 255.0, green: 163.0, blue: 67.0, alpha: 1.0)
    static let DarkOrange = UIColor.RGBColor(red: 255.0, green: 129.0, blue: 28.0, alpha: 1.0)
    static let White50 = UIColor.RGBColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
}

struct ThirdPartyAPI {
    
//    static let KEY_GOOGLE_MAP_API     = "AIzaSyAWmwp6LzYH9_o7rezFeftmZfcAMztIi8U"
    static let KEY_GOOGLE_PLACE_API   = "AIzaSyA2rrXRMzIt3ZQYZfN5jWJwXxWmUfAGXSI"
    
}

struct StoryBoardName {
    static let startUP = "StartUp"
    static let home = "Home"
    static let friend = "Friend"
    static let game = "Game"
    static let team = "Team"
}

struct UserDefaultsKey {
    static let user = "UserKey"
    
}

struct DateFormat {
    static let DateOfBirth = "yyyy-MM-dd"
}

var appUser : User?



