//
//  BodyStyleItemCell.swift
 import UIKit

class BodyStyleItemCell: UICollectionViewCell {
    
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageParentView: UIView!
    var bodyStyle: BodyStyleModel?
    
    var isChecked: Bool = false {
        didSet {
            imageParentView.backgroundColor = isChecked ? UIColor.black : UIColor.white
            if let bodyStyle = bodyStyle{
                self.bodyImage.kf.setImage(with: URL(string: isChecked ? bodyStyle.selected_icon.unWrap : bodyStyle.un_selected_icon.unWrap), placeholder: #imageLiteral(resourceName: "image_placeholder"))
//                bodyImage.image = UIImage(named: "\(id.description)-\(isChecked ? "selected" : "unselected")")
            }
        }
    }
    
    func setData(bodyStyle: BodyStyleModel) {
        self.updateSelection(isChecked: bodyStyle.isChecked)
        self.bodyStyle = bodyStyle
        titleLabel.text = bodyStyle.name
        self.bodyImage.kf.setImage(with: URL(string: isChecked ? bodyStyle.selected_icon.unWrap : bodyStyle.un_selected_icon.unWrap), placeholder: #imageLiteral(resourceName: "image_placeholder"))
//        bodyImage.image = UIImage(named: "\(bodyStyle.id?.description ?? "1")-\(isChecked ? "selected" : "unselected")")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
    }
    
    func updateSelection(isChecked: Bool) {
       self.isChecked = isChecked
    }
    


}
