//
//  VehicleHeaderCell.swift
 import UIKit

class VehicleHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lblHeading: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(text: String) {
        lblHeading.text = text
    }
    
}
