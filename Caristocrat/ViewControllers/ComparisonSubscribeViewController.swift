//
//  ComparisonSubscribeViewController.swift
//  Caristocrat
//
//  Created by Khunshan Ahmad on 10/09/2019.
//  Copyright © 2019 Ingic. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import SwiftDate

class ComparisonSubscribeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var subscribeButton: UIButton!
    var subscribedSuccessfully: (() -> Void)?

    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeButton.isEnabled = true
        subscribeButton.alpha = 1.0
    }
    
    //IBActions
    @IBAction func subscribeButtonPressed(_ sender: UIButton) {
        print("subscribe pressed")
        
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
        
        subscribe()
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

//API
extension ComparisonSubscribeViewController {
    
    func subscribe() {
        
        guard let userId = AppStateManager.sharedInstance.userData?.user?.id else { return }
        
        let date = Date() + 10.years
        let dateString = date.toFormat("yyyy-MM-dd hh:mm:ss")
        
        APIManager.sharedInstance.subscribeForComparision(userId: "\(userId)", toDate: dateString, txnId: "asdf", success: { (result) in
            print("result")
            self.subscriptionSuccess(showAlert: true)
        }, failure: { (error) in
            print("error")
        })
    }
    
    private func subscriptionSuccess(showAlert: Bool) {
        
        if showAlert {
            let alert = UIAlertController(title: "Success", message: "You have successfully registered to professional comparison.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                
                self.subscribedSuccessfully?()
                self.dismiss(animated: true)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.subscribedSuccessfully?()
            self.dismiss(animated: true)
        }
    }
}
