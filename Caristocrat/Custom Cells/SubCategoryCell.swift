//
//  AutoLifeCategoryCell.swift
 import UIKit

class SubCategoryCell: UITableViewCell {
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var unReadCount: UILabel!
    @IBOutlet weak var articleBG: UIView!
    var categoryModel: CategoryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(category: CategoryModel) {
        self.categoryModel = category
        self.titleLabel.text = categoryModel?.name
        self.descLabel.text = categoryModel?.subtitle

        if let media = category.media, media.count > 0 {
            self.bannerImage.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.bannerImage.image =  #imageLiteral(resourceName: "image_placeholder")
        }
        
        if let unreadCount = category.unreadCount, unreadCount > 0 , AppStateManager.sharedInstance.isUserLoggedIn(){
            self.articleBG.isHidden = false
            self.unReadCount.text = "\(unreadCount) NEW ARTICLE\(unreadCount > 1 ? "S": " ")"
        } else {
            self.articleBG.isHidden = true
        }
    }
    
}
