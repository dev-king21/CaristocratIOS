//
//  BrandItemCell.swift
 import UIKit

protocol BrandItemCellDelegate : class {
    func checkBoxTapped(cell:BrandItemCell)
}


class BrandItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBrand: UIImageView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    weak var delegate:BrandItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(brand: Brand) {
        //updateSelection(isChecked: (AppStateManager.sharedInstance.filterOptions?.selectedBrands[brand.id ?? -1] != nil))
        if let media = brand.media, media.count > 0 {
            self.imgBrand.kf.setImage(with: URL(string: media[0].file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        }
    }
    
    func updateSelection(isChecked: Bool) {
         
        parentView.borderWidth = isChecked ? 3.0 : 1.0
    }
    
    @IBAction func checkBoxClicked(_ sender: Any) {
        self.delegate?.checkBoxTapped(cell: self)
    }
    
}
