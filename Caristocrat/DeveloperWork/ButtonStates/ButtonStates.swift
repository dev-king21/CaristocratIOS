//
//  File.swift
 import Foundation
import UIKit


class ButtonStates: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isSelected{
            self.backgroundColor = .black
            self.setTitleColor(.white, for: .selected)
        }
        else{
            self.backgroundColor = .white
            self.setTitleColor(.darkGray, for: .normal)
        }
    }
}
