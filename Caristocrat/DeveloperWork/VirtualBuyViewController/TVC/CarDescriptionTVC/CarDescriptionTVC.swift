//
//  CarDescriptionTVC.swift
 import UIKit

class CarDescriptionTVC: UITableViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carYear: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    
    func setData(car: VehicleBase?){
        guard let data = car else {return}
        if let image_url = data.media?.first?.file_url {
            self.carImage.kf.setImage(with: URL(string: image_url), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.carImage.image = UIImage(named: "image_placeholder")
        }
        self.carName.text = data.car_model?.name ?? "-"
        self.carModel.text = data.car_model?.brand?.name ?? "-"
        self.carYear.text = "\(data.year ?? 0)"
        self.carPrice.text = "\(data.currency ?? "")" + " " + Utility.commaSeparatedNumber(number: "\(data.amount ?? 0)") 
    }

}
