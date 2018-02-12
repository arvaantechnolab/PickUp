//
//  CreateTeamVC.swift
//  PickUpApp
//
//  Created by Arvaan on 10/02/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper


class CreateTeamVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Create Team"
        
    }
    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
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
