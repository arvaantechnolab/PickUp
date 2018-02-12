//
//  NavigationController.swift
//  Knitd
//

import UIKit

var mainNavController: NavigationController?

enum MenuState : Int {
    case none = 0,
    sideMenuOpening,
    sideMenuCloseing,
    sideMenuOpen,
    bubbleMenuOpening,
    bubbleMenuCloseing,
    bubbleMenuOpen
}

protocol NavControllerDelegate
{
    func shouldShowLeftMenu() -> Bool;
}

class NavigationController: UINavigationController, UINavigationControllerDelegate{

    var leftVC:SideMenuVC?
    var rightVC:UIViewController?
    var navDelegate:NavControllerDelegate?
    
    var sideMenuIsOpen:Bool = false
    var isSideMenuOpening:Bool = false
    
    var bubbleMenuIsOpen:Bool = false
    var isBubbleMenuOpening:Bool = false
    
    let minimumDragValue = 25
    
    var touchBeginPoint = CGPoint.zero
    var lastTouchPoint = CGPoint.zero
    
    var frameOfMenuView : CGRect = CGRect.zero
    var frameOfBubbleView : CGRect = CGRect.zero
    
    var currentMenuStatus = MenuState.none
    
    var rightGesture : UISwipeGestureRecognizer!
    var leftGesture :  UISwipeGestureRecognizer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if mainNavController == nil
        {
            mainNavController = self;
            mainNavController?.delegate = self;
            
//            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(NavigationController.dragingOnScreen(_:)))
//            self.view.addGestureRecognizer(panGesture)
            
            leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(NavigationController.leftToRightGestureRecognized(_:)))
            leftGesture.direction = .right
            self.view.addGestureRecognizer(leftGesture)
            
            rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(NavigationController.rightToLeftGestureRecognized(_:)))
            rightGesture.direction = .left
            self.view.addGestureRecognizer(rightGesture)
            
            AppDelegate.sharedAppDelegate.mainNavigationController = mainNavController
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
        
        if leftVC == nil
        {
            if let leftVC = getController(storyBoard: StoryBoardName.home, controllerIdentifier: SideMenuVC.className) as? SideMenuVC {
                self.view.addSubview(leftVC.view)
                leftVC.view.frame = CGRect(x: -Device.SCREEN_WIDTH, y: 0, width:Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT)
                self.leftVC = leftVC
            }
        }
//        if rightVC == nil {
//            rightVC = Utilities.getViewControllerFromStoryboard("Home", identifire: "BubbleViewController") as? BubbleViewController
//            self.view.addSubview(rightVC!.view)
//            rightVC!.view.frame = CGRect(x: Device.SCREEN_WIDTH, y: 0, width:Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT)
//        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func closeMenu(){
        
        if currentMenuStatus == .sideMenuOpen {
            sideMenuClosePressed()
        }
        else if currentMenuStatus == .bubbleMenuOpen {
//            bubbleMenuClosePressed()
        }
        else{
            print("Some error in menu status management");
        }
    }
    
    func sideMenuOpenPressed()
    {

        self.leftVC?.openingSideMenu()
        self.currentMenuStatus = .sideMenuOpening
        self.view.addSubview(self.leftVC!.view)
        self.leftVC!.view.frame = self.view.bounds
        self.leftVC?.menuContainerView.frame = CGRect(x: -self.leftVC!.menuContainerView.frame.size.width, y: self.leftVC!.menuContainerView.frame.origin.y, width: self.leftVC!.menuContainerView.frame.size.width, height: (self.leftVC!.menuContainerView?.frame.size.height)!)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.leftVC?.menuContainerView.frame = CGRect(x: 0.0, y: self.leftVC!.menuContainerView.frame.origin.y, width: self.leftVC!.menuContainerView.frame.size.width, height: self.leftVC!.menuContainerView.frame.size.height)
            self.leftVC?.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            
        }, completion: { (finished) -> Void in
            self.sideMenuIsOpen = true
            self.currentMenuStatus = .sideMenuOpen
            return;
        })
    }
    
    func sideMenuClosePressed()
    {
        self.leftVC?.closingSideMenu();

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.leftVC?.menuContainerView.frame = CGRect(x: -self.leftVC!.menuContainerView.frame.size.width, y: self.leftVC!.menuContainerView.frame.origin.y, width: self.leftVC!.menuContainerView.frame.size.width, height: self.leftVC!.menuContainerView.frame.size.height)
            self.leftVC?.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }, completion: { (finished) -> Void in
            self.currentMenuStatus = .none
            var frame = self.view.bounds
            frame.origin.x = frame.size.width * -1
            self.leftVC?.view.frame = frame
            self.sideMenuIsOpen = false
            self.leftVC?.view.removeFromSuperview()
            return
        })
    }
    /*
    func bubbleMenuOpenPressed()
    {
     
        self.view.removeGestureRecognizer(leftGesture)
        self.view.removeGestureRecognizer(rightGesture)
        
        self.leftVC?.view.removeFromSuperview()
        self.rightVC!.view.frame = self.view.bounds
        var frame = self.rightVC!.bubbleContainerView.frame
        frame.origin.x = frame.width
        self.rightVC!.bubbleContainerView.frame = frame
        self.view.addSubview(self.rightVC!.view)
        self.rightVC!.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.currentMenuStatus = .bubbleMenuOpening
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            var frame = self.rightVC!.bubbleContainerView.frame
            frame.origin.x = self.view.frame.width - frame.width
            self.rightVC!.bubbleContainerView.frame = frame
            self.rightVC!.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            
        }, completion: { (finished) -> Void in
            self.currentMenuStatus = .bubbleMenuOpen
            return;
        })
    }
 
    func bubbleMenuClosePressed()
    {
        self.view.addGestureRecognizer(leftGesture)
        self.view.addGestureRecognizer(rightGesture)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            var frame = self.rightVC!.bubbleContainerView.frame
            frame.origin.x = self.view.bounds.width
            self.rightVC!.bubbleContainerView.frame = frame
            self.rightVC!.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            
        }, completion: { (finished) -> Void in
            self.currentMenuStatus = .none
            self.rightVC!.view.removeFromSuperview()
            
            return;
        })
    }
     */
    
    
    func popAllAndPushViewController(_ viewController:UIViewController)
    {
        super.popToRootViewController(animated: false);
        super.pushViewController(viewController, animated: false);
    }
    
    //MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        //self.sideMenuClosePressed();
        navDelegate = viewController as? NavControllerDelegate
    }
    
    //Swipe gestures Implementation
    @objc func leftToRightGestureRecognized(_ swipeGesture:UIGestureRecognizer)
    {
     /*   if navDelegate != nil && sideMenuIsOpen
        {
            self.sideMenuClosePressed();
        }
 
    */
        if AppDelegate.sharedAppDelegate.isUserOnHomeScreen {
            if (currentMenuStatus == .none){
                self.sideMenuOpenPressed()
            }
            else if (currentMenuStatus == .bubbleMenuOpen){
             //   self.bubbleMenuClosePressed()
            }
            else{
                print("un known state")
            }
        }
        
    }
    
    @objc func rightToLeftGestureRecognized(_ swipeGesture:UIGestureRecognizer)
    {
     /*   if navDelegate != nil && !sideMenuIsOpen
        {
            self.sideMenuOpenPressed()
        }
    */
        if AppDelegate.sharedAppDelegate.isUserOnHomeScreen {
            if (currentMenuStatus == .none){
//                self.bubbleMenuOpenPressed()
            }
            else if (currentMenuStatus == .sideMenuOpen){
                self.sideMenuClosePressed()
            }
            else{
                print("un known state")
            }
        }
    }
    /*
    func dragingOnScreen(_ panGesture:UIGestureRecognizer){
        
        
        if AppDelegate.sharedAppDelegate.isUserOnHomeScreen {
           
            if panGesture.state == UIGestureRecognizerState.began{
                let point = panGesture.location(in: self.view)
                
                touchBeginPoint = point
                lastTouchPoint = point
                
                if !sideMenuIsOpen && !bubbleMenuIsOpen{
            
                    var frame = self.leftVC!.menuContainerView.frame
                    frame.origin.x = frame.width * -1
                    self.leftVC!.menuContainerView.frame = frame
                    frameOfMenuView = frame
                    self.leftVC?.view.addSubview(self.leftVC!.menuContainerView)
                    self.view.addSubview(leftVC!.view)
                    self.view.bringSubview(toFront: leftVC!.view);
                    
                    frame = self.rightVC!.bubbleContainerView.frame
                    frame.origin.x = frame.width
                    self.rightVC!.bubbleContainerView.frame = frame
                    frameOfBubbleView = frame

                    
                    self.rightVC?.view.frame = self.view.bounds
                    self.rightVC!.bubbleContainerView.isHidden = true
                    self.view.addSubview(rightVC!.view)
                    self.view.bringSubview(toFront: rightVC!.view);

                    self.rightVC!.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    
                    
                    self.leftVC!.view.frame = self.view.bounds
                    self.rightVC!.view.frame = self.view.bounds
                    
                }
                else{
                    frameOfMenuView = self.leftVC!.menuContainerView.frame
                    frameOfBubbleView = self.rightVC!.bubbleContainerView.frame
                }
                
            }
            else if panGesture.state == UIGestureRecognizerState.changed{
                let point = panGesture.location(in: self.view)
                var dx = point.x - touchBeginPoint.x

                if (dx > 0) {
                    
                    var frame = frameOfMenuView
                    let alpha = (1 - ((frame.origin.x * -1) / frame.width)) * 0.5
                    dx = point.x - lastTouchPoint.x
                   
                    frame.origin.x += dx
                    if frame.origin.x > 0{
                        frame.origin.x = 0
                    }
                    else if frame.origin.x < (frame.size.width * -1){
                        frame.origin.x = (frame.size.width * -1)
                    }
                    
                    self.leftVC?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha);
                    self.leftVC?.menuContainerView.frame = frame
                    self.leftVC!.menuContainerView.isHidden = false
                    frameOfMenuView = frame
                    
                    dx = point.x - touchBeginPoint.x
                    
                    if abs(Int(dx)) > minimumDragValue{
                        
                        if dx < 0 {
                            isSideMenuOpening = false
                        }
                        else if dx > 0 {
                            isSideMenuOpening = true
                        }
                    }
                }else {
                    var frame = frameOfBubbleView
                    let alpha = (1 - ((frame.origin.x) / frame.width)) * 0.5
                    dx = point.x - lastTouchPoint.x
                    
                    frame.origin.x += dx
                    print("x \(frame.origin.x)");
                    if frame.origin.x > frame.size.width{
                        frame.origin.x = frame.size.width
                    }
                    else if frame.origin.x < (frame.size.width){
                        frame.origin.x = (frame.size.width)
                    }
                    
                    self.rightVC?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha);
                    self.rightVC?.bubbleContainerView.frame = frame
                    self.rightVC!.bubbleContainerView.isHidden = false
                    frameOfBubbleView = frame
                    
                    dx = point.x - touchBeginPoint.x
                    
                    if abs(Int(dx)) > minimumDragValue{
                        
                        if dx > 0 {
                            isBubbleMenuOpening = true
                        }
                        else if dx > 0 {
                            isBubbleMenuOpening = false
                        }
                    }
                }
                
                lastTouchPoint = point
            }
            else if panGesture.state == UIGestureRecognizerState.ended{
                
                if isSideMenuOpening == true {
                    self.sideMenuOpenPressed()
                }
                else {
                    self.sideMenuClosePressed()
                }
            }
        }
    }
    
    func dragEventOpenCloseSideMenu(_ panGesture:UIGestureRecognizer){
        if AppDelegate.sharedAppDelegate.isUserOnHomeScreen {
            
            if panGesture.state == UIGestureRecognizerState.began{
                let point = panGesture.location(in: self.view)
                
                touchBeginPoint = point
                lastTouchPoint = point
                
                var frame = self.leftVC!.menuContainerView.frame
                frame.origin.x = frame.width * -1
                self.leftVC!.menuContainerView.frame = frame
                frameOfMenuView = frame
                self.leftVC?.view.addSubview(self.leftVC!.menuContainerView)
                
                self.leftVC?.view.frame = self.view.bounds
                self.leftVC!.menuContainerView.isHidden = true
                self.view.addSubview(leftVC!.view)
                self.view.bringSubview(toFront: leftVC!.view);
                
                
                if !sideMenuIsOpen{
                    
                }
                else{
                    let frame = self.leftVC!.menuContainerView.frame
                    frameOfMenuView = frame
                }
                
            }
            else if panGesture.state == UIGestureRecognizerState.changed{
                let point = panGesture.location(in: self.view)
                
                var frame = frameOfMenuView
                let alpha = (1 - ((frame.origin.x * -1) / frame.width)) * 0.5
                var dx = point.x - lastTouchPoint.x
                
                frame.origin.x += dx
                if frame.origin.x > 0{
                    frame.origin.x = 0
                }
                else if frame.origin.x < (frame.size.width * -1){
                    frame.origin.x = (frame.size.width * -1)
                }
                
                self.leftVC?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha);
                self.leftVC?.menuContainerView.frame = frame
                self.leftVC!.menuContainerView.isHidden = false
                frameOfMenuView = frame
                
                dx = point.x - touchBeginPoint.x
                
                if abs(Int(dx)) > minimumDragValue{
                    
                    if dx < 0 {
                        isSideMenuOpening = false
                    }
                    else if dx > 0 {
                        isSideMenuOpening = true
                    }
                }
                
                lastTouchPoint = point
            }
            else if panGesture.state == UIGestureRecognizerState.ended{
                
                if isSideMenuOpening == true {
                    self.sideMenuOpenPressed()
                }
                else {
                    self.sideMenuClosePressed()
                }
            }
        }
    }*/
}

