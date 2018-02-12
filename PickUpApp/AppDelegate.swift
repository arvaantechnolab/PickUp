//
//  AppDelegate.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 23/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SVProgressHUD
import FBSDKLoginKit
import IQKeyboardManagerSwift
import Firebase
import GoogleMaps
import GooglePlaces
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate{

    var window: UIWindow?
    var mainNavigationController : NavigationController?
    static let sharedAppDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var isUserOnHomeScreen : Bool = false

    typealias locationBlock = (CLLocation?,NSError?) -> Void
    
    var locationManager: CLLocationManager = CLLocationManager();
    var currentLocation : CLLocation!
    var lBlock : locationBlock?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        FirebaseApp.configure()
        //Enable Google Map Service using Registered API Key
        GMSServices.provideAPIKey(ThirdPartyAPI.KEY_GOOGLE_PLACE_API);
        GMSPlacesClient.provideAPIKey(ThirdPartyAPI.KEY_GOOGLE_PLACE_API)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("doc path \(documentsPath)")
        
        if let user = AppData.shared.getUserInfo() {
            appUser = user
            
            if let nav = window?.rootViewController as? NavigationController {
                let tabVC = getController(storyBoard: StoryBoardName.home, controllerIdentifier: TabViewController.className)
                nav.pushViewController(tabVC, animated: false)
            }
        }
        
        configureSVProgressHUD()
        
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func configureSVProgressHUD() {
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setAnimationCurve(UIViewAnimationCurve.linear)
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
    }
    
    
    //------------------
    //MARK:
    //MARK: - Method Releted to location
    
    
    
    
    func LocationUpdate()
    {
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //let locValue : CLLocationCoordinate2D = manager.location!.coordinate;
        
        currentLocation = manager.location
        manager.stopUpdatingLocation()
        
        lBlock?(currentLocation,nil);
        lBlock = nil;
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lBlock?(nil,error as NSError?);
    }
    
    
    func getCurrentLocation(_ lBlock : @escaping locationBlock ){
        self.lBlock = lBlock;
        self.LocationUpdate();
    }
}

