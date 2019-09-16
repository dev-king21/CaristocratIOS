//
//  ConsultancyView.swift
 import Foundation

class ConsultancyView: UIView {
    
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var aboutTextView: CustomUITextView!
    @IBOutlet weak var readmoreButton: UIButton!
    @IBOutlet weak var heightForHeadline: NSLayoutConstraint!
    @IBOutlet weak var heightForParent: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var heightMainView: NSLayoutConstraint!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    var vehicleDetail: VehicleBase?
    var bank: BankRateModel?
    var contactType: ContactType?
    var consultancyView : UIView!
    var delegate : AskForConsultancyProtocol!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
         consultancyView = UINib(nibName: "ConsultancyView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        consultancyView.frame = self.bounds
        addSubview(consultancyView)
        
        emailField.keyboardType = .emailAddress
        
        self.setupField()
        self.setContactDetails()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupField() {
        self.countryCode.delegate = self
        self.countryCode.phonePickerDelegate = Utility().topViewController()
        let currentLocale = NSLocale.current as NSLocale
        let code = currentLocale.object(forKey: .countryCode) as? String
        //self.countryCode.country = Country.country(for: NKVSource(countryCode: code ?? ""))
        
        self.countryCode.country = Country.country(for: NKVSource(countryCode: "AE"))
        
        if let userData = AppStateManager.sharedInstance.userData?.user {
            if !(userData.details?.phone?.isEmpty ?? true) {
                self.countryCode.country = Country.country(for: NKVSource.init(phoneExtension: userData.details?.country_code ?? "AE"))
            }
        }
    }
    
    func setContactDetails(){
        let user = AppStateManager.sharedInstance.userData?.user
        self.nameField.text = user?.name ?? ""
        self.emailField.text = user?.email ?? ""
        self.phoneNumberField.text = user?.details?.phone ?? ""
        self.countryCode.country = Country.country(for: NKVSource(countryCode: user?.details?.country_code ?? "AE"))
    }
    
    func submitRequest() {
        var params: Parameters = [
            "name":nameField.text ?? "",
            "email":emailField.text ?? "",
            "country_code":countryCode.code ?? "",
            "phone":phoneNumberField.text ?? "",
            "type":contactType?.rawValue,
            "message": aboutTextView.getText()]
        
        if let carId = vehicleDetail?.id {
            params["car_id"] = carId
            
        }
        
        if bank != nil{
            params["bank_id"] = self.bank?.id ?? 0
        }
        
        APIManager.sharedInstance.contactUs(params: params, success: { (result) in
            Utility().showCustomPopup(titile: "Success !", descTitle: "", desc: "We have received your details. One of our experts will be in touch with your shortly!", btnOkTitle: "OKAY, GO BACK", delegate: self)
        }, failure: { (error) in
            
        })
    }
    
    func validateForm() -> Bool {
        if !ValidationsUtility.isNotEmpty(string: nameField.text ?? "") {
            Utility.showAlert(title: "Error", message: Messages.EnterName.rawValue)
            return false
        } else if !ValidationsUtility.isNotEmpty(string: emailField.text ?? "") {
            Utility.showAlert(title: "Error", message: Messages.EnterEmail.rawValue)
            return false
        } else if !ValidationsUtility.isValidEmail(email: emailField.text ?? "")  {
            Utility.showAlert(title: "Error", message: Messages.EnterValidEmail.rawValue)
            return false
        }
        //        else if !ValidationsUtility.isNotEmpty(string: phoneNumberField.text ?? "")  {
        //            Utility.showAlert(title: "Error", message: Messages.EnterPhone.rawValue)
        //            return false
        //        }
        return true
    }
    
    @IBAction func tappedOnPersonalShopperSubmit() {
        if validateForm() {
            self.submitRequest()
        }
    }
    
    @IBAction func tappedOnReadMore() {
//        contentLabel.numberOfLines = contentLabel.numberOfLines == 0 ? 10 : 0
//        readmoreButton.setTitle(contentLabel.numberOfLines == 0 ? "Read Less..." : "Read More...", for: .normal)
//        if (contentLabel.numberOfLines == 0){
//            lblHeading.isHidden = false
//            parentView.isHidden = false
//            self.heightMainView.constant = 750
//            self.stackHeight.constant = 300
//            self.layoutIfNeeded()
//        }else{
//            lblHeading.isHidden = false
//            parentView.isHidden = true
//            self.heightMainView.constant = 220
//            self.stackHeight.constant = 0
//            self.layoutIfNeeded()
//        }
        
        
        readmoreButton.setTitle(readmoreButton.currentTitle == "Read More..." ? "Read Less..." : "Read More...", for: .normal)
        if (readmoreButton.currentTitle == "Read Less..."){     ///contentLabel.numberOfLines == 0
            lblHeading.isHidden = false
            parentView.isHidden = false
            
            let contentlblHeight = self.contentLabel.attributedText?.height(withConstrainedWidth: self.contentLabel.frame.width)
            print(contentlblHeight!)
            self.heightMainView.constant = 410+contentlblHeight!
            self.stackHeight.constant = 300
            self.layoutIfNeeded()
        }else{
            lblHeading.isHidden = false
            parentView.isHidden = true
            self.heightMainView.constant = 300
            self.stackHeight.constant = 0
            self.layoutIfNeeded()
        }
    }
    
}

extension ConsultancyView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCode {
            return false
        }
        
        return true
    }
}

extension ConsultancyView: PopupDelgates {

    func didTapOnClose() {
     self.delegate.didTapOkButton(status: true)
    }
}


