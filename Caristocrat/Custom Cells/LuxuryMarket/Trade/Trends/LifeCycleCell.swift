//
//  LifeCycleCell.swift
 import UIKit

class LifeCycleCell: UITableViewCell {

    @IBOutlet weak var lblYearStart: UILabel!
    @IBOutlet weak var lblYearEnd: UILabel!
    @IBOutlet weak var lifeCycleProgress: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    func setData(vehicleDetail: VehicleBase) {
        if let lifeCycle = vehicleDetail.life_cycle {
            let years = lifeCycle.components(separatedBy: "-")
            
            let currentDate = Calendar.current.dateComponents([.year,.month], from: Date())
            let currentYear = currentDate.year ?? 0
            let currentMonth = currentDate.month ?? 0

            let startYear = Int(years[0]) ?? 0
            let endYear = Int(years[1]) ?? 0

            if  currentYear > endYear {
                lifeCycleProgress = lifeCycleProgress.setMultiplier(multiplier: CGFloat(100))
            } else {
                let  percentPerYear =  100 / (CGFloat(endYear - startYear < 1 ? 0 : endYear - startYear) + 1)
                let percentPerMonth = percentPerYear / 12
                let totalYear = currentYear - startYear
                var totalPercent = CGFloat(totalYear) * percentPerYear
                totalPercent += (percentPerMonth * CGFloat(currentMonth))
                lifeCycleProgress = lifeCycleProgress.setMultiplier(multiplier: CGFloat(totalPercent == 0 ? 1 : totalPercent / 100))
            }
            lblYearStart.text = years[0]
            lblYearEnd.text = years[1]
        }
    }
    
    
    
}
