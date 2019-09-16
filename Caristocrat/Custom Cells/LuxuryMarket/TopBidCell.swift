//
//  TopBidsCell.swift
 import UIKit

class TopBidCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var offerNumberLabel: UILabel!

    var evaluationDetails: Evaluation_details?
    var carId: Int?
    var offerDetail: OfferDetails?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(carId: Int,evaluationDetails: Evaluation_details) {
        self.evaluationDetails = evaluationDetails
        self.carId = carId
        
        self.lblName.text = evaluationDetails.user?.showroom_details?.name ?? ""
        if let amount = evaluationDetails.amount, amount > 0 {
            let boldAmount =  "\(evaluationDetails.currency ?? "") " + "\((amount).withCommas())"
            self.labelAddress.text = "Offered Price \(boldAmount)"
            self.labelAddress.HighlightText = boldAmount
        } else {
            self.labelAddress.text = "Waiting for offer"
        }

        self.imgLogo.kf.setImage(with: URL(string: evaluationDetails.user?.showroom_details?.logo_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
       
    }
    
    func setData(carId: Int, offerDetail: OfferDetails, isExpired: Bool) {
        self.offerDetail = offerDetail
        self.carId = carId
        
        self.lblName.text = offerDetail.user?.showroom_details?.name ?? ""
        if let amount = offerDetail.amount, amount > 0.0 {
            let boldAmount =  "\(offerDetail.currency ?? "") " + "\((amount).withCommas())"
            self.labelAddress.text = "Offered Price \(boldAmount)"
            self.labelAddress.HighlightText = boldAmount
        } else {
            self.labelAddress.text = isExpired ? "No Offer available" : "Waiting for offer"
        }
        
        self.imgLogo.kf.setImage(with: URL(string: offerDetail.user?.showroom_details?.logo_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        
    }
    
    @IBAction func tappedOnCall() {
        self.makeCall()
    }

    func makeCall() {
        let callViewController = CallViewController.instantiate(fromAppStoryboard: .Popups)
        callViewController.carId = self.carId.unWrap
        callViewController.titleText = "Call "+(self.offerDetail?.user?.showroom_details?.name ?? "")
        callViewController.phoneNumber = (self.offerDetail?.user?.showroom_details?.phone ?? "").description
        callViewController.modalPresentationStyle = .overCurrentContext
        callViewController.modalTransitionStyle = .crossDissolve
        Utility().topViewController()?.present(callViewController, animated: true, completion: nil)
    }
}
