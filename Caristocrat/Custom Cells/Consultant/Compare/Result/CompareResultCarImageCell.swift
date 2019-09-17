//
//  CompareResultCarCell.swift
 import UIKit
import SpreadsheetView

class CompareResultCarImageCell: Cell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var yearLabel: MarqueeLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(vehicleDetail: VehicleBase) {
        titleLabel.text = vehicleDetail.name ?? "-"
        if let media = vehicleDetail.media, media.count > 0 {
            self.carImage.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.carImage.image = #imageLiteral(resourceName: "image_placeholder")
        }
        
        yearLabel.text = "\(vehicleDetail.currency ?? "") " + "\((vehicleDetail.amount?.withCommas() ?? ""))"
    }

}
