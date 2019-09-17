//
//  DescriptionCell.swift
 import UIKit

class DescriptionCell: UITableViewCell {
    
    @IBOutlet weak var lblDesc: UILabel!
    var vehicleDetail: VehicleBase?
    @IBOutlet weak var imgArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(vehicleDetail: VehicleBase) {
        self.vehicleDetail = vehicleDetail
    }
    
    @IBAction func tappedOnCollapse() {
        lblDesc.isHidden = !lblDesc.isHidden
        if lblDesc.isHidden{
            self.imgArrow.setImage(#imageLiteral(resourceName: "downarrow-1"), for: .normal)
        }
        else{
            self.imgArrow.setImage(#imageLiteral(resourceName: "uparrow"), for: .normal)
        }
        lblDesc.text = lblDesc.isHidden ? "" : vehicleDetail?.notes
        if let parentTable = superview as? UITableView {
            parentTable.reloadData()
        }
    }
    
}

