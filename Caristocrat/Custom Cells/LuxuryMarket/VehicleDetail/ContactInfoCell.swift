//
//  ContactInfoCell.swift
 import UIKit

class ContactInfoCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var vehicleDetail: VehicleBase?
    var showroom_details: Showroom_details?
    
    override func awakeFromNib() {
      super.awakeFromNib()
        
        
    }
    
    func setData(vehicleDetail: VehicleBase) {
       self.vehicleDetail = vehicleDetail
       lblName.text = vehicleDetail.owner?.showroom_details?.name ?? ""
       labelAddress.text = vehicleDetail.owner?.showroom_details?.address ?? ""
       self.imgLogo.kf.setImage(with: URL(string: vehicleDetail.owner?.showroom_details?.logo_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
    }
    
    func setData(showroom_details: Showroom_details?) {
        self.showroom_details = showroom_details
        lblName.text = showroom_details?.name ?? ""
        labelAddress.text = showroom_details?.address ?? ""
        self.imgLogo.kf.setImage(with: URL(string: showroom_details?.logo_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
    }
    
    @IBAction func tappedOnCall() {
        self.makeCall()
    }
    
    func makeCall() {
        var phoneNumber: String?
        var titleText: String?

        if let showroom_details = showroom_details {
            phoneNumber = showroom_details.phone ?? ""
            titleText = showroom_details.name ?? ""
        }
        let callViewController = CallViewController.instantiate(fromAppStoryboard: .Popups)
        callViewController.titleText = "Would you like to call " + (titleText ?? (self.vehicleDetail?.owner?.showroom_details?.name ?? ""))
        callViewController.phoneNumber = phoneNumber ?? (vehicleDetail?.owner?.showroom_details?.phone ?? "")
        callViewController.carId = vehicleDetail?.id ?? 0
        callViewController.modalPresentationStyle = .overCurrentContext
        callViewController.modalTransitionStyle = .crossDissolve
        Utility().topViewController()?.present(callViewController, animated: true, completion: nil)
    }
}
