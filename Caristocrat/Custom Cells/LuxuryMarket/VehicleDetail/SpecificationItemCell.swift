//
//  SpecificationItemCell.swift
 import UIKit

class SpecificationItemCell: UICollectionViewCell {

    @IBOutlet weak var lblName: MarqueeLabel?
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var specsImage: UIImageView?
    @IBOutlet weak var specsImageWidth: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(carAttributes: MyCarAttributes) {
        specsImage?.kf.setImage(with: URL(string: carAttributes.attr_icon ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        var attributeName = carAttributes.attr_name?.uppercased() ?? ""
        attributeName = attributeName.replacingOccurrences(of: "_", with: " ")
        lblName?.text = attributeName
        
        if let option = carAttributes.attr_option {
            self.lblDesc.text = option.uppercased()
        } else {
            self.lblDesc.text = carAttributes.value?.uppercased() ?? ""
        }
        
//        let key = carAttributes.attr_id ?? 0
//        switch key {
//        case CarAttributeType.InteriorColor.rawValue:
//            lblDesc.text = carAttributes.attr_option ?? ""
//        case CarAttributeType.ExteriorColor.rawValue:
//            self.lblDesc.text = carAttributes.attr_option
//        case CarAttributeType.Accident.rawValue:
//            self.lblDesc.text = carAttributes.attr_option
//        case CarAttributeType.Trim.rawValue:
//            self.lblDesc.text = carAttributes.value
//        case CarAttributeType.WarrantyRemaining.rawValue:
//            self.lblDesc.text = carAttributes.value
//        case CarAttributeType.ServiceContract.rawValue:
//            self.lblDesc.text = carAttributes.value
//        default:
//            break
//        }
        
    }
    
    func setData(specs: Specs) {
       self.lblName?.text = specs.name ?? ""
       self.lblDesc?.text = (specs.value ?? "") + " " + (Constants.Units[(specs.name ?? "")] ?? "")
       self.specsImageWidth?.constant = 0
    }

}
