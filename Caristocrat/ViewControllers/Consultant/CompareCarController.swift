//
//  CompareCarController.swift
 import UIKit
import DZNEmptyDataSet

protocol CompareCarDelegates {
    func didCarSelected(vehicleDetail: VehicleBase)
}

class CompareCarController: BaseViewController {

    var selectedTab = SelectTab.CompareAnyCar
    @IBOutlet weak var compareBySegmentView: UIView!
    @IBOutlet weak var compareCarTabView: UIView!
    @IBOutlet weak var compareSegmentTabView: UIView!
    @IBOutlet weak var compaCarLabel: UILabel!
    @IBOutlet weak var compareSegmentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchTab(selectedTab: selectedTab)
    }
    
    func customizeApperence() {
        
    }
    
    @IBAction func compareCarTapped() {
        switchTab(selectedTab: .CompareAnyCar)
    }
    
    @IBAction func compareSegmentTapped() {
        switchTab(selectedTab: .CompareSegmentWise)
    }
    
    func switchTab(selectedTab: SelectTab) {
        self.selectedTab = selectedTab
        if selectedTab == .CompareAnyCar {
            compareCarTabView.backgroundColor = .black
            compaCarLabel.textColor = .white
            compareSegmentTabView.backgroundColor = .white
            compareSegmentLabel.textColor = .black
            compareBySegmentView.isHidden = true
        } else {
            compareCarTabView.backgroundColor = .white
            compaCarLabel.textColor = .black
            compareSegmentTabView.backgroundColor = .black
            compareSegmentLabel.textColor = .white
            compareBySegmentView.isHidden = false
        }
    }

    enum SelectTab {
        case CompareAnyCar
        case CompareSegmentWise
    }
}

