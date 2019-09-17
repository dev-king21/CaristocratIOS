//
//  HeaderCell.swift
 import UIKit
import SpreadsheetView

class HeaderCell: Cell {
    
    @IBOutlet weak var titleLabel: MarqueeLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(title: String) {
      titleLabel.text = " " + title + " "
      titleLabel.font = titleLabel.font.withSize(25)
    }
}
