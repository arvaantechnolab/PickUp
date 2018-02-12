//
//  HomeVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 28/12/17.
//  Copyright © 2017 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import MapKit
import ObjectMapper
import CoreLocation



enum HomeTab : Int {
    case none = 0,
    list,
    map
}

//protocol HandleMapSearch: class {
//    func dropPinZoomIn(placemark:MKPlacemark)
//}

class HomeVC: BaseViewController,MKMapViewDelegate {

    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var tblGameList : UITableView!
    @IBOutlet weak var btnList : UIButton!
    @IBOutlet weak var btnMap : UIButton!
    @IBOutlet weak var btnCurrentLocation : UIButton!
    @IBOutlet weak var selectedView : UIView!
    
    @IBOutlet weak var mapForGame : MKMapView!
    
    //var selectedPin: MKPlacemark?
    
    var arrGames: [Game] = []
    var arrGames1: [Game] = []
    
    var isJustLoad = true
    var currentTag : HomeTab = .list
    var offset = 0
    var totalCount:Int = 0
    var gameMode : GameMode = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
        getGameList(offset)
        btnCurrentLocation.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        headerView?.btnRight?.setImage(#imageLiteral(resourceName: "filtter-icon"), for: .normal)
        headerView?.btnRight?.setImage(#imageLiteral(resourceName: "filtter-icon"), for: .selected)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isJustLoad == true {
            btnTabClicked(btnList)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isJustLoad = false
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
    
    
    //MARK: -  API Call
    
    func getGameList( _ offSet:Int) {
        
        arrGames.removeAll()
        let parameter : [String: Any] = ["offset" : "\(offSet)"]
        let url = WebService.createURLForWebService(WebService.GameList) + "\(parameter.queryString())"
        
        print(url)
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, successHandler: { (response) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if let res = response as? [String : Any] {
                    print(res["total_counts"] as? Int)
                    self.totalCount = (res["total_counts"] as? Int)!
                    print(self.totalCount)
                    
                    if let data = res[Response.records] as? [[String:Any]] {
                        //self.arrGames = Mapper<Game>().mapArray(JSONArray: data)
                        let maparr =  Mapper<Game>().mapArray(JSONArray: data)
                        
                        for data in maparr
                        {
                            self.arrGames.append(data)
                        }
                    }
                }
                self.tblGameList.reloadData()
                self.addAnnotationPoint()
               // self.addAnnotationToMap()
            })
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    func getGameList1( _ offSet:Int) {
        
        let parameter : [String: Any] = ["offset" : "\(offSet)"]
        let url = WebService.createURLForWebService(WebService.GameList) + "\(parameter.queryString())"
        
        print(url)
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, successHandler: { (response) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if let res = response as? [String : Any] {
                    print(res["total_counts"] as? Int)
                    self.totalCount = (res["total_counts"] as? Int)!
                    print(self.totalCount)
                    
                    if let data = res[Response.records] as? [[String:Any]] {
                        
                        let newArr =  Mapper<Game>().mapArray(JSONArray: data)
                        for data in newArr
                        {
                            self.arrGames1.append(data)
                        }
                        if self.arrGames1.count != 0
                        {
                            for data in self.arrGames1
                            {
                                self.arrGames.append(data)
                            }
                        }
                    }
                }
                self.tblGameList.reloadData()
                self.addAnnotationPoint()
                // self.addAnnotationToMap()
            })
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    func addAnnotationPoint()
    {
        if arrGames.count != 0
        {
            if arrGames1.count != 0
            {
                for data in arrGames
                {
                    for data1 in arrGames1
                    {
                        if data1.id != data.id
                        {
                            arrGames.append(data1)
                        }
                    }
                }
            }
        }
        
        if arrGames.count != 0
        {
            print(arrGames.count)
            for data in arrGames
            {
                
                let point = MKPointAnnotation()
                
                let pointlatitude = Double(data.latitude!)!
                let pointlongitude = Double(data.longitude!)!
                point.title = data.address
                
                point.coordinate = CLLocationCoordinate2DMake(pointlatitude ,pointlongitude)
                //print(point.coordinate)
                mapForGame.addAnnotation(point)
                
                
            }
            //            let span = MKCoordinateSpanMake(0.075, 0.075)
            //            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
            //            mapForGame.setRegion(region, animated: true)
        }
        
        
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        var arraySendData:[Game] = []
        for data in arrGames
        {
            if (mapView.selectedAnnotations.last?.title!) == (data.address)
            {
                arraySendData.removeAll()
                //arraySendData.append(data)
                showalert(strMessage: data.address!, StrTitle: data.name!, arrMyData: [data])
            }
        }
    }
    //===========================================================
    //MARK:-  Alert Show Method
    //===========================================================
    func showalert(strMessage:String , StrTitle:String , arrMyData:[Game])
    {
        AlertView.showAlert(StrTitle, strMessage: strMessage, button: ["Join","Cancle"], viewcontroller: self) { (index) in
            if(index == 0)
            {
                DispatchQueue.main.async {
                    let gameDetail = getController(storyBoard: StoryBoardName.home, controllerIdentifier: GameDetailVC.className) as! GameDetailVC
                    
                    gameDetail.gameDetail = arrMyData
                    AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(gameDetail, animated: true)
                   
                }
                
            }
            
            
        }
        SVProgressHUD.dismiss()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            
            //annotationView.canShowCallout = true
            
            
                
                annotationView.image = #imageLiteral(resourceName: "MapPinForGame")
                
           
            
            
        }
        
        return annotationView
    }
    


    func addAnnotationToMap() {
        
        let allAnnotations = self.mapForGame.annotations
        self.mapForGame.removeAnnotations(allAnnotations)
        
        
        for game in arrGames{
            let CLLCoordType = CLLocationCoordinate2D(latitude: game.latitude?.toDouble() ?? 0,
                                                      longitude: game.longitude?.toDouble() ?? 0);
            print("CLLCoordType \(CLLCoordType)")
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            // anno.title  = game.address
            mapForGame.addAnnotation(anno);
        }
        
        moveToCurrentLocation()
    }
    func moveToCurrentLocation() {
        AppDelegate.sharedAppDelegate.getCurrentLocation { (location, error) in
            
            //            if error != nil {
            //                self.mapForGame.zoomLevel = 20
            //            }
            //
            let noLocation = location
            if noLocation?.coordinate != nil {
                let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation!.coordinate, 200, 200)
                self.mapForGame.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    @IBAction func btnShowLocationClicked() {
        moveToCurrentLocation()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func changeTab(_ switchToTag : HomeTab) {
  
        var x = CGFloat(0.0);
        
        switch switchToTag {
        case .list:
            x = 0.0;
            break;
        case .map:
            x = self.scrollView.frame.width
        
        case .none:
            print("there is no tab selected");
        }
        
        scrollView.setContentOffset(CGPoint(x: x, y : 0), animated: true)
        
        
    }
    
}


extension HomeVC {

    @IBAction func btnTabClicked(_ sender : UIButton){
        var frame = selectedView.frame
        frame.origin.x = sender == btnList ? 0 : self.view.frame.width / 2
        frame.size.width = self.view.frame.width / 2
        
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.selectedView.frame = frame
        }) { (isCompleted) in
            if isCompleted == true {
                self.view.isUserInteractionEnabled = true
            }
        }
        changeTab(sender == btnList ? .list : .map)
    }
    
    @IBAction func btnAddNewGameClicked(_ sender : UIButton){
        
        let createGame = getController(storyBoard: StoryBoardName.game, controllerIdentifier: CreateGameVC.className)
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(createGame, animated: true)
    }
    
}

extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print(arrGames[indexPath.row].mode!)
        if arrGames[indexPath.row].mode! == "MOF" {
       print(arrGames[indexPath.row].mode!)
        let cell = tableView.dequeueReusableCell(withIdentifier: MofeMatchCell.className, for: indexPath)
        
        if let mofCell = cell as? MofeMatchCell{
            
            let gameObject = arrGames[indexPath.row]
            if arrGames.count >= 20
            {
                
                if indexPath.row == arrGames.count - 1
                {
                    if arrGames.count != totalCount
                    {
                        if arrGames.count <= totalCount
                        {
                            getGameList1(arrGames.count)
                        }
                        
                    }
                }
            }
            mofCell.lblLocationName.text = gameObject.address
            mofCell.lblGame.text = gameObject.name
            mofCell.imgGameMode.image = UIImage(named: "modModeCellIcon")
            
            if let numberOfPlayer = gameObject.no_of_player {
                mofCell.lblNumberOfPlayer.text = "\(numberOfPlayer - 1)/\(numberOfPlayer)"
            }
            else{
                mofCell.lblNumberOfPlayer.text = ""
            }
            
            if let sportURL = gameObject.sport_type?.icon_hover {
                mofCell.imgGameIcon.setImageWithActivity(sportURL, UIActivityIndicatorViewStyle.white)
            }
            //mofCell.imgGameIcon.isHidden = true
        }
        cell.selectionStyle = .none
        return cell;
    }
  
        else if arrGames[indexPath.row].mode! == "LEAGUE" {
            let cell = tableView.dequeueReusableCell(withIdentifier: LeagueMatchCell.className, for: indexPath)

            if let leagueCell = cell as? LeagueMatchCell{

                let gameObject = arrGames[indexPath.row]
                if arrGames.count >= 20
                {

                    if indexPath.row == arrGames.count - 1
                    {
                        if arrGames.count != totalCount
                        {
                            if arrGames.count <= totalCount
                            {
                                getGameList1(arrGames.count)
                            }

                        }
                    }
                }
                leagueCell.imgGameIcon.image = UIImage(named: "leagueMode")
                leagueCell.lblGame.text = gameObject.sport_type?.name
                leagueCell.lblTeam1Name.text = gameObject.teams?.first?.name
                
                if let sportURL = gameObject.teams?.first?.icon {
                    leagueCell.imgTeam1.setImageWithActivity(sportURL, UIActivityIndicatorViewStyle.white)
                }
            }
            return cell
        }
        else{
             let cell = tableView.dequeueReusableCell(withIdentifier: MofeMatchCell.className, for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrGames[indexPath.row].mode! == "MOF" {
        let gameDetail = getController(storyBoard: StoryBoardName.home, controllerIdentifier: GameDetailVC.className) as! GameDetailVC
      
        gameDetail.gameDetail = [arrGames[indexPath.row]]
        AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(gameDetail, animated: true)
        }
        else if arrGames[indexPath.row].mode! == "LEAGUE" {
    
            let gameDetail = getController(storyBoard: StoryBoardName.home, controllerIdentifier: LeagueMatchGameDetailVC.className) as! LeagueMatchGameDetailVC
    
            gameDetail.gameDetail = [arrGames[indexPath.row]]
            AppDelegate.sharedAppDelegate.mainNavigationController?.pushViewController(gameDetail, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

//extension HomeVC : MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        if annotation is MKUserLocation{
//            return nil;
//        }else{
//            //let pinIdent = "Pin";
//            let pinIdent = "MofMode";
//            var pinView: MKPinAnnotationView;
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView
//            {
//                dequeuedView.annotation = annotation;
//                pinView = dequeuedView;
//            }else{
//                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
//                pinView.canShowCallout = true
//                pinView.calloutOffset = CGPoint(x: -5, y: 5)
//                pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            }
//            return pinView;
//        }
//    }
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
//                 calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! Artwork
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
//            MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
//    }
    
//}

