//
//  TradeInDetailBidsTitleCell.swift
 import UIKit

class TradeInDetailBidsTitleCell: UITableViewCell {
    
    @IBOutlet weak var lblText: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    func setData(vehicleDetail: VehicleBase) {
        if (vehicleDetail.top_bids?.count ?? 0 ) > 0 {
            lblText?.text = String(format: Constants.BIDS_TITLE, vehicleDetail.top_bids?.count ?? 0, vehicleDetail.name ?? "", vehicleDetail.chassis ?? "")
        } else {
            lblText?.text = "Waiting for Results."
        }

    }

   
}
