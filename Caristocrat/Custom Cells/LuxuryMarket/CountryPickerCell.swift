//
//  CountryPickerCell.swift
 import UIKit

class CountryPickerCell: UICollectionViewCell {
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var tickImage: UIImageView!

    var isChecked: Bool = false {
        didSet {
            countryImage.borderWidth = isChecked ? 2.0 : 0.0
            tickImage.isHidden = !isChecked
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
   
    func setData(region: Region, isForFilter: Bool) {
        lblCountryName.text = region.name ?? ""
        self.isChecked = AppStateManager.sharedInstance.filterOptions?.selectedCountries[region.id ?? -1] != nil

//        if isForFilter {
//            self.isChecked = AppStateManager.sharedInstance.filterOptions?.selectedCountries[region.id ?? -1] != nil
//        } else {
//            self.isChecked = (region.is_my_region ?? 0).value()
//        }
        
        tickImage.isHidden = !self.isChecked
        countryImage.borderWidth = self.isChecked ? 2.0 : 0.0
        self.countryImage.kf.setImage(with: URL(string: region.flag ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
    }
    
    
    
}
