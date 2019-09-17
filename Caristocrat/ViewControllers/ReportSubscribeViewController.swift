//
//  ReportSubscribeViewController.swift
//  Caristocrat
//
//  Created by Khunshan Ahmad on 05/09/2019.
//  Copyright © 2019 Ingic. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import SwiftDate

enum ReportType {
    case Single, Multi
}

class ReportSubscribeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var singleReportBullet: UIView!
    @IBOutlet weak var multiReportBullet: UIView!
    
    @IBOutlet weak var singleReportView: UIView!
    @IBOutlet weak var multiReportView: UIView!
    
    @IBOutlet weak var subscribeButton: UIButton!
    
    private var selectedReport: ReportType?
    
    var subscribedSuccessfully: ((Bool) -> Void)?
    
    var newsId: Int?
    
    var redirectToSubscribe = false
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeButton.isEnabled = false
        subscribeButton.alpha = 0.6
        
        fetchIAP()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //1) Subscribe if logged in and subscription is selected.
        //2) Dismiss if logged in and already subscribed.
        if redirectToSubscribe, let reportId = newsId, let userId = AppStateManager.sharedInstance.userData?.user?.id {
            
            APIManager.sharedInstance.checkReportPayment(userId: "\(userId)", reportId: "\(reportId)", success: { (model: [ReportPaymentCheckModel]) in
                
                if model.count > 0 {
                    //already subscribed
                    self.subscriptionSuccess(showAlert: false)
                } else {
                    //request subscribe
                    self.subscribe()
                }
                
            }, failure: { error in
                print(error)
            })
        }
        
    }
    
    //IBActions
    @IBAction func subscribeButtonPressed(_ sender: UIButton) {
        print("subscribe pressed")
        
        redirectToSubscribe = true
        
        if AppStateManager.sharedInstance.isUserLoggedIn() == false {
            let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
            signinController.isGuest = true
            signinController.guestLabelText = "CANCEL"
            self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
        }
        else {
            //Subscribe
            subscribe()
        }
    }

    func fetchIAP() {
        //IAP
        SwiftyStoreKit.retrieveProductsInfo(["com.teamingic.caristocrat.SingleReportPurchase"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("~ Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("~ Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("~ Error: \(String(describing: result.error))")
            }
        }
    }
}

//Tap gestures
extension ReportSubscribeViewController {
    
    @IBAction func singleReportTapped(_ sender: UITapGestureRecognizer) {
        print("single report tapped")
        subscribeButton.isEnabled = true
        subscribeButton.alpha = 1
        singleReportBullet.backgroundColor = .black
        multiReportBullet.backgroundColor = .white
        selectedReport = .Single
    }
    
    @IBAction func multiReportTapped(_ sender: UITapGestureRecognizer) {
        print("multi report tapped")
        subscribeButton.isEnabled = true
        subscribeButton.alpha = 1
        singleReportBullet.backgroundColor = .white
        multiReportBullet.backgroundColor = .black
        selectedReport = .Multi
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }

}

//API
extension ReportSubscribeViewController {

    func subscribe() {
        
        guard let reportId = newsId, let userId = AppStateManager.sharedInstance.userData?.user?.id else { return }

        let date = Date() + 1.years
        let dateString = date.toFormat("yyyy-MM-dd hh:mm:ss")
        
        if selectedReport == .Single {
            APIManager.sharedInstance.subscribeForSingleReport(reportId: "\(reportId)", userId: "\(userId)", toDate: dateString, txnId: "asdf", success: { (result) in
                print("result")
                self.subscriptionSuccess(showAlert: true)
            }, failure: { (error) in
                print("error")
            })
        }
        else if selectedReport == .Multi {
            APIManager.sharedInstance.subscribeForMultipleReport(userId: "\(userId)", toDate: dateString, txnId: "asdf", success: { (result) in
                print("result")
                self.subscriptionSuccess(showAlert: true)
            }, failure: { (error) in
                print("error")
            })
        }
    }
    
    private func subscriptionSuccess(showAlert: Bool) {
        
        if showAlert {
            let alert = UIAlertController(title: "Success", message: "You have successfully registered to this training course", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                
                self.subscribedSuccessfully?(showAlert)
                self.dismiss(animated: true)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.subscribedSuccessfully?(showAlert)
            self.dismiss(animated: true)
        }
    }
}
