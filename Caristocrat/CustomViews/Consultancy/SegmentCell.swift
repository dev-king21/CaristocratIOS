//
//  SegmentCell.swift
 import UIKit

class SegmentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(groupData: GroupData) {
        self.titleLabel.text = groupData.version
    }
    
    
}

