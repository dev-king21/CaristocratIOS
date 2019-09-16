
//
//  SignupViewController.swift
 import UIKit

class SignupViewController: BaseViewController {

    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var confirmPasswordField: CustomTextField!
    @IBOutlet weak var regionLabel: UILabel!
    var selectedRegion: Int?
    var facebookLogin: Bool?
    var isForGuest = false

    override func viewDidLoad() {
        super.viewDidLoad()
        transparentNavBar = true
        
        setupField()
        
        self.emailField.textField.keyboardType = .emailAddress
    }
    
    func setupField() {
        self.countryCode.delegate = self
        self.countryCode.phonePickerDelegate = self
        let currentLocale = NSLocale.current as NSLocale
        let code = currentLocale.object(forKey: .countryCode) as? String
       // self.countryCode.country = Country.country(for: NKVSource(countryCode: code ?? ""))
        
        self.countryCode.country = Country.country(for: NKVSource(countryCode: "AE"))
    }
    
    @IBAction func tappedOnSignIn() {
        self.view.endEditing(true)
        let formData = ValidationsUtility.isFormDataValid(parent: self.view)
        if formData.isValid && self.validPassword() && self.isValidPhone() && self.isRegionSelected() {
            var params = formData.params
            params.updateValue(getPhoneNumber(), forKey: "phone")
            params.updateValue(self.countryCode.code ?? "", forKey: "country_code")
            params.updateValue(self.selectedRegion, forKey: "region_id")
            signUp(params: params)
        }
    }
    
    @IBAction func tappedOnRegion() {
        self.getRegions()
    }
    
    func isRegionSelected() -> Bool {
        if selectedRegion == nil {
            Utility.showErrorWith(message: Messages.SelectRegion.rawValue)
        }
        return selectedRegion != nil
    }
    
    var regions: [Region] = []
    func getRegions() {
        if regions.count == 0 {
            APIManager.sharedInstance.getCountries(success: { (result) in
                self.regions = result
                Utility().showSelectionPopup(title: "Regions", items: self.regions.map({$0.name.unWrap}), delegate: self)
            }) { (error) in
                
            }
        } else {
            Utility().showSelectionPopup(title: "Regions", items: self.regions.map({$0.name.unWrap}), delegate: self)
        }
    }
    
    @IBAction func tappedOnCodeField() {
        countryCode.presentCountriesViewController()
    }
    
    @IBAction func tappedOFB() {
        self.facebookLogin = true
        self.getRegions()
    }
    
    @IBAction func tappedOnGmail() {
        self.facebookLogin = false
        self.getRegions()
    }
    
    func loginWithFacebook() {
        Social.shared.loginWithFacebook(self, completion: { (result) in
            if let result = result {
                Utility.startProgressLoading()
                APIManager.sharedInstance.socialLogin(regionId: self.selectedRegion.unWrap,userSocialData: result, success: { (result) in
                    Utility.stopProgressLoading()
                    AppStateManager.sharedInstance.userData = result
                    if self.isForGuest {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Global.APP_DELEGATE.setupUX()
                    }
                    
                    APIManager.sharedInstance.refreshToken()
                }, failure: { (erorr) in
                    Utility.stopProgressLoading()
                })
            }
        }, downloadImage: true)
    }
    
    func loginWithGmail() {
        Social.shared.loginWithGoogle(self, completion: { (status,message,result)  in
            if let result = result {
                Utility.startProgressLoading()
                APIManager.sharedInstance.socialLogin(regionId: self.selectedRegion.unWrap,userSocialData: result, success: { (result) in
                    Utility.stopProgressLoading()
                    AppStateManager.sharedInstance.userData = result
                    if self.isForGuest {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Global.APP_DELEGATE.setupUX()
                    }
                    APIManager.sharedInstance.refreshToken()
                }, failure: { (erorr) in
                    Utility.stopProgressLoading()
                })
            }
        }, downloadImage: true)
    }
        
    func getPhoneNumber() -> String {
        if !(phoneNumber.text?.isEmpty ?? false) {
            return (phoneNumber.text ?? "")
        }
        return ""
    }
    
    func isValidPhone() -> Bool {
        if phoneNumber.text?.isEmpty ?? true ||  ValidationsUtility.isValidPhone(phone: phoneNumber.text ?? "") {
            return true
        } else {
            Utility.showErrorWith(message: Errors.InvalidPhone.rawValue)
            return false
        }
    }
    
    func validPassword() -> Bool {
        if passwordField.textField.text == confirmPasswordField.textField.text {
            return true
        }
        confirmPasswordField.showError(error: Errors.PasswordMismatch.rawValue)
        return false
    }
    
    func navigateToNextScreen() {
        let verificationController = PhoneVerificationVC.instantiate(fromAppStoryboard: .Login)
        verificationController.email = emailField.textField.text
        verificationController.isForRegistration = true
        verificationController.isForGuest = self.isForGuest
        self.navigationController?.pushViewController(verificationController, animated: true)
    }
    
    func signUp(params: Parameters) {
        APIManager.sharedInstance.performSignUp(params: params, success: { (result) in
            print("Success")
//            AppStateManager.sharedInstance.userData = result
//            APIManager.sharedInstance.refreshToken()
            self.navigateToNextScreen()
        }, responseType: UserBaseModel.self, failure: { (error) in
            
        })
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCode {
            return false
        }
        
        return true
    }
}

extension SignupViewController: ItemSelectionDelegate {
    func didItemSelect(position: Int, tag: String) {
        self.selectedRegion = self.regions[position].id.unWrap
        self.regionLabel.text = self.regions[position].name.unWrap
        
        if let loginWith = self.facebookLogin {
            if loginWith {
                self.loginWithFacebook()
            } else {
                self.loginWithGmail()
            }
        }
    }
}
