//
//  MyCarCell.swift
 import UIKit

class MyCarCell: UICollectionViewCell {
    
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func setData(vehicleDetail: VehicleBase) {
        lblTitle.text = vehicleDetail.car_model?.brand?.name ?? ""
        lblModel.text = vehicleDetail.car_model?.name ?? ""
        self.carImg.image = nil
        if let media = vehicleDetail.media, media.count > 0 {
            self.carImg.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        }
    }
    
   

}
