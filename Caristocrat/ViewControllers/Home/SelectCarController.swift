//
//  SelectCarController.swift
 import UIKit
protocol AddAndTradeCarProtocol {
    func tradeAddedCarWith(addedCar:VehicleBase?, fromAddCar: Bool)
}

class SelectCarController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AddNewCarView: UIView!

    @IBOutlet weak var contextTextView: UILabel!

    var allVehicles: [VehicleBase] = []
    var selectedVehicleDetail: VehicleBase?
    var addedVehicleDetail: VehicleBase?
    
    var selectedIndex = 0
    var addedCarId = 0
    var forEvaluation = false
    var isShowLoginPopUp = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeApperence()
      //  self.getMyCars()
        self.setContent()
    }
    
    func setContent() {
        if forEvaluation {
            contextTextView.text = "Select a car from below or add a new one for evaluation. \n\n- Your car details will be sent to the top Dealers. \n- Within 24 to 48 hours, you will receive the best offers for your car.\n- All offers are sent by the Dealers and Caristocrat is not involved in the offers.\n- Visit the Dealers (who placed an offer for your car) within 5 working days for physical inspection and offer confirmation."
            
            contextTextView.BoldText = "Select a car from below or add a new one for evaluation."
        } else {
            contextTextView.text = "Select a car from below or add a new one for Trade In. \n\n- Your car details will be sent to the Dealer of the car you are interested in. \nThe Dealer will send you an offer within 24 to 48 hours. \n- All offers are sent by the Dealers and Caristocrat is not involved in the offers. \n- Visit the Dealers (who placed an offer for your car) within 5 working days for physical inspection and offer confirmation."
            
            contextTextView.BoldText = "Select a car from below or add a new one for Trade In."
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getMyCars()
    }
    
    func customizeApperence() {
        self.AddNewCarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOnNewCar)))
        self.prepareTableview()
    }
    
    func registerCells() {
      self.tableView.register(UINib(nibName: MyTradeCarCell.identifier, bundle: nil), forCellReuseIdentifier: MyTradeCarCell.identifier)
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func getMyCars() {
        APIManager.sharedInstance.getMyCars(params: [:], success: { (result) in
            self.allVehicles = result
            self.tableView.reloadData()
            if self.allVehicles.isEmpty {
               // self.tapOnNewCar()
            }
        }) { (error) in
            
        }
    }
    
    @objc func tapOnNewCar() {
        
        if AppStateManager.sharedInstance.isUserLoggedIn(){
            let controller = TradeCarController.instantiate(fromAppStoryboard: .Home)
            controller.selectedVehicleDetail = self.selectedVehicleDetail
            controller.tradeCarType = .AddAndTrade
            controller.forEvaluation = forEvaluation
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            self.isShowLoginPopUp = true
            AlertViewController.showAlertLogin(title: "Sign in Required", description: "To complete this action, you must be logged in!", rightButtonText: "CREATE AN ACCOUNT", leftButtonText: "LOGIN", delegate: self)
            
//            AlertViewController.showAlert(title: "Sign in Required", description: "To complete this action, you must be logged in!" , rightButtonText : "Login") {
//                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
//                signinController.isGuest = true
//                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
//            }
        }
    }
}

extension SelectCarController:AddAndTradeCarProtocol{
    func tradeAddedCarWith(addedCar: VehicleBase?, fromAddCar: Bool) {
        self.addedVehicleDetail = addedCar
        if let vehicleDetail = addedCar{
            self.allVehicles.insert(vehicleDetail, at: 0)
            self.tableView.reloadData()
        }
        self.showTradeInCarAlert(fromAddCar: fromAddCar)
    }
}

extension SelectCarController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTradeCarCell.identifier)
        
        if let cell = cell as? MyTradeCarCell {
            cell.setData(vehicleDetail: allVehicles[indexPath.row])
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVehicles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addedVehicleDetail = nil
        self.selectedIndex = indexPath.row
        self.showTradeInCarAlert(fromAddCar: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func showTradeInCarAlert(fromAddCar: Bool) {
        var carName = ""
        if self.addedVehicleDetail != nil{
            //"They said \"It's okay\", didn't they?"
            let brandName = self.addedVehicleDetail?.car_model?.brand?.name ?? ""
            let carModel = self.addedVehicleDetail?.car_model?.name ?? ""
            
            carName = "\"\(brandName) \(carModel)\""
            //carName = "\"" + (self.addedVehicleDetail?.car_model?.brand?.name ?? "") + " " +  (self.addedVehicleDetail?.car_model?.name ?? "") + "\""
        }
        else{
            
            let brandName = allVehicles[self.selectedIndex].car_model?.brand?.name ?? ""
            let carModel = allVehicles[self.selectedIndex].car_model?.name ?? ""
            
            carName = "\"\(brandName) \(carModel)\""
            
            //carName = "\"" + (allVehicles[self.selectedIndex].car_model?.brand?.name ?? "") + " " + (allVehicles[self.selectedIndex].car_model?.name ?? "") + "\""
        }
        
        if forEvaluation {
//            AlertViewController.showAlert(title: "Evaluate Car", description: "Kindly confirm, do you want to generate an evaluate request for \(carName)?", rightButtonText: "YES", leftButtonText: "CANCEL", delegate: self)
            if fromAddCar {
            
                AlertViewController.showAlert(title: "Evaluate Your Car", description: "Do you want to submit your car for evaluation?", rightButtonText: "YES", leftButtonText: "LATER", delegate: self)
            } else {
                AlertViewController.showAlert(title: "Car Evaluation from Dealer", description: "Please confirm, do you want to submit your \(carName) for evaluation?", rightButtonText: "Yes", leftButtonText: "Cancel", delegate: self)
            }
        } else {
            if fromAddCar {
                AlertViewController.showAlert(title: "Trade In Request", description: "Please confirm, do you want to submit your \(carName) for trade in?", rightButtonText: "YES, TRADE IN", leftButtonText: "CANCEL", delegate: self)
            } else {
                AlertViewController.showAlert(title: "Trade In Request", description: "Please confirm, do you want to submit your \(carName) for trade in?", rightButtonText: "YES, TRADE IN", leftButtonText: "CANCEL", delegate: self)
            }
        }
        
    }
}

extension SelectCarController: AlertViewDelegates {
    func didTapOnRightButton() {
        
        if(isShowLoginPopUp == true) {
            isShowLoginPopUp = false
            let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
            signinController.isGuest = true
            var nav = UINavigationController(rootViewController: signinController)
            let signupController = SignupViewController.instantiate(fromAppStoryboard: .Login)
            nav.pushViewController(signupController, animated: false)
            self.present(nav, animated: true, completion: nil)
            return
        }
        
        
        let owner_car_id = selectedVehicleDetail?.id ?? 0
        var customer_car_id = 0
        if self.addedVehicleDetail != nil{
            customer_car_id = self.addedVehicleDetail?.id ?? 0
        }
        else {
            customer_car_id = allVehicles[self.selectedIndex].id ?? 0
        }
        let type = forEvaluation ? TradeEvaluateCarType.evaluate.rawValue : TradeEvaluateCarType.trade.rawValue
        
        var params:[String:Any] = ["customer_car_id":customer_car_id,
                                   "type":type]
        
        if type == TradeEvaluateCarType.trade.rawValue {
            params["owner_car_id"] = owner_car_id
        }
        
        APIManager.sharedInstance.postTradeInCar(params: params, success: { (response) in
           print(response)
            if let message = response["message"] as? String{
                Utility.showSuccessWith(message: message)
            }
            if self.addedVehicleDetail != nil{
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func didTapOnLeftButton() {
        
        if(isShowLoginPopUp == true) {
            isShowLoginPopUp = false
            let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
            signinController.isGuest = true
            self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            return
        }
        
        if self.addedVehicleDetail != nil{
            self.addedVehicleDetail = nil
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

