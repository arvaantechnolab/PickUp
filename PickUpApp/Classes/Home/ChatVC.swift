//
//  ChatVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 28/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

class ChatVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = "Chat"
        AppDelegate.sharedAppDelegate.isUserOnHomeScreen = true
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppDelegate.sharedAppDelegate.isUserOnHomeScreen = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
