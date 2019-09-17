//
//  AddCompareVehicleCell.swift
 import UIKit

class AddCompareVehicleCell: UICollectionViewCell {
    
    var delegate: CompareVehicleDelegates?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func tappedOnAdd() {
        delegate?.addAnotherCar()
    }

}
