//
//  MarketCell.swift
 import UIKit

class MarketCell: UITableViewCell {
    
    @IBOutlet weak var backTitleLabel: UILabel!
    @IBOutlet weak var backShortDescLabel: UILabel!
    @IBOutlet weak var frontTitleLabel: UILabel!
    @IBOutlet weak var frontDescLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var parentView: UIView!
    

    
    var isFront = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        frontView.isHidden = true
    }

    func setData(category: CategoryModel) {
        
        
        self.backTitleLabel.text = category.name
        self.backShortDescLabel.text = category.subtitle
        self.frontTitleLabel.text = category.name
        self.frontDescLabel.text = category.desc
        
        if let media = category.media, media.count > 0 {
            self.carImage.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        }
    }
    
    func flipTransition() {
        frontView.isHidden = isFront
        backView.isHidden = !isFront
        
        isFront = !isFront
        var transitionOptions = UIView.AnimationOptions()
        transitionOptions = [.transitionFlipFromRight]
        
        UIView.transition(with: self.parentView, duration: 0.7, options: transitionOptions, animations: {
        })
    }
    
    
    @IBAction func infoButtonTapped() {
        flipTransition()
    }
    
}
