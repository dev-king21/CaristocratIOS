//
//  MyTradeInsCell.swift
 import UIKit

class MyTradeInsCell: UITableViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var ChessisLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(vehicleDetail: VehicleBase, forEvaluation: Bool, forFavorite: Bool) {
        let vehicleName = vehicleDetail.name ?? ""
        let noVehicleName = ((vehicleDetail.car_model?.brand?.name ?? "") + " " + (vehicleDetail.car_model?.name ?? ""))
        nameLabel.text = noVehicleName //!(vehicleDetail.name ?? "").isEmpty ? vehicleName : noVehicleName

        if forEvaluation {
            nameLabel.text = noVehicleName
        }
        
        if forFavorite {
            modelLabel.text = "Model "+(vehicleDetail.car_model?.name ?? "-")
        } else {
            if vehicleDetail.year ?? 0 > 0 {
                modelLabel.text = "Year \((vehicleDetail.year ?? 0))"
            } else {
                modelLabel.text = ""
            }
        }
        
        if let chessis = vehicleDetail.chassis, forFavorite {
            ChessisLabel.isHidden = false
            ChessisLabel.text = "Chassis \(chessis)"
        } else {
            ChessisLabel.isHidden = true
            ChessisLabel.text = ""
        }
        

        
        
        self.carImage.image = nil
        
        if let media = vehicleDetail.media, media.count > 0 {
            self.carImage.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.carImage.image = UIImage(named: "image_placeholder")
        }
    }
}
