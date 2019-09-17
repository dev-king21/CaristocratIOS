//
//  ModelCell.swift
 import UIKit

protocol ModelCellDelegate : class {
    func checkBoxTapped(cell:ModelCell)
}

class ModelCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    weak var delegate:ModelCellDelegate?
    
    var isChecked: Bool = false {
        didSet {
            //parentView.backgroundColor = isChecked ? UIColor.black : UIColor.white
            //lblName.textColor = isChecked ? UIColor.white : UIColor.black
            btnCheckBox.isSelected = isChecked
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            parentView.backgroundColor = UIColor.white
        lblName.textColor = UIColor.black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
//    func updateSelection(isSelected: Bool) {
//        isChecked = isSelected
//    }
    
    func setData(carModel: CarModel) {
        
       lblName.text = carModel.name ?? ""
        printForced(AppStateManager.sharedInstance.filterOptions?.selectedModels)
       isChecked = AppStateManager.sharedInstance.filterOptions?.selectedModels[carModel.id ?? -1] != nil
        
    }

    
    @IBAction func checkBoxClicked(_ sender: Any) {
        self.delegate?.checkBoxTapped(cell: self)
    }
}
