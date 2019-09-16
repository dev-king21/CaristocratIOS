//
//  VehicleUserRateCell.swift
 import UIKit
import Cosmos

class VehicleUserRateCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratesCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noOfRatingLabel: UILabel!
    @IBOutlet weak var userRatingView: CosmosView!
    
    var cells: [CellWithoutHeight] = [(VehicleUserRateItemCell.identifier,1)]
    var reviewsDetail: ReviewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureCollectionView()
    }
    
    func setData(reviewsDetail: ReviewModel) {
        self.profileImage.kf.setImage(with: URL(string: reviewsDetail.user_details?.image_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        self.usernameLabel.text = reviewsDetail.user_details?.user_name ?? ""
        self.noOfRatingLabel.text = "(\(reviewsDetail.average_rating ?? 0))"
        self.userRatingView.rating = Double(reviewsDetail.average_rating ?? 0)
        self.reviewLabel.text = reviewsDetail.review_message ?? ""
        self.reviewsDetail = reviewsDetail
        self.adjustCollectionViewHeight()
    }
    
    func adjustCollectionViewHeight() {
        collectionViewHeight.constant = ((CGFloat((reviewsDetail?.details?.count ?? 1)) / 2).rounded(.awayFromZero)) * CGFloat(VehicleUserRateItemCell.cellHeight)
        ratesCollectionView.reloadData()
    }
    
    func registerCells() {
      for cell in cells {
        self.ratesCollectionView?.register(UINib(nibName: cell.identifier, bundle: nil), forCellWithReuseIdentifier: cell.identifier)
      }
    }
    
    func configureCollectionView() {
        self.registerCells()
        
        self.ratesCollectionView?.dataSource = self
        self.ratesCollectionView?.delegate = self
        
    }
    
}

extension VehicleUserRateCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ratesCollectionView?.dequeueReusableCell(withReuseIdentifier: VehicleUserRateItemCell.identifier, for: indexPath) as! VehicleUserRateItemCell

        if let reviewDetail = reviewsDetail?.details {
            cell.setData(reviewRatingModel: reviewDetail[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewsDetail?.details?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20 , height: CGFloat(VehicleUserRateItemCell.cellHeight))
    }
    
}

