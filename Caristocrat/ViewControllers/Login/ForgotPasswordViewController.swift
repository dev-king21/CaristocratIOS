//
//  ForgotPasswordViewController.swift
 import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var emailField: CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.textField.keyboardType = .emailAddress
    }
    
    @IBAction func tappedOnSubmit() {
        self.view.endEditing(true)
        let formData = ValidationsUtility.isFormDataValid(parent: self.view)
        if formData.isValid {
            self.forgotPassword(params: formData.params)
        }
        
    }
    
    func moveAhead() {
        let verificationController = PhoneVerificationVC.instantiate(fromAppStoryboard: .Login)
        verificationController.email = emailField.textField.text
        self.navigationController?.pushViewController(verificationController, animated: true)
        
//        var viewControllers = navigationController?.viewControllers
//        viewControllers?.remove(at: 1)
//        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    func forgotPassword(params: Parameters) {
        
        var parameter = params
        parameter["is_for_reset"] = 1
        
        APIManager.sharedInstance.forgotPassword(parameters: parameter) { (isSuccess) in
            if isSuccess {
                self.moveAhead()
            }
        }
    }
}
