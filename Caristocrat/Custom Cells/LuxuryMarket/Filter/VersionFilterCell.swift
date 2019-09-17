//
//  BrandFilterCell.swift
 import UIKit

class VersionFilterCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var versionField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData() {
        versionField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        versionField.text = AppStateManager.sharedInstance.filterOptions?.version
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        AppStateManager.sharedInstance.filterOptions?.version = versionField.text
    }
    
}
