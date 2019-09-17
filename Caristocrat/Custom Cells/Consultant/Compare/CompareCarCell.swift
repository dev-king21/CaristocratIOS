//
//  CompareCarCell.swift
 import UIKit

class CompareCarCell: UITableViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var addRemoveButton: UIButton!
    var delegate: CompareCarDelegates?
    var vehicleDetail: VehicleBase?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(vehicleDetail: VehicleBase, isSelected: Bool) {
        self.vehicleDetail = vehicleDetail
        carName.text = vehicleDetail.name ?? "-"
        carPrice.text = "\(vehicleDetail.currency ?? "") " + (vehicleDetail.amount ?? 0).withCommas().description
        self.carImage.kf.setImage(with: URL(string: vehicleDetail.media?.first?.file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        self.addRemoveButton.setImage(isSelected ? UIImage(named: "minus") as UIImage? : UIImage(named: "add_with_round") as UIImage?, for: .normal)
    }
    
    @IBAction func tappedOnAddRemoveButton() {
        delegate?.didCarSelected(vehicleDetail: self.vehicleDetail!)
    }

}
