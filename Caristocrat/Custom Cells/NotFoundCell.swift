//
//  NotFoundCell.swift
 import UIKit

class NotFoundCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(text: String) {
        self.textLbl.text  = text
    }
   
}
