//
//  RegionsItemCells.swift
 import UIKit

class RegionsItemCells: UICollectionViewCell {

    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var lblRegionName: UILabel!
    @IBOutlet weak var lblPrice: MarqueeLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(region: Car_regions) {
        self.imageFlag.kf.setImage(with: URL(string: region.region?.flag ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        self.lblRegionName.text = region.region?.name ?? ""
        self.lblPrice.text = "\(region.region?.currency ?? "") "+(region.price ?? 0).withCommas().description
        self.lblPrice.restartLabel()
    }

}
