//
//  ChangePasswordViewController.swift
 import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var currentPassField: CustomTextField!
    @IBOutlet weak var newPassField: CustomTextField!
    @IBOutlet weak var confirmPassField: CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeAppearance()
    }
    
    func customizeAppearance() {
        self.title = "Change Password"
    }
    
    @IBAction func tappedOnUpdate() {
        self.view.endEditing(true)
        let formData = ValidationsUtility.isFormDataValid(parent: self.view)
        if formData.isValid && isValidPassword() {
            submitChangePasswordRequest(params: formData.params)
        }
    }
    
    @IBAction func tappedOnBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func isValidPassword() -> Bool {
        if newPassField.textField.text == confirmPassField.textField.text {
            return true
        }
        
        confirmPassField.showError(error: Errors.PasswordMismatch.rawValue)
        return false
    }
    
    func submitChangePasswordRequest(params: Parameters) {
        APIManager.sharedInstance.changePassword(params: params, success: { (result) in
            Utility.showSuccessWith(message: Messages.PasswordChanged.rawValue)
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            
        }
    }

}
