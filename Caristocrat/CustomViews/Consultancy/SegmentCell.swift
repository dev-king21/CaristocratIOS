//
//  SegmentCell.swift
 import UIKit

class SegmentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(segment: ChildSegment) {
        self.titleLabel.text = segment.name?.uppercased() ?? ""
    }
    
    
}
