//
//  ContactInfoCell.swift
 import UIKit

class ContactInfoCell1: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
    
    var vehicleDetail: VehicleBase?
    var myTradeIns: MyTradeIns?
    
    func setData(vehicleDetail: VehicleBase) {
       self.vehicleDetail = vehicleDetail
       lblName.text = vehicleDetail.owner?.showroom_details?.name ?? ""
       labelAddress.text = vehicleDetail.owner?.showroom_details?.address ?? ""
       self.imgLogo.kf.setImage(with: URL(string: vehicleDetail.owner?.details?.image_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
    }
    
    func setData(isMyCar:Bool,vehicleDetail: VehicleBase, amount: Int, myTradeIns: MyTradeIns? = nil) {
        self.myTradeIns = myTradeIns
        self.vehicleDetail = vehicleDetail
        if isMyCar {
            self.lblName.text = vehicleDetail.owner?.name ?? ""
            let boldAmount =  "\(vehicleDetail.currency ?? "AED ") " + "\(amount.withCommas() == "0" ? "-" : amount.withCommas())"
            self.labelAddress.text = "Offered Price \(boldAmount)"
            self.labelAddress.HighlightText = boldAmount
            self.imgLogo.kf.setImage(with: URL(string: vehicleDetail.owner?.showroom_details?.logo_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            
            if let showroomDetails = myTradeIns?.dealer_info?.showroom_details {
                self.lblName.text = showroomDetails.name
                self.imgLogo.kf.setImage(with: URL(string: showroomDetails.logo_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            }
        }
        else {
            self.lblName.text = (vehicleDetail.car_model?.brand?.name ?? "") + " " + (vehicleDetail.car_model?.name ?? "")
            self.labelAddress.text = "Model \(vehicleDetail.car_model?.name ?? ""), Chassis \(vehicleDetail.chassis ?? "-")"
            self.imgLogo.kf.setImage(with: URL(string: vehicleDetail.media?.first?.file_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            self.btnPhone.isHidden = true
            self.btnPhone.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func tappedOnCall() {
        self.makeCall()
    }
    
    func makeCall() {
        let callViewController = CallViewController.instantiate(fromAppStoryboard: .Popups)
        callViewController.carId = vehicleDetail?.id ?? -1

        callViewController.titleText = "Would you like to call  "+(self.vehicleDetail?.owner?.showroom_details?.name ?? "")
        callViewController.phoneNumber = (vehicleDetail?.owner?.showroom_details?.phone ?? "").description

        if let dealerInfo = myTradeIns?.dealer_info {
            callViewController.phoneNumber = (myTradeIns?.dealer_info?.showroom_details?.phone ?? "").description
            callViewController.titleText = "Would you like to call  "+(dealerInfo.showroom_details?.name ?? "")
        }
        
        callViewController.modalPresentationStyle = .overCurrentContext
        callViewController.modalTransitionStyle = .crossDissolve
        Utility().topViewController()?.present(callViewController, animated: true, completion: nil)
    }
}
