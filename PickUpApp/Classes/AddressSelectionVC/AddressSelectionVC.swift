//
//  AddressSelectionVC.swift
//  Copyright © 2016 Arvaan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import Alamofire

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



let kSPANVALUE = 0.005

//MARK: - AddressSelectionDelegate Protocol
protocol AddressSelectionDelegate
{
    func addressDidSelected(_ locationDict:NSDictionary, zipCode : String);
}

//MARK: - AddressSelectionVC Class

class AddressSelectionVC: UIViewController , UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate{
    

    //==========================================
    //MARK: - Variables
    //==========================================
    
    fileprivate var mapChangedFromUserInteraction = false
    var delegate:AddressSelectionDelegate!
    var arrayOfAddresses:NSMutableArray!
    var locationManager:CLLocationManager!
    var locationDictIfAvailable:NSDictionary?
    var currentLocationShownOrNot:Bool!
    var timer:Timer!
    var isFieldAddressEditable:Bool = true
    var titleForAddressSelectionViewController : String = ""
    var titleForLocationButton : String = ""
    var dictionaryOfLocation : NSMutableDictionary?
    var zipCode : String?
    
    var isSearchAddressAllow : Bool = true
    
    //==========================================
    //MARK: - IBOutlets
    //==========================================
    
    //Buttons
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnUserLocation: UIButton!
    @IBOutlet weak var btnSetAddress: UIButton!
    
    //TextFields
    @IBOutlet weak var txtSearchAdresss: UITextField!
    
    //MapView
    @IBOutlet weak var mapView: MKMapView!
    
    //TableView
    @IBOutlet weak var tableViewForAddress: UITableView!
    
    //UIImageView
    @IBOutlet weak var imgViewAddressPin: UIImageView!
    
    //UIView
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerContainerBG: UIImageView!
    @IBOutlet var viewForZipCode: UIView!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    //==========================================
    //MARK: - View Controller Life Cycle Methods
    //==========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        txtSearchAdresss.leftView = paddingView
        txtSearchAdresss.leftViewMode = .always
        

        zipCode = ""
        arrayOfAddresses = NSMutableArray()
        self.tableViewForAddress.isHidden=true
        self.updateLocationManager()
        
        if locationDictIfAvailable == nil
        {
            self.currentLocationShownOrNot = false
        }
        else
        {
            self.currentLocationShownOrNot = true
            self.setNewPinLocationWithAddressDict(locationDictIfAvailable!);
        }
        
        //If  isFieldAddressEditable == true then btnSetAddress should be hidden
        if (isFieldAddressEditable == true){
            
            self.txtSearchAdresss.isEnabled = true
            self.btnSetAddress.isHidden = false
            
            
        }else{
            self.txtSearchAdresss.isEnabled = false
            self.btnSetAddress.isHidden = true
            
        }
        
        self.view.bringSubview(toFront: tableViewForAddress)
        
        mapView.isScrollEnabled = false
        self.setPinLocationInMapAsPerCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        if (isSearchAddressAllow == false){
            imgViewAddressPin.isHidden = true
            mapView.isScrollEnabled = false
        }
        else{
            mapView.isScrollEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if timer != nil && timer.isValid
        {
            timer.invalidate();
            timer=nil;
        }
        
        arrayOfAddresses = nil;
        self.locationManager.delegate = nil;
        self.locationManager.stopUpdatingLocation();
        self.mapView.delegate = nil
        self.mapView.mapType = MKMapType.standard;
        self.mapView.removeFromSuperview();
        self.mapView = nil;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //==========================================
    //MARK: - UITextField Delegate Methods
    //==========================================
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.tableViewForAddress.isHidden=true;
        txtSearchAdresss.resignFirstResponder();
        
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtSearchAdresss && isSearchAddressAllow
        {
            if timer != nil && timer.isValid
            {
                timer.invalidate();
                timer=nil;
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AddressSelectionVC.makeGetLocationCall), userInfo: nil, repeats: false)
        }
        
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
     
        if isSearchAddressAllow {
            self.dictionaryOfLocation!.setObject(textField.text!, forKey: LocationKey.kLocationName as NSCopying);
        }

        self.tableViewForAddress.isHidden=true;
        txtSearchAdresss.resignFirstResponder();
    }
    
    
    //==========================================
    //MARK: - UITableView DataSource Methods
    //==========================================
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfAddresses.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier:String = "AddressCellIdentifier";
        
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) ;
        
        if cell==nil
        {
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier);
        }
        
        
        ////////------- Using Google Map API -----------/////
        let locationInfo = arrayOfAddresses.object(at: (indexPath as NSIndexPath).row) as! GMSAutocompletePrediction;
        let attibutedString = locationInfo.attributedFullText as NSAttributedString;
        cell.textLabel?.attributedText = attibutedString;
        
        return cell;
    }
    
    
    
    //==========================================
    //MARK: - UITableView Delegate Methods
    //==========================================
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        ////////------- Using Google Map APIs -----------/////
        
        //weak var vc:AddressSelectionVC? = self;
        
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            
            
            let locationInfo = self!.arrayOfAddresses.object(at: (indexPath as NSIndexPath).row) as! GMSAutocompletePrediction;
            
            let selectedPlaceID = locationInfo.placeID;
            let placesClient = GMSPlacesClient();
            
            let attibutedString = locationInfo.attributedFullText as NSAttributedString;
           
            
            placesClient.lookUpPlaceID(selectedPlaceID!, callback: { (place, error) -> Void in
                if error != nil {
                    print("lookup place id query error: \(error!.localizedDescription)")
                    return
                }
                
                if place != nil {
                    
                    GMSGeocoder().reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: place!.coordinate.latitude, longitude: place!.coordinate.longitude), completionHandler: { (response, error) in
                        
                        if(error == nil){
                            
                            let address = response?.firstResult()
                            print("City : \(address!.locality!)")
                            print("Country : \(address!.country!)")
                            //print("ZIP CODE : \(address!.postalCode)")
                            
                            
                            self!.zipCode = address?.postalCode != nil ? address?.postalCode : ""
                            self!.dictionaryOfLocation = NSMutableDictionary();
                            
                            self!.dictionaryOfLocation!.setObject(attibutedString.string, forKey: LocationKey.kLocationName as NSCopying);
                            self!.dictionaryOfLocation!.setObject("\(place!.coordinate.latitude)", forKey: LocationKey.kLatitude as NSCopying);
                            self!.dictionaryOfLocation!.setObject("\(place!.coordinate.longitude)", forKey: LocationKey.kLongitude as NSCopying);
                            
                            let location = CLLocation(latitude: place!.coordinate.latitude, longitude: place!.coordinate.longitude);
                            self!.dictionaryOfLocation!.setObject(location, forKey: LocationKey.kLocation as NSCopying)
                            self!.dictionaryOfLocation!.setObject((address?.locality)!, forKey: LocationKey.kCity as NSCopying)
                            self!.dictionaryOfLocation!.setObject((address?.country)!, forKey: LocationKey.kCountry as NSCopying)
                            self!.dictionaryOfLocation!.setObject(self!.zipCode! , forKey: LocationKey.kZipCode as NSCopying)
                            
                            self!.setNewPinLocationWithAddressDict(self!.dictionaryOfLocation! as NSDictionary);
                            self!.txtSearchAdresss.resignFirstResponder();
                        }else {
                            
                            print(error!.localizedDescription)
                        }
                    })
                } else {
                    print("No place details for \(String(describing: selectedPlaceID))")
                }
            })
            
            self!.tableViewForAddress.isHidden=true;
            
        })
        
    }
    
    
    
    
    
    //==========================================
    //MARK: - IBAction Methods
    //==========================================
    
    @IBAction func userLocationBtnTapped(_ sender: AnyObject) {
    
        self.showCurrentLocation();
    }
    
    @IBAction func setAddressBtnTapped(_ sender: AnyObject) {
        
        if(self.dictionaryOfLocation == nil && self.locationDictIfAvailable == nil){
            
            SVProgressHUD.showError(withStatus: "Please Select Address")
    
        }else {
            
            let zipCode = self.zipCode ?? ""
            
            let locationDict = self.dictionaryOfLocation != nil ? self.dictionaryOfLocation! : self.locationDictIfAvailable!
            self.delegate.addressDidSelected(locationDict, zipCode: zipCode)
            
            //hideZipCodeView()
            self.dismiss(animated: true, completion: nil);
        }
        
    }
   
    
//    @IBAction func cancelBtnTapped(_ sender: AnyObject) {
//        
//        hideZipCodeView()
//        
//    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //==========================================
    //MARK: - CLLocationManager Setup
    //==========================================
    
    func updateLocationManager()
    {
        self.locationManager=CLLocationManager();
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        
        
        if(self.locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))){
            let status = CLLocationManager.authorizationStatus()
            if(status == CLAuthorizationStatus.notDetermined) {
                self.locationManager.requestWhenInUseAuthorization();
            }
        }
        self.locationManager.startUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //self.activityIndicator.hidden = true
        
        if currentLocationShownOrNot == false
        {
            self.showCurrentLocation();
            self.setPinLocationInMapAsPerCurrentLocation()
            currentLocationShownOrNot=true;
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Location manager failed to update location");
    }
    
    //==========================================
    //MARK: - MKMapView Delegate Methods
    //==========================================
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction){
            self.callWebserviceToGetLocationByGesture()
        }
    }


    //==========================================
    //MARK: - Helper Methods
    //==========================================
    
    func reloadAutoCompletionTableView()
    {
        //self.activityIndicator.hidden = true
        
        //===============================================================///
        /* arrayOfAddresses.count ==0 then make table hidden */
        if arrayOfAddresses.count == 0
        {
            self.tableViewForAddress.isHidden = true;
        }
            
        else if arrayOfAddresses.count < 5
        {
            //===============================================================///
            /* arrayOfAddresses.count < 5 then make table height to number of array elemnts height */
            self.tableViewForAddress.isHidden = false;
            self.tableViewForAddress.frame = CGRect(x: self.tableViewForAddress.frame.origin.x, y: self.tableViewForAddress.frame.origin.y, width: self.tableViewForAddress.frame.size.width, height: CGFloat(arrayOfAddresses.count*44));
        }
        else
        {
            //===============================================================///
            /* arrayOfAddresses.count > 5 then make table height to 4 row  */
            self.tableViewForAddress.isHidden = false;
            self.tableViewForAddress.frame = CGRect(x: self.tableViewForAddress.frame.origin.x, y: self.tableViewForAddress.frame.origin.y, width: self.tableViewForAddress.frame.size.width, height: CGFloat(4*44));
        }
        
        self.tableViewForAddress.reloadData();
    }

    
    func setNewPinLocationWithAddressDict(_ addressDict:NSDictionary)
    {
        tableViewForAddress.isHidden=true;
        let addressStr:String = addressDict.value(forKey: LocationKey.kLocationName) as! String;
        
        self.txtSearchAdresss.text = addressStr;
        let location:CLLocation = addressDict.object(forKey: LocationKey.kLocation) as! CLLocation;
        self.mapView.setCenter(location.coordinate, animated: true);
        
        self.mapView.setRegion( MKCoordinateRegionMake(location.coordinate , MKCoordinateSpanMake(kSPANVALUE, kSPANVALUE)), animated: true);
    }
    
    func setPinLocationInMapAsPerCurrentLocation(){
        
        imgViewAddressPin.center = CGPoint(x: mapView.center.x, y: mapView.center.y);
    }
    
    @objc func makeGetLocationCall()
    {
        timer=nil;
        if(txtSearchAdresss.text!.isEmpty){
            tableViewForAddress.isHidden=true;
        }else{
            self.getLocationFromString(txtSearchAdresss.text!)
        }
    }
    
    
    func showCurrentLocation()
    {
        if self.locationManager.location != nil
        {
            
            self.mapView.setRegion( MKCoordinateRegionMake( locationManager.location!.coordinate, MKCoordinateSpanMake(kSPANVALUE, kSPANVALUE)), animated: currentLocationShownOrNot);
            self.mapView.centerCoordinate.longitude = locationManager.location!.coordinate.longitude
            self.mapView.centerCoordinate.latitude = locationManager.location!.coordinate.latitude
            self.callWebserviceToGetLocationByGesture()
        }
    }
    
    func getLocationFromString(_ locStr:String)
    {

        //--------------------- using google place api
        
        var lat = mapView.region.center.latitude - mapView.region.span.latitudeDelta;
        var log = mapView.region.center.longitude - mapView.region.span.longitudeDelta;
        
        let left = CLLocationCoordinate2DMake(lat, log)
        
        lat = mapView.region.center.latitude + mapView.region.span.latitudeDelta;
        log = mapView.region.center.longitude + mapView.region.span.longitudeDelta;
        
        let right = CLLocationCoordinate2DMake(lat, log)
        
        let bounds = GMSCoordinateBounds(coordinate: left, coordinate: right)
        
        let placesClient = GMSPlacesClient.shared() //GMSPlacesClient();
        
        if locStr.characters.count > 0 {
            
            //self.activityIndicator.hidden = false
            //activityIndicator.startAnimating()
            
            
            placesClient.autocompleteQuery(locStr, bounds: bounds, filter: nil, callback: { [weak self] (results, error) -> Void in
                if error != nil {
              
                    //self.activityIndicator.hidden = true
                    print("Error : \(error!.localizedDescription)")
                    return
                }
                
                if let _ = self!.arrayOfAddresses{
                    
                    self!.arrayOfAddresses.removeAllObjects();
                }
                
                let arrResults = NSArray(array: results!);
                
                for result in arrResults {
                    if let result = result as? GMSAutocompletePrediction {
                        //                        self.data.append(result)
                        
                        self!.arrayOfAddresses.add(result);
                        
                    }
                }
                
                self!.reloadAutoCompletionTableView();
            })
        }
        else {
            
            //            self.data = [GMSAutocompletePrediction]()
            //            self.tableView.reloadData()
        }
        
    }

    
    fileprivate func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view: UIView = self.mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    
    //==========================================
    //MARK: - WebService Calls
    //==========================================

    func callWebserviceToGetLocationByGesture(){
        
        var latitude : Double = mapView.centerCoordinate.latitude
        var longitude : Double = mapView.centerCoordinate.longitude
        var address : String = ""
        
        let url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(mapView.centerCoordinate.latitude),\(mapView.centerCoordinate.longitude)&sensor=true"
        print("url \(url)")
        NetworkManager.showNetworkLog()
        SVProgressHUD.show(withStatus: "Fetching Address")
        NetworkManager.sharedManager().requestAddress(HTTPMethod.get, url: url, parameters: nil, successHandler: { [weak self](response) in
            SVProgressHUD.dismiss()
            if let address = (response as! [[String:Any]]).first{
                
                let strAddress = address["formatted_address"] as? String ?? ""
                if let geometry = address["geometry"] as? [String:Any]{
                    if let location = geometry["location"] as? [String:Any]{
                        latitude = location["lat"] as! Double
                        longitude = location["lng"] as! Double
                    }
                }
                self!.txtSearchAdresss.text = strAddress
                self!.dictionaryOfLocation = NSMutableDictionary()
                self!.dictionaryOfLocation!.setObject(strAddress, forKey: LocationKey.kLocationName as NSCopying);
                self!.dictionaryOfLocation!.setObject("\(latitude)", forKey: LocationKey.kLatitude as NSCopying);
                self!.dictionaryOfLocation!.setObject("\(longitude)", forKey: LocationKey.kLongitude as NSCopying);
                let location = CLLocation(latitude: latitude, longitude: longitude)
                self!.dictionaryOfLocation!.setObject(location, forKey: LocationKey.kLocation as NSCopying);
                
            }
            
        }) { (errorMessage) in
            
            SVProgressHUD.showError(withStatus: errorMessage)
        }
    }
    
}



