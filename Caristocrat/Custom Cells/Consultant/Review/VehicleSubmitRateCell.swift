//
//  VehicleRateCell.swift
 import UIKit
import Cosmos

class VehicleSubmitRateCell: UITableViewCell {
    
    @IBOutlet weak var reviewTextView: CustomUITextView!
    @IBOutlet weak var alreadySubmittedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitReviewButton: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var rateFields: [RateFieldsModel] = []
    var ownRating: [ReviewRatingModel] = []
    var cells: [CellWithoutHeight] = [(VehicleSubmitRateItemCell.identifier,1)]
    var carId: Int?
    var delegate: VechicleDetailCellsDelegate?
    var populateOwnRating = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.prepareTableview()
    }
    
    func setData(carId: Int,rateFields: [RateFieldsModel]) {
       self.carId = carId
       self.rateFields = rateFields
        
       self.adjustTableViewHeight()
    }
    
    func setRating(reviewsDetail: ReviewModel) {
        self.populateOwnRating = true
        self.ownRating = reviewsDetail.details ?? []
        alreadySubmittedLabel.isHidden = false
        submitReviewButton.isHidden = true
        submitReviewButton.isUserInteractionEnabled = false
        reviewTextView.text = reviewsDetail.review_message ?? ""
        reviewTextView.isEditable = false
        reviewTextView.isSelectable = false
        self.adjustTableViewHeight()
    }

    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func adjustTableViewHeight() {
        self.tableViewHeight.constant = CGFloat(VehicleSubmitRateItemCell.cellHeight * (populateOwnRating ? ownRating.count : rateFields.count ))
        self.tableView.reloadData()
    }
    
    @IBAction func tappedOnSubmitButton() {
        if !AppStateManager.sharedInstance.isUserLoggedIn() {
            AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to submit your review. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                Utility().topViewController()?.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
            return
        }
        
        if populateOwnRating {
            return
        }
        
        var rating: [[String:Double]] = []
        for (i,cell) in self.tableView.visibleCells.enumerated() {
            if let cell = cell as? VehicleSubmitRateItemCell {
                
                if(cell.rateView.rating == 0.0){
                 Utility.showAlert(title: "Error", message: "Select at least 1 star to rate on all attributes")
                    return
                }
                 rating.append([rateFields[i].id?.description ?? "": cell.rateView.rating])
            }
        }
        
        self.submitReview(rating: rating)
    }
    
    func submitReview(rating: [[String:Double]]) {
        let reviewParams: [String: Any] = ["rating": rating,
                                           "car_id": self.carId ?? 0,
                                           "review_message": reviewTextView.isPlaceholder() ? "" : reviewTextView.text ]
        
        APIManager.sharedInstance.submitReview(params: reviewParams, success: { (result) in
            self.delegate?.didReviewSubmitted()
        }) { (error) in
            
        }
    }
    
    
}

extension VehicleSubmitRateCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        
        if let vehicleSubmitRateItemCell = cell as? VehicleSubmitRateItemCell {
            if populateOwnRating {
                vehicleSubmitRateItemCell.setData(reviewRatingModel: ownRating[indexPath.row])
            } else {
                vehicleSubmitRateItemCell.setData(rateFieldsModel: rateFields[indexPath.row])
            }
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return populateOwnRating ? ownRating.count : rateFields.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(VehicleSubmitRateItemCell.cellHeight)
    }
    
}


