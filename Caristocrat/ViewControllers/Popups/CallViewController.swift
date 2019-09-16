//
//  CallViewController.swift
 import UIKit

class CallViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    var titleText = ""
    var phoneNumber = ""
    var carId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = titleText
        self.lblPhoneNumber.text = phoneNumber
    }
    
    static func makeCall(titleText: String, phoneNumber: String, carId: Int) {
        let callViewController = CallViewController.instantiate(fromAppStoryboard: .Popups)
        callViewController.titleText = titleText
        callViewController.phoneNumber = phoneNumber
        callViewController.carId = carId
        callViewController.modalPresentationStyle = .overCurrentContext
        callViewController.modalTransitionStyle = .crossDissolve
        Utility().topViewController()?.present(callViewController, animated: true, completion: nil)
    }
    
    func submitInteraction() {
        APIManager.sharedInstance.carInteraction(car_id: carId,
                                                 interactionType: .Phone, success: { (result) in
                                                    
        }) { (error) in
            
        }
    }
    
    @IBAction func tappedOnClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnCall() {
        dismiss(animated: true, completion: nil)
        self.submitInteraction()
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
}

