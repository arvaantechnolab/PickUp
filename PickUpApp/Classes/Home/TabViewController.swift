//
//  TabViewController.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 28/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    @IBOutlet var tabview : UIView!
    @IBOutlet var btnHome : UIButton!
    @IBOutlet var btnChat : UIButton!
    @IBOutlet var btnRanking : UIButton!
    
    @IBOutlet var iconHome : UIImageView!
    @IBOutlet var iconChat : UIImageView!
    @IBOutlet var iconRanking : UIImageView!
    
    
    var arrTabIcon : [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrTabIcon.append(iconHome)
        arrTabIcon.append(iconChat)
        arrTabIcon.append(iconRanking)
        self.view.addSubview(tabview)
        tabBar.isHidden = true
        
        self.setSelectedTab(index: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabview.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - 50, width: Device.SCREEN_WIDTH ,height: 50)
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

    
    @IBAction func btnTabClicked(_ sender : UIButton) {
        setSelectedTab(index: sender.tag)
        
    }
    
    func setSelectedTab(index : Int) {
        for imgView in arrTabIcon {
            let img = imgView.image
            imgView.image = img?.maskWithColor(color: UIColor.white)
        }
        let img = arrTabIcon[index].image
        arrTabIcon[index].image = img?.maskWithColor(color: Color.LightOrange)
        
        self.selectedIndex = index
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
}
