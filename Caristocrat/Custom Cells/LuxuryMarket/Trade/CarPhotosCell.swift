//
//  CarPhotosCell.swift
 import UIKit

class CarPhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    var delegate: CarPhotoCellDelegate?
    var position = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setData(image: UIImage) {
        carImage.image = image
    }
    
    
    @IBAction func tappedOnClose() {
        delegate?.didTapOnClose(position: position)
    }
}
