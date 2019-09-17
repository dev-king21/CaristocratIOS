//
//  TransmissionCell.swift
 import UIKit

class DealerTypeCell: UITableViewCell {
    
    @IBOutlet weak var officialDealerTabView:UIView!
    @IBOutlet weak var marketDealerTabView:UIView!
    @IBOutlet weak var officialTabLabel:UILabel!
    @IBOutlet weak var marketTabTabLabel:UILabel!
    var selectedDealer: SelectTab = .None

    override func awakeFromNib() {
        super.awakeFromNib()
        officialDealerTabView.isUserInteractionEnabled = true
        marketDealerTabView.isUserInteractionEnabled = true

        officialDealerTabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.officialTapped(sender:))))
        marketDealerTabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.marketTapped(sender:))))
       
    }
    
    func setData() {
        if let dealerType = AppStateManager.sharedInstance.filterOptions?.dealer_type {
            switchTab(selectedTab: SelectTab(rawValue: dealerType) ?? .None)
        } else {
            switchTab(selectedTab: .None)
        }
    }
    
    func selectTab() {
        switchTab(selectedTab: SelectTab.init(rawValue: AppStateManager.sharedInstance.filterOptions?.dealer_type ?? SelectTab.None.rawValue)!)
    }
    
    @objc func officialTapped(sender: AnyObject) {
        switchTab(selectedTab: .OfficialDealer, clearFirst: true)
    }
    
    @objc func marketTapped(sender: AnyObject) {
        switchTab(selectedTab: .MarketDealer, clearFirst: true)
    }
    
    
    private func switchTab(selectedTab: SelectTab, clearFirst: Bool = false) {
        if clearFirst {
            officialDealerTabView.backgroundColor = .white
            officialTabLabel.textColor = .black
            marketDealerTabView.backgroundColor = .white
            marketTabTabLabel.textColor = .black
        }
        
        if selectedTab == .OfficialDealer && self.selectedDealer != selectedTab {
            self.selectedDealer = .OfficialDealer
            officialDealerTabView.backgroundColor = .black
            officialTabLabel.textColor = .white
            marketDealerTabView.backgroundColor = .white
            marketTabTabLabel.textColor = .black
        } else if selectedTab == .MarketDealer  && self.selectedDealer != selectedTab {
            self.selectedDealer = .MarketDealer
            officialDealerTabView.backgroundColor = .white
            officialTabLabel.textColor = .black
            marketDealerTabView.backgroundColor = .black
            marketTabTabLabel.textColor = .white
        } else if selectedTab == .None {
            self.selectedDealer = .None
            officialDealerTabView.backgroundColor = .white
            officialTabLabel.textColor = .black
            marketDealerTabView.backgroundColor = .white
            marketTabTabLabel.textColor = .black
        }
        
        AppStateManager.sharedInstance.filterOptions?.dealer_type = selectedDealer.rawValue
    }
    
    enum SelectTab : Int {
        case OfficialDealer = 10
        case MarketDealer = 20
        case None = 0
    }
    
}
