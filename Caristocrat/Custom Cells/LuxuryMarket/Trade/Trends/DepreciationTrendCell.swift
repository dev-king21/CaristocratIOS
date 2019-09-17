//
//  DepreciationTrendCell.swift
 import UIKit

class DepreciationTrendCell: UITableViewCell {

    @IBOutlet weak var lifeCycleProgress: NSLayoutConstraint!
    @IBOutlet weak var depreciationViews: UIStackView!
    @IBOutlet weak var parcentView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(vehicleDetail: VehicleBase,trendValue: [Depreciation_trend_value]) {
        depreciationViews.subviews.map({ $0.removeFromSuperview() })
        parcentView.subviews.map({ $0.removeFromSuperview() })

        for (index,item) in trendValue.enumerated() {
            let depreciationTrendView: DepreciationTrendView = DepreciationTrendView.fromNib()
            depreciationTrendView.setData(vehicleDetail: vehicleDetail, depreciationTrend: item)
            let percentLabel: UILabel = UILabel.init()
            percentLabel.text = "\(item.percent ?? 0)%"
            percentLabel.font = percentLabel.font.withSize(9)
            
            if index == 0 {
                depreciationTrendView.parentView.alignment = .leading
                percentLabel.textAlignment = .left
            } else if index == trendValue.count - 1 {
                depreciationTrendView.parentView.alignment = .trailing
                percentLabel.textAlignment = .right
            } else {
                depreciationTrendView.parentView.alignment = .center
                percentLabel.textAlignment = .center
            }
            
            parcentView.addArrangedSubview(percentLabel)
            depreciationViews.addArrangedSubview(depreciationTrendView)
        }
     
        
        let currentDate = Calendar.current.dateComponents([.year,.month], from: Date())
        let currentYear = currentDate.year ?? 0
        let currentMonth = currentDate.month ?? 0
        
        let startYear = trendValue.first?.year ?? 0
        
        if trendValue.count >= 4 {
            let endYear = trendValue[4].year ?? 0
            
            if  currentYear > endYear {
                lifeCycleProgress = lifeCycleProgress.setMultiplier(multiplier: CGFloat(100))
            } else {
                let percentPerYear = 100 / CGFloat(endYear - startYear)
                let percentPerMonth = percentPerYear / 12
                var totalYear = currentYear - startYear
                var totalPercent = CGFloat(totalYear) * percentPerYear
                totalPercent += (percentPerMonth * CGFloat(currentMonth))
                lifeCycleProgress = lifeCycleProgress.setMultiplier(multiplier: CGFloat(totalPercent / 100))
            }
        }
    }
}
