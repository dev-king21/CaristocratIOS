//
//  SelectedCarsCell.swift
 import UIKit

class SelectedCarsCell: UICollectionViewCell {
    
    @IBOutlet weak var carImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
	func setData(imageURL: String) {
        self.carImage.kf.setImage(with: URL(string: imageURL), placeholder: #imageLiteral(resourceName: "image_placeholder"))
    }
		
}
