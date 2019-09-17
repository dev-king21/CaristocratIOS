//
//  ReviewCel.swift
 import UIKit

class UsersReviewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(reviewsDetail: ReviewModel) {
        self.profileImage.kf.setImage(with: URL(string: reviewsDetail.user_details?.image_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        self.usernameLabel.text = (reviewsDetail.user_details?.user_name ?? "") + " (" + (reviewsDetail.average_rating ?? 0.0).description + ")"
        self.reviewLabel.text = reviewsDetail.review_message ?? ""
    }
}
