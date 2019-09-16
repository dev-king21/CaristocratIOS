//
//  SectionsHeader.swift
 import UIKit
import Cosmos

class UserReviewSectionHeader: UIView {
    static let heightOfView: CGFloat = 50.0
    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblAverageRating : UILabel!
    
    var vehicleDetail: VehicleBase?
    var slug: String?
    var delegate: VechicleDetailCellsDelegate?
    
    func setData(vehicleDetail: VehicleBase) {
        
        if !(vehicleDetail.is_reviewed?.value() ?? true) {
            addReviewButton.isHidden = false
        }
        
        lblAverageRating.text = "(" + Double(vehicleDetail.average_rating ?? 0.0).addOneZero().description + ")"
        ratingLabel.text = "USER REVIEWS  (" + String(vehicleDetail.review_count!) + ")"
        ratingView.rating = Double(vehicleDetail.average_rating ?? 0.0)
    }
    
    @IBAction func tappedOnAddReview() {
        let vehicleReviewContoller = VehicleReviewContoller.instantiate(fromAppStoryboard: .Consultant)
        vehicleReviewContoller.carId = vehicleDetail?.id.unWrap
        vehicleReviewContoller.slug = self.slug
        Utility().topViewController()?.navigationController?.pushViewController(vehicleReviewContoller, animated: true)
        delegate?.didReviewSubmitted()
    }

}
