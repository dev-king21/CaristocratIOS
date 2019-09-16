//
//  VehicleCell.swift
 import UIKit
import Cosmos

class VehicleCell: UITableViewCell {
    
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelIsFeatured: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingViewWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(slug:String,vehicleModel: VehicleBase, isForReview: Bool) {
        
        
        
        labelTitle.text = vehicleModel.name ?? "-"
        if(isForReview){
            labelIsFeatured.isHidden  = true
        }else{
         labelIsFeatured.isHidden  = !(vehicleModel.isFeature?.value() ?? false)
        }
        
        
        var kmAndYear = ""
        if let km = vehicleModel.kilometer?.withCommas() {
            
             if slug == Slugs.APPROVED_PRE_OWNED.rawValue {
               kmAndYear += km + " KM - "
            }
            if slug == Slugs.CLASSIC_CARS.rawValue  {
               kmAndYear += km + " KM - "
            }
            
            
        }
        kmAndYear += (vehicleModel.year ?? 0).description
        labelYear.text = kmAndYear
        
        if let media = vehicleModel.media, media.count > 0 {
            self.imgCar.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: UIImage(named: "carplaceholder"))
        } else {
            self.imgCar.image = UIImage(named: "carplaceholder")
        }
        
        if slug == "luxury-new-cars" && !isForReview {
            if let logo = vehicleModel.car_model?.brand?.media?.first?.file_url {
                self.imgLogo.kf.setImage(with: URL(string:logo))
            }
        }
        
        if !isForReview {
            ratingViewWidth.constant = 0
        }
        
        if slug == Slugs.LUXURY_MARKET.rawValue {
            if isForReview {
                ratingView.isUserInteractionEnabled = false
                ratingView.isHidden = false
                ratingView.rating = Double(CGFloat(vehicleModel.average_rating ?? 0))
            }

            labelPrice.text = "\(vehicleModel.currency ?? "AED ") " + (vehicleModel.amount ?? 0).withCommas().description
        } else if slug == Slugs.THE_OUTLET_MALL.rawValue {
            labelPrice.text = "\(vehicleModel.currency ?? "AED ") " + (vehicleModel.amount ?? 0).withCommas().description
        } else if slug == Slugs.APPROVED_PRE_OWNED.rawValue  || slug == Slugs.CLASSIC_CARS.rawValue {
            labelPrice.text = "\(vehicleModel.currency ?? "AED ") " + (vehicleModel.amount ?? 0).withCommas().description
//            labelPrice.text = "\(vehicleModel.currency ?? "") " + (vehicleModel.average_mkp ?? 0).withCommas().description
        }
        
    }
    
}



