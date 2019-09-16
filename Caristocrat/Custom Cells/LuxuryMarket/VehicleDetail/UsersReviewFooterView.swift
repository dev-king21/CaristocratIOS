//
//  UsersReviewFooterView.swift
 import UIKit

class UsersReviewFooterView: UIView {
    
    var delegate: (() -> Void)?
    
    func setData(delegate: (() -> Void)?) {
        self.delegate = delegate
    }
    
    @IBAction func tappedOnReadMore() {
        self.delegate?()
    }
    
}
