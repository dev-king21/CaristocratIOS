    //
//  SignInViewController.swift
 import UIKit
import FBSDKLoginKit

class SignInViewController: BaseViewController {
    var redirectToSignup = false
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var guestLabel: UILabel!

    var selectedRegion: Int?
    var facebookLogin: Bool?
    var isGuest = false
    var guestLabelText: String?

    override func viewDidLoad() {
        transparentNavBar = true
        
        super.viewDidLoad()
        self.customizeAppearance()
        
        if redirectToSignup {
            self.navigationController?.pushViewController(SignupViewController.instantiate(fromAppStoryboard: .Login), animated: false)
        }
        
        self.emailField.textField.keyboardType = .emailAddress
        
        if let text = guestLabelText {
            guestLabel.text = guestLabelText
        }
    }
    
    func customizeAppearance() {

    }
    
    @IBAction func tappedOnSignIn() {
        self.view.endEditing(true)
        let formData = ValidationsUtility.isFormDataValid(parent: self.view)
        if formData.isValid {
            signIn(params: formData.params)
        }
    }
    
    @IBAction func tappedOFB() {
       self.facebookLogin = true
        
       self.loginWithFacebook()
    }
    
    func loginWithFacebook() {
        Social.shared.loginWithFacebook(self, completion: { (result) in
            if let result = result {
                Utility.startProgressLoading()
                APIManager.sharedInstance.socialLogin(regionId: self.selectedRegion.unWrap,userSocialData: result, success: { (result) in
                    Utility.stopProgressLoading()
                    AppStateManager.sharedInstance.userData = result
                    if let _ = AppStateManager.sharedInstance.userData?.user?.details?.region {
                        if self.isGuest {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            Global.APP_DELEGATE.setupUX()
                        }
                    } else {
                        self.getRegions()
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
                print(result.email)
                print(result.name)
                print(result.userImage)
                Utility.startProgressLoading()
                APIManager.sharedInstance.socialLogin(regionId: self.selectedRegion.unWrap,userSocialData: result, success: { (result) in
                    Utility.stopProgressLoading()
                    AppStateManager.sharedInstance.userData = result
                    print(result.user?.details?.first_name)
                    if let _ = AppStateManager.sharedInstance.userData?.user?.details?.region {
                        if self.isGuest {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            Global.APP_DELEGATE.setupUX()
                        }
                    } else {
                       self.getRegions()
                    }
                    APIManager.sharedInstance.refreshToken()
                }, failure: { (erorr) in
                    Utility.stopProgressLoading()
                })
            }
        }, downloadImage: true)
    }
        
    @IBAction func tappedOnGmail() {
        self.facebookLogin = false
 
        self.loginWithGmail()
    }
    
    @IBAction func tappedOnLoginAsGuest() {
        if isGuest {
            self.dismiss(animated: true, completion: nil)
        } else {
            Global.APP_DELEGATE.loadHomePage()
        }
        
    }
    
    @IBAction func tappedOnSignup() {
        let signupViewController = SignupViewController.instantiate(fromAppStoryboard: .Login)
        signupViewController.isForGuest = isGuest
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    func navigateToVerificationScreen() {
        let verificationController = PhoneVerificationVC.instantiate(fromAppStoryboard: .Login)
        verificationController.email = emailField.textField.text
        verificationController.isForRegistration = true
        verificationController.isForGuest = isGuest
        self.navigationController?.pushViewController(verificationController, animated: true)
    }
    
    func signIn(params: Parameters) {
        APIManager.sharedInstance.performSignIn(params: params, success: { (result) in
            print("Success")
            
            if result.user?.details?.is_verified?.value() ?? false {
                AppStateManager.sharedInstance.userData = result
                if self.isGuest {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Global.APP_DELEGATE.setupUX()
                }
                
//                APIManager.sharedInstance.refreshToken()
            } else {
                self.navigateToVerificationScreen()
            }

        }, responseType: UserBaseModel.self, failure: { (error) in
            if error.code == 300 {
                self.navigateToVerificationScreen()
            }
        })
    }
    
    func isRegionSelected() -> Bool {
        return false
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
}

extension SignInViewController: ItemSelectionDelegate {
    func didItemSelect(position: Int, tag: String) {
        self.selectedRegion = self.regions[position].id.unWrap
        AppStateManager.sharedInstance.userData?.user?.details?.region = self.regions[position]
        
        if self.isGuest {
            self.dismiss(animated: true, completion: nil)
        } else {
            Global.APP_DELEGATE.setupUX()
        }
    }
}
