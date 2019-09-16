//
//  CompareResultCarAttributes.swift
 import UIKit
import SpreadsheetView

class CompareResultCarAttributesCell: Cell {
    
    @IBOutlet weak var lblName: MarqueeLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

