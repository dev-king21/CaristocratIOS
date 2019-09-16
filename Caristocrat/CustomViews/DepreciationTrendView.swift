//
//  DepreciationTrendView.swift
 import Foundation

class DepreciationTrendView: UIView {
    
    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var lblYear: MarqueeLabel!
    @IBOutlet weak var lblAmount: MarqueeLabel!
    @IBOutlet weak var parentView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(vehicleDetail: VehicleBase,depreciationTrend: Depreciation_trend_value) {
        lblYear.text = depreciationTrend.year_title ?? ""
        lblAmount.text = ("\(vehicleDetail.currency ?? "") " + (Int(depreciationTrend.amount ?? 0).withCommas().description)).description
        lblAmount.restartLabel()
        lblYear.restartLabel()
    }
    
    
    
}
