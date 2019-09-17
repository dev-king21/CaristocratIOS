//
//  SegmentHeaderCell.swift
 import UIKit

class SegmentHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var arrowButton: UIButton!
    var isExpended = false
    var delegate: EventPerformDelegate?
    var row: Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(bodyStyle: BodyStyleModel, delegate: EventPerformDelegate, forRow: Int, isExpanded: Bool) {
        titleLabel.text = bodyStyle.name?.uppercased() ?? ""
        self.carImage.kf.setImage(with: URL(string: bodyStyle.un_selected_icon ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        self.delegate = delegate
        self.row = forRow
        
        if !isExpanded{
            self.arrowButton.setImage(#imageLiteral(resourceName: "downarrow-1"), for: .normal)
        }
        else{
            self.arrowButton.setImage(#imageLiteral(resourceName: "uparrow"), for: .normal)
        }
    }
    
    @IBAction func tappedOnArrow() {
       delegate?.didActionPerformed(eventName: .didTapOnCollapseExpand, data: row)
    }
    
    
}

