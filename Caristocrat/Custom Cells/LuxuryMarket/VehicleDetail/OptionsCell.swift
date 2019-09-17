//
//  OptionsCell.swift
 import UIKit

class OptionsCell: UIView {

    @IBOutlet weak var tradeInView: UIView!
    @IBOutlet weak var requestConsultancyView: UIView!
    
    @IBOutlet weak var virtualBuyView: UIView!
    var delegate: VechicleDetailCellsDelegate?
    var vehicleDetail: VehicleBase?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tradeInView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnTradeIn)))
        requestConsultancyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnResultConsultancy)))
        virtualBuyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnVirtualBuy)))

    }
    
    func setData(vehicleDetail: VehicleBase) {
        self.vehicleDetail = vehicleDetail
        
        if(self.vehicleDetail?.category?.id == Constants.LUXURY_MARKET_CATEGORY_ID){
            
            if  let dealers = self.vehicleDetail?.dealers, dealers.count > 0 {
                tradeInView.alpha = 1
                tradeInView.isUserInteractionEnabled = true
            } else {
                tradeInView.alpha = 0.5
                tradeInView.isUserInteractionEnabled = false
            }
        }
    
    }
    
    @objc func tappedOnTradeIn() {
        delegate?.didTapOnTrade()
    }
    
    @objc func tappedOnResultConsultancy() {
//      let requestConsultancy = RequestConsultancyController.instantiate(fromAppStoryboard: .Popups)
//      requestConsultancy.modalPresentationStyle = .overCurrentContext
//      requestConsultancy.modalTransitionStyle = .crossDissolve
//      requestConsultancy.vehicleDetail = self.vehicleDetail
//      Utility().topViewController()?.present(requestConsultancy, animated: true, completion: nil)
        delegate?.didTapOnPersonalShopper()
    }
    
    @objc func tappedOnReport() {
        let reportListingController = ReportListingController.instantiate(fromAppStoryboard: .Popups)
        reportListingController.modalPresentationStyle = .overCurrentContext
        reportListingController.modalTransitionStyle = .crossDissolve
        reportListingController.carId = self.vehicleDetail?.id ?? 0
        Utility().topViewController()?.present(reportListingController, animated: true, completion: nil)
    }
    
    @objc func tappedOnVirtualBuy() {
//        Utility.showInformationWith(message: Messages.ImplementLater.rawValue)
        delegate?.didTapOnVirtualBuy()

    }
  
}
