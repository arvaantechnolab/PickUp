//
//  CreateGameVC.swift
//  PickUpApp
//
//  Created by Arvaan Techno-lab Pvt Ltd on 10/01/18.
//  Copyright © 2018 Arvaan Techno-lab Pvt Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class CreateGameVC: BaseViewController {

    @IBOutlet weak var gameListView : iCarousel!
    @IBOutlet weak var btnMofMode: UIButton!
    @IBOutlet weak var btnLeagueMode: UIButton!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var lblPlayerTitle: UILabel!

    @IBOutlet weak var txtDate: AMTextField!
    @IBOutlet weak var txtTime: AMTextField!
    @IBOutlet weak var txtPlayer: AMTextField!
    @IBOutlet weak var txtAddPlayer: AMTextField!

    @IBOutlet weak var datePicker : UIDatePicker!
    @IBOutlet weak var datePickerContainer : UIView!
    @IBOutlet weak var dataPicker : UIPickerView!
    @IBOutlet weak var dataPickerContainer : UIView!
    @IBOutlet weak var viewAddPlayer : UIView!

    @IBOutlet weak var constraintBtnSubmitTop: NSLayoutConstraint!
    
    var arrSport : [Sport] = []
    var arrMyTeam : [Team] = []

    var selectedSport = -1;
    var selectedPlayerIndex = -1;
    var selectedTeamID : Int = -1
    var selectedPlayerID : Int = -1
    
    var currentGameMode : GameMode = .mof
    
    var locationDict : NSDictionary?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()

        gameListView.bounces = false
        gameListView.backgroundColor = UIColor.clear
        
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .normal)
        headerView?.btnLeft?.setImage(#imageLiteral(resourceName: "backarrow-icon"), for: .selected)
        
        viewAddPlayer.isHidden = true
        getSportList()
        
        datePicker.minimumDate = Date()
        txtDate.inputView = datePickerContainer
        txtTime.inputView = datePickerContainer
        txtPlayer.inputView = dataPickerContainer
        
        txtDate.delegate = self
        txtTime.delegate = self
        txtPlayer.delegate = self
        
        gameListView.delegate = self
        gameListView.dataSource = self
        setGameMode(currentGameMode)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Create Game"
    }
    
    override func leftIconClicked() {
        self.navigationController?.popViewController(animated: true)
    }

    func setGameMode(_ gameMode : GameMode) {
  
        btnMofMode.setImage(#imageLiteral(resourceName: "MofMode").maskWithColor(color: Color.White50), for: .normal)
        btnLeagueMode.setImage(#imageLiteral(resourceName: "leagueMode").maskWithColor(color: Color.White50), for: .normal)
        
        if gameMode == .mof {
            btnMofMode.setImage(#imageLiteral(resourceName: "MofMode"), for: .normal)

            viewAddPlayer.isHidden = true
            lblPlayerTitle.text = "Player"
            constraintBtnSubmitTop.constant = 50
        }
        else if gameMode == .league {
            btnLeagueMode.setImage(#imageLiteral(resourceName: "leagueMode"), for: .normal)

            viewAddPlayer.isHidden = false
            lblPlayerTitle.text = "Select Team"
            constraintBtnSubmitTop.constant = 80
            
            if arrMyTeam.count == 0 {
                DispatchQueue.main.async(execute: {
                    self.getMyTeamList()
                })
                
            }
        }
        
    }
    
    func isValidData() -> Bool {
        
        if currentGameMode == .league
        {
            AlertView.showOKMessageAlert("League mode is under development. Please choose MOF mode only", viewcontroller: self)
            return false
        }
        if currentGameMode == .none {
            AlertView.showOKMessageAlert("Please Choose any game mode", viewcontroller: self)
            return false
        }
        if txtDate.text?.isEmpty == true || txtTime.text?.isEmpty == true{
            AlertView.showOKMessageAlert("Please Select date & time of game", viewcontroller: self)
            return false
        }
        if locationDict == nil {
            AlertView.showOKMessageAlert("Please Select place of the game", viewcontroller: self)
            return false
        }
        if selectedPlayerIndex == -1 {
            AlertView.showOKMessageAlert("Please Select Number of player", viewcontroller: self)
            return false
        }
        
        return true
    }
    
    func createGame() {
        
        let url = WebService.createURLForWebService(WebService.CreateGame)
        var parameter : [String:Any] = [:]
        let player = self.arrSport[selectedSport].no_of_player?[selectedPlayerIndex] ?? ""

        parameter[Request.address] = self.locationDict?.object(forKey: LocationKey.kLocationName) as? String
        parameter[Request.latitude] = self.locationDict?.object(forKey: LocationKey.kLatitude) as? String
        parameter[Request.longitude] = self.locationDict?.object(forKey: LocationKey.kLongitude) as? String
        parameter[Request.sport_type_id] = arrSport[selectedSport].id
        parameter[Request.name] = arrSport[selectedSport].name
        
        if currentGameMode == GameMode.mof
        {
            parameter["mode"] = "MOF"
            parameter[Request.no_of_player] = player
        }
        else
        {
            parameter["mode"] = "LEAGUE"
            parameter["team_id"] = selectedTeamID
            parameter["player_id"] = selectedPlayerID
        }
        
        //mode
        parameter[Request.match_time] = "\(txtDate.text!) \(txtTime.text!):00"
        print(parameter)
        SVProgressHUD.show()
        
        NetworkManager.shared.requestWithMethodType(.post, url: url, parameters: parameter, successHandler: { (response) in
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.showSuccess(withStatus: "Game created successfully")
                self.navigationController?.popViewController(animated: true)
            })
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
        
        
    }
    
    
    //MARK: -  Action method
    
    @IBAction func btnSelectPlaceClicked(_ sender: UIButton) {
        let addressVC = getController(storyBoard: StoryBoardName.game, controllerIdentifier: AddressSelectionVC.className) as! AddressSelectionVC
        addressVC.delegate = self;
//        self.navigationController?.pushViewController(addressVC, animated: true)
        self.present(addressVC, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectPlayerClicked(_ sender: UIButton) {
        txtPlayer.becomeFirstResponder()
    }
    
    @IBAction func btnSelectGameMode(_ sender: UIButton) {
        currentGameMode = GameMode(rawValue: sender.tag)!
        setGameMode(currentGameMode)
        print(currentGameMode)
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if isValidData() {
            createGame()
        }
    }
    
    @IBAction func btnAddPlayerClicked(_ sender: UIButton?) {
        //Push View
    }

    //MARK: -  API call
    
    
    func getSportList() {
        let url = WebService.createURLForWebService(WebService.SportType)
        
        
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, successHandler: { (response) in
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if let res = response as? [[String : Any]] {
                        self.arrSport = Mapper<Sport>().mapArray(JSONArray: res)
                }
                
                if (self.arrSport.count == 0) {
                    AlertView.showOKMessageAlert("There is no sport available. Please contact admin", viewcontroller: self)
                }
                else {
                    self.selectedSport = 0
                    self.gameListView.reloadData()
                }
                
            })
            
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
        
    }
    
    func getMyTeamList() {
        let url = WebService.createURLForWebService(WebService.TeamMyList)
        print(url)
        SVProgressHUD.show()
        NetworkManager.showNetworkLog()
        
        NetworkManager.shared.requestWithMethodType(.get, url: url, parameters: nil, successHandler: { (response) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                print("response \(response)")
                if   let res = response as? NSArray
                {
                    self.arrMyTeam = Mapper<Team>().mapArray(JSONArray: res as! [[String : Any]])
                    print(self.arrMyTeam.count)
                }
                
                if (self.arrMyTeam.count == 0) {
                    AlertView.showOKMessageAlert("There is no team available. Please contact admin", viewcontroller: self)
                }
                else {
                    self.selectedSport = 0
                    self.gameListView.reloadData()
                }
            })
        }) { (errorString) in
            SVProgressHUD.showError(withStatus: errorString)
        }
    }
    
}

extension CreateGameVC : UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentGameMode == .mof {
            return self.arrSport[selectedSport].no_of_player?.count ?? 0
        }
        else {
            return self.arrMyTeam.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentGameMode == .mof {
            let player = self.arrSport[selectedSport].no_of_player?[row] ?? ""
            return "\(player) : \(player)"
        }else {
            return "Select Team"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentGameMode == .mof {
            selectedPlayerIndex = row
            let player = self.arrSport[selectedSport].no_of_player?[row] ?? ""
            txtPlayer.text = "\(player) : \(player)"
        }
        else {
            let team = arrMyTeam[row]
            selectedTeamID = team.id ?? -1
            selectedPlayerID = team.user?.id ?? -1
            txtAddPlayer.text = team.name
        }
    }
    
}

extension CreateGameVC : iCarouselDelegate,iCarouselDataSource {
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var imageView = view as? UIImageView
        
        if imageView == nil {
            imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imageView?.contentMode = .scaleAspectFit
            
        }
        if selectedSport == index{
            if let url = arrSport[index].icon_hover {
                imageView?.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
        else{
            if let url = arrSport[index].icon {
                imageView?.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
        
        return imageView!
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.arrSport.count
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing ) {
            return value * 1.7
        }
        else
        {
            return value
        }
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        if index != selectedPlayerIndex {
        
            selectedSport = index
            gameListView.reloadData()
            selectedPlayerIndex = -1
            txtPlayer.text = "Not Selected"
        }
        
    }
}

extension CreateGameVC : UITextFieldDelegate {
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAddPlayer {
            btnAddPlayerClicked(nil)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDate || textField == txtTime {
            txtDate.text = Utilities.convertDateToString(datePicker.date, dateFormat: "yyyy-MM-dd")
            txtTime.text = Utilities.convertDateToString(datePicker.date, dateFormat: "HH:mm")
        }
        else if txtPlayer == textField {
            if selectedPlayerIndex != -1 {
                let player = self.arrSport[selectedSport].no_of_player?[selectedPlayerIndex] ?? ""
                txtPlayer.text =  "\(player) : \(player)"
            }
        }
    }
}

extension CreateGameVC : AddressSelectionDelegate {
    
    func addressDidSelected(_ locationDict: NSDictionary, zipCode: String) {
        print(locationDict)
        self.locationDict = locationDict
        self.lblPlace.text = self.locationDict?.object(forKey: LocationKey.kLocationName) as? String
    }
}
