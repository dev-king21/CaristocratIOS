//
//  VirtualBuyViewController.swift
 import UIKit

enum VirtualBuyBy{
    case financeBuy
    case cashBuy
}
class VirtualBuyViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFinanceBuy: ButtonStates!
    @IBOutlet weak var btnCashBuy: ButtonStates!
    
    var virtualBuyBy = VirtualBuyBy.financeBuy
    var viewSchemeSlider = iCarousel()
    var phoneNumber = ""
    var currentValue : Float!
    var moveValue : Float!
    
    var arrSliderValuesFinanceBy = [
        SliderValues(name: "Period", startValue: "12", endValue: "60", computedValue: "12",unit:"Months"),
        SliderValues(name: "Down Payment", startValue: "0", endValue: "75", computedValue: "0",unit:"%"),
        SliderValues(name: "Interest Rate", startValue: "0", endValue: "10", computedValue: "0",unit:"%"),
        SliderValues(name: "Insurance Rate", startValue: "0", endValue: "10", computedValue: "0",unit:"%")]
    
    var arrSliderValuesCashBy = [
        SliderValues(name: "Insurance Rate", startValue: "0", endValue: "10", computedValue: "0",unit:"%")]
    var financeBreakDownValues = FinanceBreakDownValues(carPrice: "250000.0", downPayment: "0.0", monthlyInstallment: "0.0", unit: "AED")
    var driveWayPaymentValuesFinanceBy = DriveWayPaymentValues(downPayment: "0.0", insurance: "0.0", registrationFee: "565.0", totalUpfrontPayment: "565.0", unit: "AED")
    var driveWayPaymentValuesCashBy
        = DriveWayPaymentValues(downPayment: "250000.0", insurance: "0.0", registrationFee: "565.0", totalUpfrontPayment: "565.0", unit: "AED")
    
    var periodValue = "12"
    var downPaymentValue = "0"
    var interestRateValue = "0"
    var insuranceRateValue = "0"
    //10 bank 20 Insurance
    var arrBankRates = [BankRateModel]()
    var arrInsuranceRates = [BankRateModel]()
    var selectedVehicleDetail: VehicleBase?
    var sliderChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCarPrice()
        self.getBankRates()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    @IBAction func onBtnFinanceBuy(_ sender: ButtonStates) {
        
        if sender.isSelected{return}
        self.btnFinanceBuy.isSelected = true
        self.btnCashBuy.isSelected = false
        self.virtualBuyBy = .financeBuy
        self.tableView.reloadSections([1,2], with: .none)
        let top = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: top, at: .top, animated: true)
    }
    @IBAction func onBtnCashBuy(_ sender: ButtonStates) {
        
        if sender.isSelected{return}
        self.btnFinanceBuy.isSelected = false
        self.btnCashBuy.isSelected = true
        self.virtualBuyBy = .cashBuy
        self.tableView.reloadSections([1,2,3], with: .none)
        let top = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: top, at: .top, animated: true)
    }
}
//MARK:- UITableViewDataSource
extension VirtualBuyViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.virtualBuyBy{
        case .financeBuy:
            switch section {
            case 0,2,3:
                return 1
            case 1:
                return self.arrSliderValuesFinanceBy.count
            case 4:
                return self.arrBankRates.count > 0 ? 1 : 0
            case 5:
                return self.arrInsuranceRates.count > 0 ? 1 : 0
            default:
                return 0
            }
        case .cashBuy:
            switch section {
            case 0,3:
                return 1
            case 1:
                return self.arrSliderValuesCashBy.count
            case 2:
                return 0
            case 4:
                return self.arrBankRates.count > 0 ? 1 : 0
            case 5:
                return self.arrInsuranceRates.count > 0 ? 1 : 0
            default:
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let carDescriptionTVC = Bundle.main.loadNibNamed("CarDescriptionTVC", owner: self, options: nil)?.first as! CarDescriptionTVC
            carDescriptionTVC.setData(car: self.selectedVehicleDetail)
            return carDescriptionTVC
        case 1:
            switch self.virtualBuyBy{
            case .financeBuy:
                let rangeSeekBarTVC = Bundle.main.loadNibNamed("RangeSeekBarTVC", owner: self, options: nil)?.first as! RangeSeekBarTVC
                rangeSeekBarTVC.setData(data: self.arrSliderValuesFinanceBy[indexPath.row], isMonth: indexPath.row == 0)
                rangeSeekBarTVC.slider.tag = indexPath.row
                if indexPath.row == 1 {
                    rangeSeekBarTVC.lblComputedAmount.text = "AED \(Int(Double(self.financeBreakDownValues.downPayment) ?? 0.0).withCommas())"
                } else if indexPath.row == 2 {
                    if rangeSeekBarTVC.lblComputedvalue.text == "0.00 %" {
                        rangeSeekBarTVC.lblComputedAmount.text = "AED 0"
                    } else {
                        print(self.financeBreakDownValues)
                        print("MONTHLY INSTALLMENT ------->" , self.financeBreakDownValues.monthlyInstallment)
                        let monthlyInstallment = Int(Double(self.financeBreakDownValues.monthlyInstallment) ?? 0.0).withCommas()
                        rangeSeekBarTVC.lblComputedAmount.text = "AED " + String(monthlyInstallment)
                        //rangeSeekBarTVC.lblComputedAmount.text = "AED \(Int(ceil(Double(self.financeBreakDownValues.monthlyInstallment)) ?? 0.0).withCommas())"
                    }
                    
                } else if indexPath.row == 3 {
                    rangeSeekBarTVC.lblComputedAmount.text = "AED \(Int(Double(self.driveWayPaymentValuesFinanceBy.insurance) ?? 0.0).withCommas())"
                } else {
                    rangeSeekBarTVC.lblComputedAmount.isHidden = true
                }
                rangeSeekBarTVC.slider.addTarget(self, action: #selector(self.onSliderValueChange(sender:)), for: .valueChanged)
                return rangeSeekBarTVC
            case .cashBuy:
                let rangeSeekBarTVC = Bundle.main.loadNibNamed("RangeSeekBarTVC", owner: self, options: nil)?.first as! RangeSeekBarTVC
                rangeSeekBarTVC.setData(data: self.arrSliderValuesCashBy[indexPath.row])
                rangeSeekBarTVC.slider.tag = indexPath.row
                rangeSeekBarTVC.slider.addTarget(self, action: #selector(self.onSliderValueChange(sender:)), for: .valueChanged)
                rangeSeekBarTVC.lblComputedAmount.text = "AED \(Int(Double(self.driveWayPaymentValuesFinanceBy.insurance) ?? 0.0).withCommas())"
                return rangeSeekBarTVC
            }
        case 2:
            let financeBreakDownTVC = Bundle.main.loadNibNamed("FinanceBreakDownTVC", owner: self, options: nil)?.first as! FinanceBreakDownTVC
            print(self.financeBreakDownValues)
            financeBreakDownTVC.setData(vehicleDetail: self.selectedVehicleDetail,data: self.financeBreakDownValues)
            return financeBreakDownTVC
        case 3:
            let driveWayPaymentTVC = Bundle.main.loadNibNamed("DriveWayPaymentTVC", owner: self, options: nil)?.first as! DriveWayPaymentTVC
            switch self.virtualBuyBy{
            case .financeBuy:
                driveWayPaymentTVC.setData(vehicleDetail: self.selectedVehicleDetail,data: self.driveWayPaymentValuesFinanceBy,virtualBuyBy:self.virtualBuyBy)
            case .cashBuy:
                driveWayPaymentTVC.setData(vehicleDetail: self.selectedVehicleDetail,data: self.driveWayPaymentValuesCashBy,virtualBuyBy:self.virtualBuyBy)
            }
            return driveWayPaymentTVC
        case 4:
            let schemeTVC = Bundle.main.loadNibNamed("SchemeTVC", owner: self, options: nil)?.first as! SchemeTVC
            self.viewSchemeSlider = schemeTVC.viewSchemeSlider
            schemeTVC.viewSchemeSlider.tag = indexPath.section
            schemeTVC.viewSchemeSlider.dataSource = self
            schemeTVC.viewSchemeSlider.delegate = self
            schemeTVC.viewSchemeSlider.type = .linear
            schemeTVC.viewSchemeSlider.bounces = false
            schemeTVC.viewSchemeSlider.decelerationRate = 0.5
            return schemeTVC
        case 5:
            let schemeTVC = Bundle.main.loadNibNamed("SchemeTVC", owner: self, options: nil)?.first as! SchemeTVC
            schemeTVC.viewSchemeSlider.tag = indexPath.section
            schemeTVC.viewSchemeSlider.dataSource = self
            schemeTVC.viewSchemeSlider.delegate = self
            schemeTVC.viewSchemeSlider.type = .linear
            schemeTVC.viewSchemeSlider.bounces = false
            schemeTVC.viewSchemeSlider.decelerationRate = 0.5
            return schemeTVC
        default:
            return UITableViewCell()
        }
    }
}
//MARK:- UITableViewDelegate
extension VirtualBuyViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 138.0
        case 4,5:
            return 232.0
        default:
            return UITableView.automaticDimension
        }
    }
}
//MARK:- iCarouselDataSource
extension VirtualBuyViewController:iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
        switch carousel.tag {
        case 4:
            return self.arrBankRates.count
        default:
            return self.arrInsuranceRates.count
        }
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        switch carousel.tag {
        case 4:
            let viewCarousel = iCarouselCell.instanceFromNib() as! iCarouselCell
            viewCarousel.frame = self.viewSchemeSlider.frame
            viewCarousel.btnRequestACall.addTarget(self, action: #selector(self.onBtnRequestACallBankRates(sender:)), for: .touchUpInside)
            viewCarousel.btnRequestACall.tag = index
            viewCarousel.btnCallNow.addTarget(self, action: #selector(self.onBtnCallNowBankRates(sender:)), for: .touchUpInside)
            viewCarousel.btnCallNow.tag = index
            viewCarousel.pageControl.numberOfPages = self.arrBankRates.count
            viewCarousel.setData(data: self.arrBankRates[index])
            return viewCarousel
        default:
            let viewCarousel = iCarouselCell.instanceFromNib() as! iCarouselCell
            viewCarousel.frame = self.viewSchemeSlider.frame
            viewCarousel.btnRequestACall.addTarget(self, action: #selector(self.onBtnRequestACallInsuranceRates(sender:)), for: .touchUpInside)
            viewCarousel.btnRequestACall.tag = index
            viewCarousel.btnCallNow.addTarget(self, action: #selector(self.onBtnCallNowInsuranceRates(sender:)), for: .touchUpInside)
            viewCarousel.btnCallNow.tag = index
            viewCarousel.pageControl.numberOfPages = self.arrInsuranceRates.count
            viewCarousel.setData(data: self.arrInsuranceRates[index])
            return viewCarousel
        }
    }
    @objc func onBtnRequestACallBankRates(sender:UIButton){
        self.submitInteraction(type: .Request)
        let bank = self.arrBankRates[sender.tag]
        
        if AppStateManager.sharedInstance.isUserLoggedIn() {
         self.pushToRequestACall(bank: bank, forBank: true)
        }else{
            AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see your Profile. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
        }
        
        
    }
    @objc func onBtnCallNowBankRates(sender:UIButton){
        self.submitInteraction(type: .Phone)
        let phoneNumber = self.arrBankRates[sender.tag].phone_no ?? ""
        if !phoneNumber.isEmpty{
            self.callOnPhoneNumberWith(number: phoneNumber, name: self.arrBankRates[sender.tag].title ?? "")
        }
    }
    @objc func onBtnRequestACallInsuranceRates(sender:UIButton){
        self.submitInteraction(type: .Request)
        let bank = self.arrInsuranceRates[sender.tag]
        self.pushToRequestACall(bank: bank, forBank: false)
    }
    @objc func onBtnCallNowInsuranceRates(sender:UIButton){
        self.submitInteraction(type: .Phone)
        let phoneNumber = self.arrInsuranceRates[sender.tag].phone_no ?? ""
        if !phoneNumber.isEmpty{
            self.callOnPhoneNumberWith(number: phoneNumber, name: self.arrInsuranceRates[sender.tag].title ?? "")
        }
    }
    
    func submitInteraction(type: InteractionType) {
        APIManager.sharedInstance.carInteraction(car_id: selectedVehicleDetail?.id ?? 0,
                                                 interactionType: type, success: { (result) in
                                                    
        }) { (error) in
            
        }
    }
    
    private func callOnPhoneNumberWith(number: String, name: String){
        self.phoneNumber = number
        AlertViewController.showAlert(title: "CONFIRM CALL", description: "Would you like to call \(name) \n\(number)", rightButtonText: "CALL", leftButtonText: "CANCEL", delegate: self)
    }
    
    private func pushToRequestACall(bank: BankRateModel?, forBank: Bool){
        self.submitInteraction(type: .Phone)
        self.submitRequest(bank: bank, forBank: forBank)
        
//        let controller = AskForConsultancyController.instantiate(fromAppStoryboard: .LuxuryMarket)
//        controller.bank = bank
//        controller.vehicleDetail = self.selectedVehicleDetail
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func submitRequest(bank: BankRateModel?, forBank: Bool) {
        var params: Parameters = [
            "name": AppStateManager.sharedInstance.userData?.user?.name ?? "",
            "email": AppStateManager.sharedInstance.userData?.user?.email ?? "",
            "country_code": AppStateManager.sharedInstance.userData?.user?.details?.country_code ?? "",
            "phone": AppStateManager.sharedInstance.userData?.user?.details?.phone ?? "",
            "type": ContactType.Consultancy.rawValue,
            "message": ""]
        
        if let carId = self.selectedVehicleDetail?.id {
            params["car_id"] = carId
            
        }
        
        if bank != nil {
            params["bank_id"] = bank?.id ?? 0
        }
        
        APIManager.sharedInstance.contactUs(params: params, success: { (result) in
            let message = !forBank  ? "The insurance company has received your details. You will receive a call back shortly!" : "The bank has received your details. You will receive call back shortly!"

            Utility().showCustomPopup(titile: "SUCCESS", descTitle: "", desc: message, btnOkTitle: "OK, Go back", delegate: self)
        }, failure: { (error) in
            
        })
    }
}


extension VirtualBuyViewController: PopupDelgates {
    
    func didTapOnClose() {
        if let navController = Utility().topViewController() as? AskForConsultancyController {
            navController.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK:- AlertViewDelegates
extension VirtualBuyViewController: AlertViewDelegates {
    func didTapOnRightButton() {
        guard let number = URL(string: "tel://" + self.phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    func didTapOnLeftButton() {}
}
// MARK:- iCarouselDelegate
extension VirtualBuyViewController: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
        case iCarouselOption.spacing:
            //add a bit of spacing between the item views
            return value * 1.05
        case iCarouselOption.showBackfaces, iCarouselOption.radius, iCarouselOption.angle, iCarouselOption.arc, iCarouselOption.tilt, iCarouselOption.count, iCarouselOption.fadeMin, iCarouselOption.fadeMinAlpha, iCarouselOption.fadeRange, iCarouselOption.offsetMultiplier, iCarouselOption.visibleItems, iCarouselOption.fadeMax, iCarouselOption.wrap:
            return value
        }
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if let cell = carousel.currentItemView as? iCarouselCell{
            switch carousel.tag{
            case 4:
                cell.pageControl.currentPage = carousel.currentItemIndex
            default:
                cell.pageControl.currentPage = carousel.currentItemIndex
            }
        }
    }
    
    
    func changeValuePeriods(currentValue : Float , moveValue : Float){
        
        
    }
}
//MARK:- Helper Methods
extension VirtualBuyViewController {
        @objc func onSliderValueChange(sender:UISlider){
            switch self.virtualBuyBy{
            case .financeBuy:
                
                var value = ""
                
                print("SENDER TAG --------> " , sender.tag)
                
                if sender.tag == 2 || sender.tag == 3 {
                    self.arrSliderValuesFinanceBy[sender.tag].computedValue = "\(sender.value)"
                    value = (Double(self.arrSliderValuesFinanceBy[sender.tag].computedValue)?.decimalPoints() ?? "0.0") + " " + self.arrSliderValuesFinanceBy[sender.tag].unit
                } else {
                    
                    if(sender.tag == 0){
                        let step : Float = 12
                         let roundedValue =  round(sender.value / step) * step
                         sender.value = roundedValue
                        self.arrSliderValuesFinanceBy[sender.tag].computedValue = "\(Int(sender.value))"
                    }else{
                      self.arrSliderValuesFinanceBy[sender.tag].computedValue = "\(Int(sender.value))"
                    }
                    
                  //  self.arrSliderValuesFinanceBy[sender.tag].computedValue = "\(Int(ceil(sender.value)))"
                    value = self.arrSliderValuesFinanceBy[sender.tag].computedValue + " " + self.arrSliderValuesFinanceBy[sender.tag].unit
                }
                
                
                let indexPath = IndexPath(row: sender.tag, section: 1)
                
              
                
                if let cell = self.tableView.cellForRow(at: indexPath) as? RangeSeekBarTVC{
                    cell.lblComputedvalue.text = value
                    let trackRect = sender.trackRect(forBounds: sender.frame)
                    let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
                    cell.computedValueLeading.constant = thumbRect.minX - (cell.lblComputedvalue.frame.width/2)
                    cell.computedAmountLeading.constant = thumbRect.minX - (cell.lblComputedvalue.frame.width/2)
                }
                
                self.calculateFinanceBreakdown(sender:sender)
                self.calculateDriveWayPayment(sender: sender)
                
                if let cell = self.tableView.cellForRow(at: indexPath) as? RangeSeekBarTVC{
                    if sender.tag == 1 {
                        cell.lblComputedAmount.text = "AED \(Int(Double(self.financeBreakDownValues.downPayment) ?? 0.0).withCommas())"
                    } else if sender.tag == 2 {
                        if sender.value == 0 {
                            cell.lblComputedAmount.text = "AED 0"
                        } else {
                            print(sender.value)
                            let carPrice = Double(self.financeBreakDownValues.carPrice)!
                            let downPament = Double(self.financeBreakDownValues.downPayment)!
                            let interestRate = Double(sender.value).roundToTwoPlaces()
                            let financeAmount = carPrice - downPament
                            let interestAmount = ((financeAmount * interestRate) / 100)
                        
                            print("INTEREST RATE --- >" , interestRate)
                            let test = Int(interestAmount.rounded()).withCommas()
                        
                            
                            cell.lblComputedAmount.text  = "AED " + test
                          //  cell.lblComputedAmount.text = "AED \(Int(ceil(Double(interestAmount) ?? 0.0)).withCommas())"
                        }
                    }
                    else if sender.tag == 3 {
                        cell.lblComputedAmount.text = "AED \(Int(Double(self.driveWayPaymentValuesFinanceBy.insurance)!).withCommas())"
                    } else {
                      cell.lblComputedAmount.isHidden = true
                    }

                }

            case .cashBuy:
                
                if(sender.tag > 0){
                    return
                }
                
                self.arrSliderValuesCashBy[sender.tag].computedValue = "\(sender.value)"
                let value = (Double(self.arrSliderValuesCashBy[sender.tag].computedValue)?.decimalPoints() ?? "0.0") + " " + self.arrSliderValuesCashBy[sender.tag].unit
                
                let indexPath = IndexPath(row: sender.tag, section: 1)
                
                if let cell = self.tableView.cellForRow(at: indexPath) as? RangeSeekBarTVC{
                    cell.lblComputedvalue.text = value
                    let trackRect = sender.trackRect(forBounds: sender.frame)
                    let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
                    cell.computedValueLeading.constant = thumbRect.minX - (cell.lblComputedvalue.frame.width/2)
                    cell.computedAmountLeading.constant = thumbRect.minX - (cell.lblComputedvalue.frame.width/2)

                }
                
                self.calculateInterestRateAndTotalUpfrontWithPercentageCashBuy(value: Float(sender.value.decimalPoints()) ?? 1)
                
                if let cell = self.tableView.cellForRow(at: indexPath) as? RangeSeekBarTVC{
                   cell.lblComputedAmount.text = "AED \(Int(Double(self.driveWayPaymentValuesCashBy.insurance) ?? 0.0).withCommas())"
                }
            }
        }
    private func calculateFinanceBreakdown(sender:UISlider){
        let carAmount = Double(self.financeBreakDownValues.carPrice) ?? 0.0
        let sliderSendervalue = "\(Float(self.arrSliderValuesFinanceBy[sender.tag].computedValue) ?? 0)"
        
        switch sender.tag{
        case 0:
            self.periodValue = sliderSendervalue
        case 1:
            self.downPaymentValue = sliderSendervalue
        case 2:
            self.interestRateValue = sliderSendervalue
        case 3:
            self.insuranceRateValue = sliderSendervalue
        default:
            break
        }
        let downPaymentValueF = Double(self.downPaymentValue) ?? 0.0
        let downPaymentPercent = (downPaymentValueF) / 100.0
        let downPayment = (carAmount * downPaymentPercent).rounded()
        let unit = self.financeBreakDownValues.unit
        let months = Double(self.periodValue) ?? 0.0
        let interestRate = Double(self.interestRateValue)?.roundToTwoPlaces() ?? 0.0
        let annualInterestRate = (carAmount - downPayment) * (interestRate / 100.0)
        let monthInterestRate = annualInterestRate / 12
        let totalInterestPayable = monthInterestRate * months
        
        print(((carAmount - downPayment + totalInterestPayable) / months))
        let paymentPerMonth = ((carAmount - downPayment + totalInterestPayable) / months).rounded()
        
        let indexPath = IndexPath(row: 0, section: 2)
        if let cell = self.tableView.cellForRow(at: indexPath) as? FinanceBreakDownTVC{
            cell.lblDownPayment.text = unit + " " + Utility.commaSeparatedNumber(number: "\(downPayment)")
            cell.lblMonthlyInstallment.text = unit + " " + Utility.commaSeparatedNumber(number: "\(paymentPerMonth)")
        }
        self.financeBreakDownValues.downPayment = "\(downPayment)"
        self.financeBreakDownValues.monthlyInstallment = "\(paymentPerMonth)"
        self.driveWayPaymentValuesFinanceBy.downPayment = "\(downPayment)"
    }
    private func calculateDriveWayPayment(sender:UISlider){
        let sliderSendervalue = "\(Float(self.arrSliderValuesFinanceBy[sender.tag].computedValue) ?? 0)"
        
        switch sender.tag{
        case 0:
            self.periodValue = sliderSendervalue
        case 1:
            self.downPaymentValue = sliderSendervalue
        case 2:
            self.interestRateValue = sliderSendervalue
        case 3:
            self.insuranceRateValue = sliderSendervalue
        default:
            break
        }
        
        let downPayment = Double(self.driveWayPaymentValuesFinanceBy.downPayment) ?? 0.0
        let carAmount = Double(self.financeBreakDownValues.carPrice) ?? 0.0
        let insuranceAmountF = Double((Double(self.insuranceRateValue) ?? 0.0).decimalPoints()) ?? 0.0
        let insuranceAmount = ((carAmount * insuranceAmountF)/100.0).rounded()
        let registrationFee = Double(self.driveWayPaymentValuesFinanceBy.registrationFee) ?? 0.0
        let totalUpfront = (downPayment + insuranceAmount + registrationFee).rounded()
        let unit = self.driveWayPaymentValuesFinanceBy.unit
        
        let indexPath = IndexPath(row: 0, section: 3)
        if let cell = self.tableView.cellForRow(at: indexPath) as? DriveWayPaymentTVC{
            cell.lblDownPayment.text = unit + " " + Utility.commaSeparatedNumber(number: "\(downPayment)")
            cell.lblInsurance.text = unit + " " + Utility.commaSeparatedNumber(number: "\(insuranceAmount)")
            cell.lblTotalUpfrontPayment.text = unit + " " + Utility.commaSeparatedNumber(number: "\(totalUpfront)")
        }
        self.driveWayPaymentValuesFinanceBy.downPayment = "\(downPayment)"
        self.driveWayPaymentValuesFinanceBy.insurance = "\(insuranceAmount)"
        self.driveWayPaymentValuesFinanceBy.totalUpfrontPayment = "\(totalUpfront)"
    }
    private func calculateInterestRateAndTotalUpfrontWithPercentageCashBuy(value:Float){
        let carAmount = Double(self.driveWayPaymentValuesCashBy.downPayment) ?? 0.0
        let seekValue = value
        let insuranceAmount = ((carAmount * Double(seekValue))/100.0).rounded()
        let registrationFee = Double(self.driveWayPaymentValuesCashBy.registrationFee) ?? 0.0
        let totalUpfront = (carAmount + insuranceAmount + registrationFee).rounded()
        let unit = self.driveWayPaymentValuesCashBy.unit
        
        let indexPath = IndexPath(row: 0, section: 3)
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? DriveWayPaymentTVC {
            cell.lblInsurance.text = unit + " " + Utility.commaSeparatedNumber(number: "\(insuranceAmount)")
            cell.lblTotalUpfrontPayment.text = unit + " " + Utility.commaSeparatedNumber(number: "\(totalUpfront)")
        }
        self.driveWayPaymentValuesCashBy.insurance = "\(insuranceAmount)"
        self.driveWayPaymentValuesCashBy.totalUpfrontPayment = "\(totalUpfront)"
    }
    
    private func setCarPrice(){
        guard let data = self.selectedVehicleDetail else {return}
        self.financeBreakDownValues.carPrice = "\(data.amount ?? 0)"
        
        let carPrice = Double(self.financeBreakDownValues.carPrice) ?? 0.0
        let months = Double(self.periodValue) ?? 0.0
        let monthlyInstallment = "\(Int((carPrice / months).rounded()))"
        
        print(monthlyInstallment)
        
        self.financeBreakDownValues.monthlyInstallment = monthlyInstallment
        
        self.driveWayPaymentValuesCashBy.downPayment = "\(data.amount ?? 0)"
        
        let carAmount = Double(self.driveWayPaymentValuesCashBy.downPayment) ?? 0.0
        let registrationFee = Double(self.driveWayPaymentValuesCashBy.registrationFee) ?? 0.0
        let totalUpfrontPayment = "\(Int(carAmount + registrationFee))"
        
        self.driveWayPaymentValuesCashBy.totalUpfrontPayment = totalUpfrontPayment
    }
}
//MARK:- Services
extension VirtualBuyViewController{
    func getBankRates() {
        APIManager.sharedInstance.getBanksRates(success: { (result) in
            print(result)
            for item in result{
                if (item.type ?? 0) == 10{ //Bank rates
                    self.arrBankRates.append(item)
                }
                else{//Insurance rates
                    self.arrInsuranceRates.append(item)
                }
            }
            self.tableView.reloadSections([4,5], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
