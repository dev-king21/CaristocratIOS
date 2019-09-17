//
//  VehicleSubmitRateItemCell.swift
 import UIKit
import Cosmos

class VehicleSubmitRateItemCell: UITableViewCell {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    
    static let cellHeight = 50
    var lastValue : Double = 0.0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
        
        rateView.didFinishTouchingCosmos = { rating in
            print(rating)
            if(self.lastValue == 1.0 && self.rateView.rating == 1.0) {
                self.rateView.rating = 0.0
            }
            self.lastValue = self.rateView.rating
            print(self.rateView.rating)
        }
    }
    
    func setData(rateFieldsModel: RateFieldsModel) {
        rateLabel.text = rateFieldsModel.title ?? ""
        rateView.isUserInteractionEnabled = true
    }
    
    func setData(reviewRatingModel: ReviewRatingModel) {
        // The method will use for populate own rating.
        rateView.isUserInteractionEnabled = false
        rateLabel.text = reviewRatingModel.aspect_title ?? ""
        rateView.rating = reviewRatingModel.rating ?? 0
    }
    
}

