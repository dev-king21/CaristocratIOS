//
//  SimilarVehicleCell.swift
 import UIKit

class SimilarVehicleCell: UICollectionViewCell {
   
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelKM: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(vehicleModel: VehicleBase) {
        labelTitle.text = vehicleModel.name ?? "-"
        labelYear.text = "\(vehicleModel.year ?? 0)"
        labelPrice.text = "\(vehicleModel.currency ?? "") " + (vehicleModel.amount?.withCommas() ?? "-").description
        labelKM.text = vehicleModel.kilometer == nil ? "" : vehicleModel.kilometer.unWrap.withCommas() + " KM"
        if let media = vehicleModel.media, media.count > 0 {
            self.imgCar.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.imgCar.image = UIImage(named: "image_placeholder")
        }
    }
   

}
