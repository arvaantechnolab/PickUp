//
//  BaseViewController.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 28/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var headerView : HeaderView?
    
    override var title: String? {
        get{
            return headerView?.lblTitle?.text
        }
        set {
            headerView?.lblTitle?.text = newValue
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderIfNeeded()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setHeaderIfNeeded()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
    }
    
    func setHeaderIfNeeded() {
        if headerView == nil {
            if let headerView = HeaderView.GetHeaderView() {
                headerView.delegate = self
                headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
                self.view.addSubview(headerView)
                self.headerView = headerView
                headerView.btnLeft?.setImage(#imageLiteral(resourceName: "sideMenu"), for: .normal)
            }
        }
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

extension BaseViewController : HeaderDelegate{
    
    func leftIconClicked() {
        mainNavController?.sideMenuOpenPressed()
    }
    
    func rightIconClicked() {
        
    }
}
