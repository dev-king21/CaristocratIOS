//
//  PhoneVerificationVC.swift
 import UIKit
import PinCodeTextField
import CountdownLabel

class PhoneVerificationVC: BaseViewController {
    @IBOutlet weak var pinCodeField : PinCodeTextField!
    @IBOutlet weak var countDownLabel : CountdownLabel!
    var email: String?
    var isForRegistration = false
    var isForGuest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeAppearance()
    }
    
    func customizeAppearance() {
        pinCodeField.keyboardType = .numberPad
        self.startCountDown()
    }
    
    func startCountDown() {
        self.countDownLabel.isUserInteractionEnabled = false
        countDownLabel.timeFormat = "mm:ss"
        countDownLabel.countdownAttributedText = CountdownAttributedText(text: "Click here to resend code HERE", replacement: "HERE")
        self.countDownLabel.setCountDownTime(fromDate: NSDate() as NSDate, minutes: 60)
        countDownLabel.countdownDelegate = self
        countDownLabel.start()
    }
    
    func verifyCode() {
        APIManager.sharedInstance.verifyCode(verificationCode: Int(pinCodeField.text ?? "0") ?? 0, forVerification: self.isForRegistration, email: email, success: { (result) in
            self.moveAhead(userData: result)
        }) { (error) in
            
        }
    }
    
    func moveAhead(userData: UserBaseModel?) {
        if isForRegistration {
            AppStateManager.sharedInstance.userData = userData
            if isForGuest {
                self.dismiss(animated: true, completion: nil)
            } else {
                Global.APP_DELEGATE.setupUX()
            }
        } else {
            let resetPasswordController = ResetPasswordViewController.instantiate(fromAppStoryboard: .Login)
            resetPasswordController.email = email
            resetPasswordController.verificationCode = Int(pinCodeField.text ?? "0") ?? 0
            self.navigationController?.pushViewController(resetPasswordController, animated: true)
        }
        

//        var viewControllers = navigationController?.viewControllers
//        viewControllers?.remove(at: 1)
//        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    @IBAction func tappedOnSubmit() {
        self.view.endEditing(true)
        if pinCodeField.text?.length == 4 {
          self.verifyCode()
        } else {
          showAlertDialog(title: "Error", desc: "Enter Pin Code")
        }
    }
    
    @IBAction func tappedOnResend() {
        self.view.endEditing(true)
        self.resendCode()
    }
    
    func resendCode() {
        APIManager.sharedInstance.forgotPassword(parameters: ["email": email ?? "", "is_for_reset": !isForRegistration] ) { (isSuccess) in
            if isSuccess {
                self.startCountDown()
                Utility.showSuccessWith(message: Messages.CodeResent.rawValue)
            }
        }
    }

}
extension PhoneVerificationVC: CountdownLabelDelegate {
    func countdownFinished() {
        self.countDownLabel.isUserInteractionEnabled = true
        self.countDownLabel.text = "Click here to resend code"
    }
}



