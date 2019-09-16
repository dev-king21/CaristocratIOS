//
//  StayUpdatedPopup.swift
 import Foundation
import UIKit

class StayUpdatedPopupController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tappedOnEnable() {
        APIManager.sharedInstance.updateNotificationSetting(enable: true, success: { (result) in
            AppStateManager.sharedInstance.userData?.user?.push_notification = 1
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedOnLater() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
