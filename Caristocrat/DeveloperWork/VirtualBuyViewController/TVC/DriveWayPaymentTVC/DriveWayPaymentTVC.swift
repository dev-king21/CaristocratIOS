//
//  FinanceBreakDownTVC.swift
 import UIKit

struct DriveWayPaymentValues{
    var downPayment = "0"
    var insurance = "0"
    var registrationFee = "0"
    var totalUpfrontPayment = "0"
    var unit = "AED"
}

class DriveWayPaymentTVC: UITableViewCell {
    
    @IBOutlet weak var lblTitleDownPayment: UILabel!
    @IBOutlet weak var lblDownPayment: UILabel!
    @IBOutlet weak var lblInsurance: UILabel!
    @IBOutlet weak var lblRegistrationFee: UILabel!
    @IBOutlet weak var lblTotalUpfrontPayment: UILabel!
    
    func setData(vehicleDetail: VehicleBase?,data:DriveWayPaymentValues,virtualBuyBy:VirtualBuyBy){
        let currency = (vehicleDetail?.currency ?? "AED") + " "

        switch virtualBuyBy {
        case .financeBuy:
            self.lblTitleDownPayment.text = "Down Payment"
        case .cashBuy:
            self.lblTitleDownPayment.text = "Total Car Price"
        }
        self.lblDownPayment.text = "\(currency)" + Utility.commaSeparatedNumber(number: data.downPayment)
        self.lblInsurance.text = "\(currency)" +  Utility.commaSeparatedNumber(number: data.insurance)
        self.lblRegistrationFee.text = "\(currency)" +  Utility.commaSeparatedNumber(number: data.registrationFee)
        self.lblTotalUpfrontPayment.text = "\(currency)" +  Utility.commaSeparatedNumber(number: data.totalUpfrontPayment)
    }
    
}
