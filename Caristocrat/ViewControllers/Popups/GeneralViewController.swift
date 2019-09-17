//
//  GeneralViewController.swift
 import UIKit

class GeneralViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var btnOk: UIButton!
    

    var titleText = ""
    var descTitle = ""
    var desc = ""
    var btnOkTitle = ""
    
    var delegate: PopupDelgates?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = titleText
        self.lblDescTitle.text = descTitle
        self.lblDesc.text = desc
        self.btnOk.setTitle(btnOkTitle, for: .normal)
        
        if lblTitle.text?.isEmpty ?? false {
            lblTitleHeight.constant = 0
        }
    }
    
    @IBAction func tappedOnClose() {
        dismiss(animated: true, completion: {
            self.delegate?.didTapOnClose()
        })
    }
}

protocol PopupDelgates {
    func didTapOnClose()
}
