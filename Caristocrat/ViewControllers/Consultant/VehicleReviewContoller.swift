//
//  VehicleReviewContoller.swift
 import UIKit
import ImageSlideshow

class VehicleReviewContoller: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var cells: [CellWithoutHeight] = [(VehicleImagesCell.identifier,1),
                                      (AboutVehicleCell.identifier,1),
                                      (VehicleSubmitRateCell.identifier,1),
                                      (VehicleUserRateCell.identifier,-1),
                                      (NotFoundCell.identifier,0)]
    var vehicleDetail: VehicleBase?
    var carId: Int?
    var images: [KingfisherSource] = []
    var slug: String?
    var rateFields: [RateFieldsModel] = []
    var reviews: [ReviewModel] = []
    var showAllReviews = true
    var topReviewsShowCount = 2

    override func viewDidLoad() {
        hideNavBar = true
        super.viewDidLoad()
        
        self.getVehicleDetail()
        self.getRateFields()
        self.getReviews()
        self.customizeApperence()
    }
    
    func customizeApperence() {
        self.prepareTableview()
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
    
    func getRateFields() {

        if self.vehicleDetail?.is_reviewed?.value() ?? false {
            return
        }
        
        APIManager.sharedInstance.getRateFields(success: { (result) in
            self.rateFields = result
            self.tableView.reloadData()
            self.view.endEditing(true)
        }) { (error) in
            
        }
    }
    
    func addNotFoundCellIfNeeded() {
        if reviews.count == 0 {
            cells[cells.count-1].count = 1
        }
    }
    
    func getReviews() {
        APIManager.sharedInstance.getReviews(carId: carId ?? -1, success: { (result) in
            self.reviews = result
            self.addNotFoundCellIfNeeded()
            self.addRemoveFooterInTableView()
            self.tableView.reloadData()
            self.view.endEditing(true)
        }) { (error) in
            
        }
    }
    
    func addRemoveFooterInTableView() {
        if reviews.count > topReviewsShowCount && !self.showAllReviews {
            let customFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
            customFooterView.backgroundColor = UIColor.lightGray
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24.5))
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle("Read All Reviews", for: .normal)
            button.applyCustomFont = true
            button.titleLabel?.font = UIFont(name: (button.titleLabel?.font.fontName)!, size: 12)
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(tappedOnAllReviews), for: .touchUpInside)
            customFooterView.addSubview(button)
            
            self.tableView.tableFooterView = customFooterView
        } else {
            self.tableView.tableFooterView = nil
        }
    }
    
    @objc func tappedOnAllReviews() {
        showAllReviews = true
        self.addRemoveFooterInTableView()
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    func getVehicleDetail() {
        APIManager.sharedInstance.getVehiclesDetail(carId: self.carId ?? 0, success: { (result) in
            self.vehicleDetail = result
            self.tableView.reloadData()
            self.view.endEditing(true)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension VehicleReviewContoller: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        if let vehicleDetail = self.vehicleDetail {
            if let vehicleImagesCell = cell as? VehicleImagesCell {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnSlideShow(sender:)))
                vehicleImagesCell.featureSlideShow.addGestureRecognizer(tapGesture)
                vehicleImagesCell.delegate = self
                vehicleImagesCell.isForReview = true
                vehicleImagesCell.setData(vehicleDetail: vehicleDetail)
            } else if let aboutVehicleCell = cell as? AboutVehicleCell {
                aboutVehicleCell.slug = self.slug ?? ""
                aboutVehicleCell.forReview = true
                aboutVehicleCell.setData(vehicleDetail: vehicleDetail, myTradeIn: nil)
            } else if let vehicleSubmitRateCell = cell as? VehicleSubmitRateCell {
                vehicleSubmitRateCell.delegate = self
                if self.vehicleDetail?.is_reviewed?.value() ?? false {
                    if let reviewDetail = self.reviews.filter({$0.user_details?.user_id == AppStateManager.sharedInstance.userData?.user?.id}).first {
                        vehicleSubmitRateCell.setRating(reviewsDetail: reviewDetail)
                    }
                } else {
                    vehicleSubmitRateCell.setData(carId: self.vehicleDetail?.id ?? 0, rateFields: rateFields)
                }
            }  else if let vehicleUserRateCell = cell as? VehicleUserRateCell {
                vehicleUserRateCell.setData(reviewsDetail: self.reviews[indexPath.row])
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells[section].count == -1 && cells[section].identifier == VehicleUserRateCell.identifier {
            return self.reviews.count > topReviewsShowCount ? (self.showAllReviews ? self.reviews.count : topReviewsShowCount) : self.reviews.count
        }
        
        return cells[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if cells[section].identifier == VehicleUserRateCell.identifier {
            let sectionHeader: SectionsHeader = SectionsHeader.fromNib()
            return sectionHeader
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (cells[section].identifier == VehicleUserRateCell.identifier ? SectionsHeader.heightOfView : 0.0)
    }
}

extension VehicleReviewContoller: VechicleDetailCellsDelegate {
    func didDataUpdate() {
        
    }
    
    func didTapOnBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapOnShare() {
        let string = self.vehicleDetail?.name ?? ""
        //        let url = URL(string: self.vehicleDetail?.media?.first?.file_url ?? "www.google.com")!
        let url = URL(string: self.vehicleDetail?.link ?? "www.google.com")!
        var image = #imageLiteral(resourceName: "image_placeholder")
        if let imageData = try? Data(contentsOf: url){
            image = UIImage(data: imageData) ?? #imageLiteral(resourceName: "image_placeholder")
        }
        let activityViewController =
            UIActivityViewController(activityItems: [string, url,image],
                                     applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapOnTrade() {
        
    }
    
    func didTapOnPersonalShopper() {
        
    }
    
    func didTapOnVirtualBuy() {
        
    }
    
    func didTapOnSpecsSection(position: Int) {
        
    }
    
    func didTapOnSimilarListing(vehicles: [VehicleBase], selectedVehicle: VehicleBase) {
        
    }
    
    func didReviewSubmitted() {
        self.getVehicleDetail()
        self.getReviews()
    }
}

extension VehicleReviewContoller {
    @objc func didTapOnSlideShow(sender:UIGestureRecognizer){
        self.getCarImagesURLs()
        if let slideShowView = sender.view as? ImageSlideshow{
            let currentPage = slideShowView.currentPage
            let controller = SlideShow.instantiate(fromAppStoryboard: .Home)
            controller.cur_image_index = currentPage
            controller.ImageSliderArray = self.images
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func getCarImagesURLs(){
        guard let carImages = self.vehicleDetail?.media else {return}
        self.images.removeAll()
        for carImage in carImages {
            if let source = carImage.file_url {
                if (carImage.media_type ?? 0) == 10{
                    guard let kingfisherSource = KingfisherSource(urlString:source) else {return}
                    self.images.append(kingfisherSource)
                }
                else{
                    let youtubeURL = Utility.youtubeThumbnail(url: source)
                    guard let kingfisherSource = KingfisherSource(urlString:youtubeURL) else {return}
                    self.images.append(kingfisherSource)
                }
            }
        }
    }
}

