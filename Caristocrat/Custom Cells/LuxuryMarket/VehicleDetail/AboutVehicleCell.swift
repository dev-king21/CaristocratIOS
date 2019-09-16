//
//  AboutVehicleCell.swift
 import UIKit
import Cosmos

class AboutVehicleCell: UITableViewCell {
    var delegate: VechicleDetailCellsDelegate?
    
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblKMAndYear: UILabel!
    var slug = ""
    @IBOutlet weak var leftSidePriceBView: UIStackView!
    @IBOutlet weak var lblLeftPrice: UILabel!
    @IBOutlet weak var lblStartingFrom: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var avarageRatingLabel: UILabel!
    @IBOutlet weak var ratingParentView: UIStackView!
    
    var forTrade = false
    var myTradeIns: MyTradeIns?
    var forReview = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func tappedOnCell() {
        if forTrade {
            let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
            vehicleController.carId = myTradeIns?.my_car?.id ?? -1
            vehicleController.vehicleDetail = myTradeIns?.my_car
            vehicleController.slug = myTradeIns?.my_car?.category?.slug ?? ""
            Utility().topViewController()?.navigationController?.pushViewController(vehicleController, animated: true)
        }
     }


    func setData(vehicleDetail: VehicleBase ,myTradeIn: MyTradeIns?, forEvaluation: Bool = false) {
        let model = vehicleDetail.car_model?.name ?? ""
        let brand = vehicleDetail.car_model?.brand?.name ?? ""
        var carName = vehicleDetail.name ?? ""
        var carDetail = vehicleDetail
        
        if let myTradeIn = myTradeIn, let detail = myTradeIn.my_car {
            forTrade = true
            self.myTradeIns = myTradeIn
            carDetail = detail
            carName = carDetail.name ?? ""
        }

        lblCarName.text = forEvaluation ? brand + " " + model : carName
        let year = "\(carDetail.year ?? 0)"
        var km = ""
        if let _ = carDetail.kilometer{
            km = " - \(carDetail.kilometer ?? 0) KM"
        }
        
        var chassis = ""
        
        if(carDetail.chassis != nil){
            if(carDetail.chassis!.count > 0){
            chassis = " - Chassis \(carDetail.chassis ?? "")"
            }else{
              chassis = ""
            }
        }else{
          chassis = ""
        }
        
//        if(carDetail.chassis == ""){
//          chassis = " - Chassis \(carDetail.chassis ?? "")"
//        }
        
        //lblYear.text = "\(vehicleDetail.year ?? 0) - Chassis \(vehicleDetail.chassis ?? "")"
        lblYear.text = year + km + chassis
        lblCarName.font = UIFont(name: FontsType.Medium.rawValue, size: 17)
        
        if forReview {
            ratingView.rating = Double(vehicleDetail.average_rating ?? 0)
            avarageRatingLabel.text = "\(vehicleDetail.average_rating ?? 0)"
            ratingParentView.isHidden = false
        } else {
            ratingParentView.isHidden = true
        }
       
        if slug == Slugs.LUXURY_MARKET.rawValue {
            
            lblYear.text = "\(vehicleDetail.year ?? 0)"
            leftSidePriceBView.isHidden = self.forReview
            lblLeftPrice.text = "\(vehicleDetail.currency ?? "") " + "\((vehicleDetail.amount?.withCommas() ?? ""))"
            lblLeftPrice.font = UIFont(name: FontsType.Medium.rawValue, size: 17)
            self.lblStartingFrom.text = "Starting From"
        }
//        else if slug == Slugs.THE_OUTLET_MALL.rawValue {
//            lblYear.text = "\(vehicleDetail.year ?? 0)"
//            lblPrice.text = "AED \((vehicleDetail.amount?.withCommas() ?? ""))"
//        }
        else if slug == Slugs.APPROVED_PRE_OWNED.rawValue  || slug == Slugs.CLASSIC_CARS.rawValue || slug == Slugs.THE_OUTLET_MALL.rawValue {
            lblYear.isHidden = true
            if  slug == Slugs.THE_OUTLET_MALL.rawValue {
                lblPrice.text =  "\(vehicleDetail.currency ?? "AED ") " + "\((vehicleDetail.amount?.withCommas() ?? ""))"
            } else {
                lblPrice.text =  "\(vehicleDetail.currency ?? "AED ") " + "\((vehicleDetail.amount?.withCommas() ?? ""))"
//                lblPrice.text = "\(vehicleDetail.currency ?? "") " + " \((vehicleDetail.average_mkp?.withCommas() ?? ""))"
            }
            lblPrice.font = UIFont(name: FontsType.Medium.rawValue, size: 17)
            lblCarName.font = UIFont(name: FontsType.Medium.rawValue, size: 17)
            

            var kmAndYear = ""
            kmAndYear += (vehicleDetail.year ?? 0).description
            if slug != Slugs.THE_OUTLET_MALL.rawValue {
                if let km = vehicleDetail.kilometer?.withCommas() {
                    kmAndYear += " - "+km + " KM"
                }
            }
            lblKMAndYear.text = kmAndYear
        }
        else {
           self.lblStartingFrom.text = ""
           self.lblLeftPrice.text = ""
        }
        

      }
}
