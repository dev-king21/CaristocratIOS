//
//  SettingsVC.swift
 import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var selectRegionLabel: UILabel!
    
    var regions: [Region] = []
    var selectedRegion: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationSwitch.addTarget(self, action: #selector(notificationSwitchDidChange(_:)), for: .valueChanged)
        notificationSwitch.isOn = AppStateManager.sharedInstance.userData?.user?.push_notification?.value() ?? false
        
        changePasswordView.isHidden = AppStateManager.sharedInstance.userData?.user?.details?.social_login ?? false
        selectRegionLabel.text = AppStateManager.sharedInstance.userData?.user?.details?.region?.name ?? ""
        
    }
    
    @objc func notificationSwitchDidChange(_ sender: UISwitch) {
        self.updateSettings()
    }
    
    @IBAction func tappedOnBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnChangePassword() {
        let changePassword = ChangePasswordViewController.instantiate(fromAppStoryboard: .Login)
        present(changePassword, animated: true, completion: nil)
    }
    
    @IBAction func tappedOnEditProfile() {
        let editProfileController = EditProfileViewController.instantiate(fromAppStoryboard: .Login)
        present(editProfileController, animated: true, completion: nil)
    }
    
    @IBAction func tappedOnMySubscriptions(_ sender: Any) {
        let mySubscriptionsViewController = MySubscriptionsViewController.instantiate(fromAppStoryboard: .Login)
        present(mySubscriptionsViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedOnLogout() {
        self.logout()
    }
    
    @IBAction func tappedOnDeleteAccount() {
        AlertViewController.showAlert(title: "Deactivate Account", description: "Are you sure, Do you want to deactivate your account?", delegate: self)
    }
    
    func updateSettings() {
        APIManager.sharedInstance.updateNotificationSetting(enable: notificationSwitch.isOn, success: { (result) in
            AppStateManager.sharedInstance.userData?.user?.push_notification = self.notificationSwitch.isOn ? 1 : 0
        }) { (error) in
            
        }
    }
    
    func logout() {
        Utility.showAlert(title: "Logout", message: "Are you sure you want to logout?", positiveText: "Yes", positiveClosure: { (action) in
            APIManager.sharedInstance.logout { (isSuccess) in
                if isSuccess {
                    AppStateManager.sharedInstance.clearData()
                    Global.APP_DELEGATE.window?.rootViewController?.dismiss(animated: false, completion: nil)
                    Global.APP_DELEGATE.window = nil
//                  Global.APP_DELEGATE.window?.rootViewController?.view = nil
//                  Global.APP_DELEGATE.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
                    Global.APP_DELEGATE.setupUX()
//                  DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
//                    })

                }
            }
        }, navgativeText: "No")
    }
    
    @IBAction func tappedOnRegion() {
        self.getRegions()
    }

    func getRegions() {
        if regions.count == 0 {
            APIManager.sharedInstance.getCountries(success: { (result) in
                self.regions = result
                Utility().showSelectionPopup(title: "Regions", items: self.regions.map({$0.name.unWrap}), tapClouser: { (position, tag) in
                    self.selectedRegion = self.regions[position].id.unWrap
                    AppStateManager.sharedInstance.userData?.user?.details?.region = self.regions[position]
                    self.selectRegionLabel.text = self.regions[position].name.unWrap
                    self.saveRegion()
                })
            }) { (error) in
                
            }
        } else {
            Utility().showSelectionPopup(title: "Regions", items: self.regions.map({$0.name.unWrap}), tapClouser: { (position, tag) in
                self.selectedRegion = self.regions[position].id.unWrap
                self.selectRegionLabel.text = self.regions[position].name.unWrap
                self.saveRegion()
            })
        }
    }
    
    func saveRegion() {
        Utility.startProgressLoading()
        APIManager.sharedInstance.updateProfile(params: ["region_id": self.selectedRegion?.description ?? ""], images: [:], success: { (result) in
            Utility.stopProgressLoading()
        }, failure: { (error) in
            Utility.stopProgressLoading()
        }, showLoader: true)
    }
}

extension SettingsVC: AlertViewDelegates {
    func didTapOnRightButton() {
        Utility.startProgressLoading()
        APIManager.sharedInstance.updateProfile(params: ["status":"0"], images: [:], success: { (result) in
            AppStateManager.sharedInstance.clearData()
            Global.APP_DELEGATE.window = nil
            Global.APP_DELEGATE.setupUX()
        }, failure: { (error) in
            Utility.stopProgressLoading()
        }, showLoader: true)
    }
    
    func didTapOnLeftButton() {
        
    }
}

