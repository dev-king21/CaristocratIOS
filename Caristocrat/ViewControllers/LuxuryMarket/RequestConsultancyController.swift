//
//  RequestConsultancyController.swift
 import UIKit

class RequestConsultancyController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    var vehicleDetail: VehicleBase?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupField()
        
        emailField.keyboardType = .emailAddress
    }
    
    func setupField() {
        self.countryCode.delegate = self
        self.countryCode.phonePickerDelegate = self
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
    
    func submitRequest() {
        let params: Parameters = [
            "name":nameField.text ?? "",
            "email":emailField.text ?? "",
            "country_code":countryCode.code ?? "",
            "phone":phoneNumberField.text ?? "",
            "car_id":vehicleDetail?.id ?? 0]
        
        APIManager.sharedInstance.contactUs(params: params, success: { (result) in
            self.dismiss(animated: true, completion: nil)
            Utility.showSuccessWith(message: Messages.RequestSubmited.rawValue)
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
        } else if !ValidationsUtility.isNotEmpty(string: phoneNumberField.text ?? "")  {
            Utility.showAlert(title: "Error", message: Messages.EnterPhone.rawValue)
            return false
        }
        return true
    }
    
    @IBAction func tappedOnClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnSubmit() {
        if validateForm() {
            self.submitRequest()
        }
    }
}

extension RequestConsultancyController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCode {
            return false
        }
        
        return true
    }
}

