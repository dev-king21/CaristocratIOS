//
//  SegmentHeaderCell.swift
 import UIKit

class SubSegmentHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var isExpended = false
    var delegate: EventPerformDelegate?
    var row: Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(group: Group, delegate: EventPerformDelegate, forRow: Int, isExpanded: Bool) {
        titleLabel.text = group.group
        self.delegate = delegate
        self.row = forRow
        
        if !isExpanded{
            self.checkButton.setImage(#imageLiteral(resourceName: "downarrow-1"), for: .normal)
        }
        else{
            self.checkButton.setImage(#imageLiteral(resourceName: "uparrow"), for: .normal)
        }
    }
    
    @IBAction func tappedOnArrow(_ sender: Any) {
       delegate?.didActionPerformed(eventName: .didTapOnCollapseExpand, data: row)
    }
    
    
}

