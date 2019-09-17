//
//  VehicleUserRateItemCell.swift
 import UIKit
import Cosmos

class VehicleUserRateItemCell: UICollectionViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    static let cellHeight = 25
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(reviewRatingModel: ReviewRatingModel) {
        rateLabel.text = reviewRatingModel.aspect_title ?? ""
        rateView.rating = Double(reviewRatingModel.rating ?? 0)
    }

}
