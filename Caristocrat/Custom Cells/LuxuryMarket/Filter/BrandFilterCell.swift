//
//  BrandFilterCell.swift
 import UIKit

class BrandFilterCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var selectedBrands: UILabel!

    var delegate: FilterControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapOnParent)))
    }
    
    func displaySelectedBrands() {
        var brands: String = ""
        if let keys = AppStateManager.sharedInstance.filterOptions?.selectedBrands {
            for (_, value) in keys {
                brands += value + ", "
            }
        }
        
        selectedBrands.text = brands.isEmpty ? "Select Make" : brands.dropLast().dropLast().description
    }
    
    func displaySelectedCarModels() {
        
        var models: String = ""
        
        let brand = (AppStateManager.sharedInstance.filterOptions?.selectedBrands.first?.value ?? "")
        
        if let keys = AppStateManager.sharedInstance.filterOptions?.selectedModels {
            for (_, value) in keys {
                models += (value.first?.key ?? "") + ", "
            }
        }
        
        if brand.isEmpty && models.isEmpty {
             selectedBrands.text = "Select Make"
        }else if models.isEmpty {
            selectedBrands.text = brand
        }else{
            selectedBrands.text = brand+","+models.dropLast().dropLast().description
        }
        
      //selectedBrands.text = models.isEmpty ? "Select Make" : brands.dropLast().dropLast().description
    }
    
    func setData() {
//        self.displaySelectedBrands()
        self.displaySelectedCarModels()
    }
    
    @objc func didTapOnParent() {
        delegate?.didTapOnAddBrand()
    }
    
}
