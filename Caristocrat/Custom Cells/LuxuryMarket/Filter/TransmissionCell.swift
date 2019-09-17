//
//  TransmissionCell.swift
 import UIKit

class TransmissionCell: UITableViewCell {
    
    @IBOutlet weak var AutomaticTabView:UIView!
    @IBOutlet weak var manualTabView:UIView!
    @IBOutlet weak var AutomaticTabLabel:UILabel!
    @IBOutlet weak var manualTabLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        AutomaticTabView.isUserInteractionEnabled = true
        manualTabView.isUserInteractionEnabled = true

        AutomaticTabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.AutomaticTapped(sender:))))
        manualTabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.manualTapped(sender:))))
    }
    
    func selectTab() {
        switchTab(selectedTab: SelectTab.init(rawValue: AppStateManager.sharedInstance.filterOptions?.transmission_type ?? 20)!)
    }
    
    @objc func AutomaticTapped(sender: AnyObject) {
        switchTab(selectedTab: .Automatic)
    }
    
    @objc func manualTapped(sender: AnyObject) {
        switchTab(selectedTab: .Manual)
    }
    
    
    private func switchTab(selectedTab: SelectTab) {
        if selectedTab == .Automatic {
            AutomaticTabView.backgroundColor = .black
            AutomaticTabLabel.textColor = .white
            manualTabView.backgroundColor = .white
            manualTabLabel.textColor = .black
        } else {
            AutomaticTabView.backgroundColor = .white
            AutomaticTabLabel.textColor = .black
            manualTabView.backgroundColor = .black
            manualTabLabel.textColor = .white
        }
        
        AppStateManager.sharedInstance.filterOptions?.transmission_type = selectedTab.rawValue
    }
    
    enum SelectTab : Int {
        case Automatic = 20
        case Manual = 10
    }
    
}
