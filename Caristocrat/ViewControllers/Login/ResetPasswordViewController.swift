//
//  ResetPasswordViewController.swift
 import UIKit

class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var passField: CustomTextField!
    @IBOutlet weak var confirmpassField: CustomTextField!
    var email: String?
    var verificationCode: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tappedOnSubmit() {
        self.view.endEditing(true)
        let formData = ValidationsUtility.isFormDataValid(parent: self.view)
        if formData.isValid  && isValidPassword() {
            self.resetPassword(params: formData.params)
        }
    }
    
    func resetPassword(params: Parameters) {
        APIManager.sharedInstance.resetPassword(email: email ?? "", verificationCode: verificationCode ?? 0 ,params: params, success: { (result) in
            Utility.showSuccessWith(message: Messages.PasswordChanged.rawValue)
            Global.APP_DELEGATE.setupUX()
        }) { (error) in
            
        }
    }
    
    func isValidPassword() -> Bool {
        if passField.textField.text == confirmpassField.textField.text {
            return true
        }
        
        confirmpassField.showError(error: Errors.PasswordMismatch.rawValue)
        return false
    }
}
