//
//  MinimumRatingCell.swift
 import UIKit
import Cosmos

class MinimumRatingCell: UITableViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
       ratingView.settings.fillMode = .full
    }
    
    func setData() {
        ratingView.rating = AppStateManager.sharedInstance.filterOptions?.rating ?? 0
        
        ratingView.didFinishTouchingCosmos = { result in
            AppStateManager.sharedInstance.filterOptions?.rating = result
        }
    }
    
    
}
