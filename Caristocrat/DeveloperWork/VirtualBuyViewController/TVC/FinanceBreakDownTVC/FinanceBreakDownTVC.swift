//
//  FinanceBreakDownTVC.swift
 import UIKit

struct FinanceBreakDownValues{
    var carPrice = "0"
    var downPayment = "0"
    var monthlyInstallment = "0"
    var unit = "AED"
}

class FinanceBreakDownTVC: UITableViewCell {

    @IBOutlet weak var lblCarPrice: UILabel!
    @IBOutlet weak var lblDownPayment: UILabel!
    @IBOutlet weak var lblMonthlyInstallment: UILabel!
    
    func setData(vehicleDetail: VehicleBase?,data:FinanceBreakDownValues){
        let currency = (vehicleDetail?.currency ?? "AED") + " "
        self.lblCarPrice.text = "\(currency)" + " " + Utility.commaSeparatedNumber(number: data.carPrice)
        self.lblDownPayment.text = "\(currency)" + " " + Utility.commaSeparatedNumber(number: data.downPayment)
        print(data.monthlyInstallment)
        self.lblMonthlyInstallment.text = "\(currency)" + " " + Utility.commaSeparatedNumber(number:data.monthlyInstallment)
        print(self.lblMonthlyInstallment.text)
    }
}
