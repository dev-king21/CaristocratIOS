//
//  VersionCell.swift
 import UIKit

protocol VersionCellDelegate : class {
    func checkBoxTapped(cell:VersionCell)
}

class VersionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    weak var delegate:VersionCellDelegate?
    
    var isChecked: Bool = false {
        didSet {
//            parentView.backgroundColor = isChecked ? UIColor.black : UIColor.white
//            lblName.textColor = isChecked ? UIColor.white : UIColor.black
            btnCheckBox.isSelected = isChecked
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.backgroundColor = isChecked ? UIColor.black : UIColor.white
        lblName.textColor = isChecked ? UIColor.white : UIColor.black
    }
    
    func setData(versionModel: VersionModel,modelId:Int) {
        lblName.text = versionModel.name ?? ""
       
        if (AppStateManager.sharedInstance.filterOptions?.selectedAllVersion.contains(modelId))! {
            if versionModel.id != -1 {
                isChecked = AppStateManager.sharedInstance.filterOptions?.selectedVersions[versionModel.id ?? -1] != nil
            }else{
                isChecked = true
            }
            
        }else{
            if versionModel.id != -1 {
                isChecked = AppStateManager.sharedInstance.filterOptions?.selectedVersions[versionModel.id ?? -1] != nil
            }else{
                isChecked = false
            }
        }
        
        
    }
    
    @IBAction func checkBoxClicked(_ sender: Any) {
        self.delegate?.checkBoxTapped(cell: self)
    }

}
