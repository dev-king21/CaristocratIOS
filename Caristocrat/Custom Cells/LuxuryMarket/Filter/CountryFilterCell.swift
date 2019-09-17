//
//  BrandFilterCell.swift
 import UIKit

class CountryFilterCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var selectedCountries: UILabel!

    var delegate: FilterControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapOnParent)))
    }
  
    func displaySelectedCountries() {
        var countries: String = ""
        if let selectedCountries = AppStateManager.sharedInstance.filterOptions?.selectedCountries {
            for (_, value) in selectedCountries {
                countries += value + ", "
            }
        }
        
        selectedCountries.text = countries.isEmpty ? "Select Countries" : countries.dropLast().dropLast().description
    }
    
    func setData() {
        self.displaySelectedCountries()
    }
    
    @objc func didTapOnParent() {
        delegate?.didTapOnCountrySelection()
    }
    
}
