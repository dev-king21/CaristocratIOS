//
//  VehicleImagesCell.swift
 import UIKit
import ImageSlideshow
import FaveButton
import EasyTipView

class VehicleImagesCell: UITableViewCell {
    var delegate: VechicleDetailCellsDelegate?
    @IBOutlet var heartButton: FaveButton?
    @IBOutlet var backButton: UIButton?
    @IBOutlet var shareButton: UIButton?
    @IBOutlet var addFavoriteButton: UIButton!
    @IBOutlet weak var featureSlideShow: ImageSlideshow!
    var vehicleDetail: VehicleBase?
    var isForReview = false
    
    var isForTrade = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        heartButton?.delegate = self
        featureSlideShow.contentScaleMode = .scaleToFill
        
        //self.isAlreadyView()
        
    }
    
    func hideControls() {
        addFavoriteButton?.isHidden = isForTrade
        heartButton?.isHidden = isForTrade
        shareButton?.isHidden = isForTrade
    }
    
    func setData(vehicleDetail: VehicleBase) {
        self.vehicleDetail = vehicleDetail
        self.loadVehicleImages(vehicleDetail: vehicleDetail)
        
        if isForReview {
            heartButton?.delegate = self
            heartButton?.isHidden = false
            addFavoriteButton?.isHidden = true
            shareButton?.isHidden = false
            
            if vehicleDetail.is_liked != heartButton?.isSelected {
                heartButton?.isSelected = vehicleDetail.is_liked ?? false
            }
        } else {
            heartButton?.isHidden = true
        }
        
    }
    
    func isAlreadyView() {
        //if !(vehicleDetail?.is_viewed ?? false) {
            submitInteraction(type: .View)
       // }
    }
    
    func submitInteraction(type: InteractionType) {
        APIManager.sharedInstance.carInteraction(car_id: vehicleDetail?.id ?? 0,
                                                 interactionType: type,
                                                 success: { (result) in
            self.delegate?.didDataUpdate()
            if type == .Favorite {
               Utility.showSuccessWith(message: self.vehicleDetail?.is_favorite ?? false ? "Removed from favourites" : "Added to favourites" )
            }
        }) { (error) in
            
        }
    }
    
    var tipView: EasyTipView?
    func showToolTip() {
        if tipView == nil {
            self.alpha = 0.8
            var preferences = EasyTipView.Preferences()
            preferences.drawing.foregroundColor = UIColor.black
            preferences.drawing.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
            
            tipView = EasyTipView(text: vehicleDetail?.is_favorite ?? false ? "Remove from favourites" : "Add to favourites", preferences: preferences, delegate: self)
            
            tipView?.show(forView: self.addFavoriteButton, withinSuperview: self)
        }
    }
    
    func dismissToolTip() {
        if let tipView = tipView {
            self.alpha = 1
            tipView.dismiss()
            self.tipView = nil
        }
    }

    func loadVehicleImages(vehicleDetail: VehicleBase) {
        var images: [KingfisherSource] = []
        if let media = vehicleDetail.media {
            for item in media {
                if let url = item.file_url {
                    if let source = KingfisherSource(urlString: url,placeholder: UIImage(named: "carplaceholder"), options: nil) {
                        images.append(source)
                    }
                }
            }
        }
        featureSlideShow.contentScaleMode = .scaleAspectFill
        featureSlideShow.setImageInputs(images)
    }
    
    @IBAction func tappedOnBack() {
        self.dismissToolTip()
        delegate?.didTapOnBack()
    }
    
    @IBAction func tappedOnShare() {
        delegate?.didTapOnShare()
    }
    
    @IBAction func tappedOnFav(_ sender: Any) {
        if !AppStateManager.sharedInstance.isUserLoggedIn() {
            AlertViewController.showAlert(title: "Require Signin", description: "This action requires a user signin. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                Utility().topViewController()?.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
            return
        }
        self.showToolTip()
    }
    
}

extension VehicleImagesCell: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        if self.vehicleDetail?.is_favorite ?? false {
            self.vehicleDetail?.is_favorite = false
        } else {
            self.vehicleDetail?.is_favorite = true
        }
        self.submitInteraction(type: .Like)
        
    }
}

extension VehicleImagesCell: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        self.submitInteraction(type: .Favorite)
        dismissToolTip()
    }
}
