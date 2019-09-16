//
//  FavNewsCell.swift
 import UIKit

class FavNewsTabCell: UICollectionViewCell {
    
    var favNewsModel: NewsFavoriteModel?
    @IBOutlet weak var titleLabel: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(favNewsModel: NewsFavoriteModel) {
        self.titleLabel?.text = " \(favNewsModel.name ?? "") "
    }
    
    func setTitle(title: String) {
        titleLabel?.text = title
    }
}
