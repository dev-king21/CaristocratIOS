//
//  MyCarTableViewCell.swift
 import UIKit

class MyTradeCarCell: UITableViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var ChessisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(vehicleDetail: VehicleBase) {
       
        nameLabel.text = (vehicleDetail.car_model?.brand?.name ?? "") + " " + (vehicleDetail.car_model?.name ?? "")
        //modelLabel.text = "Model "+(vehicleDetail.car_model?.name ?? "")
        ChessisLabel.text = "Chassis "+(vehicleDetail.chassis ?? "")
        self.carImage.image = nil
        
        if let media = vehicleDetail.media, media.count > 0 {
            self.carImage.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.carImage.image = UIImage(named: "image_placeholder")
        }
    }
}
