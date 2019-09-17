//
//  SortModesView.swift
 import Foundation
class VehicleSortModesView: UIView {
    
    var lastSelected: UIButton?
    @IBOutlet weak var newToOldButton: UIButton?
    var delegate: SortModesDelegates?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let sortModesView = UINib(nibName: "VehicleSortModesView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        sortModesView.frame = self.bounds
        
        addSubview(sortModesView)
        
        newToOldButton?.isSelected = true
        lastSelected = newToOldButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func tappedOnSortMode(_ sender: UIButton) {
        if let button = self.lastSelected {
            button.isSelected = false
        }
        sender.isSelected = !sender.isSelected
        self.lastSelected = sender
        
        delegate?.didChangeMode(sortMode: VehicleSortModes(rawValue: lastSelected?.tag ?? VehicleSortModes.NewestToOldest.rawValue) ?? VehicleSortModes.NewestToOldest)
    }
}
