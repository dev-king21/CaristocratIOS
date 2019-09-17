//
//  VehicleDetailController.swift
 import UIKit
import FaveButton
import ImageSlideshow

protocol VechicleDetailCellsDelegate {
    func didDataUpdate()
    func didTapOnBack()
    func didTapOnShare()
    func didTapOnTrade()
    func didTapOnPersonalShopper()
    func didTapOnVirtualBuy()
    func didTapOnSpecsSection(position: Int)
    func didTapOnSimilarListing(vehicles: [VehicleBase], selectedVehicle: VehicleBase)
    func didReviewSubmitted()
}

class VehicleDetailController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    var slug: String?
    
    var cells: [CellWithoutHeight] = [(VehicleImagesCell.identifier,1),
                                      (AboutVehicleCell.identifier,1),
                                      (ContactInfoCell.identifier,1),
                                      (DescriptionCell.identifier,1),
                                      (SpecificationCell.identifier,1),
                                      (UsersReviewCell.identifier,-1),
                                      (NotFoundCell.identifier,0),
                                      (SimilarListingCell.identifier,1)
                                      ]
    var vehicleDetail: VehicleBase?
    var carId: Int?
    var allVehicles: [VehicleBase] = []
    var reviews: [ReviewModel] = []
    var specs: [[Specs]] = []
    var images: [KingfisherSource] = []
    var isFirstTime = true
    var hasMultipleSpecs = false
    var specsItemState: [Int:Bool] = [:]
    var isForReview = false
    var needToReload = false

    override func viewDidLoad() {
        hideNavBar = true
        super.viewDidLoad()
        

        self.getVehicleDetail()
        self.getReviews()
        self.customizeApperence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if needToReload {
            needToReload = false
            self.getVehicleDetail()
            self.getReviews()
        }
    }

    
    func adjustCells() {
        hasMultipleSpecs = self.slug == Slugs.LUXURY_MARKET.rawValue
        self.addSpecs()
        cells[4] = (SpecificationCell.identifier, hasMultipleSpecs ? specs.count : 1)
        if hasMultipleSpecs && isFirstTime {
            isFirstTime = false
            
            if (self.vehicleDetail?.depreciation_trend_value?.count ?? 0) > 0 {
                self.tableView.register(UINib(nibName: DepreciationTrendCell.identifier, bundle: nil), forCellReuseIdentifier: DepreciationTrendCell.identifier)
                cells.insert((identifier: DepreciationTrendCell.identifier, count: 1), at: 5)
            }
            
            if let lifeCycle = self.vehicleDetail?.life_cycle, lifeCycle != "0-0" {
                self.tableView.register(UINib(nibName: LifeCycleCell.identifier, bundle: nil), forCellReuseIdentifier: LifeCycleCell.identifier)
                cells.insert((identifier: LifeCycleCell.identifier, count: 1), at: 5)
            }
            

            
            self.tableView.register(UINib(nibName: RegionsCell.identifier, bundle: nil), forCellReuseIdentifier: RegionsCell.identifier)
            cells.insert((identifier: RegionsCell.identifier, count: 1), at: 5)
        }
    }
    
    func addSpecs() {
        // This specs array is static now we will make it dynamic later.
        if hasMultipleSpecs {
            specs.removeAll()
            
//            specs.append(vehicleDetail?.limited_edition_specs_array?.dimensions_Weight ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.seating_Capacity ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.drivetrain ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.engine ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.performance ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.transmission ?? [])
            //specs.append(vehicleDetail?.limited_edition_specs_array?.brakes ?? [])
            //specs.append(vehicleDetail?.limited_edition_specs_array?.suspension ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.wheels_Tyres ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.fuel ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.emission ?? [])
            specs.append(vehicleDetail?.limited_edition_specs_array?.warranty_Maintenance ?? [])
        }
    }
    
    func customizeApperence() {
        self.prepareTableview()
    }
    
    func addFooter() {
        let footer: OptionsCell = OptionsCell.fromNib()
        footer.frame = CGRect(x: 0, y: 0, width: self.footerView.frame.width, height: self.footerView.frame.height)
        footer.delegate = self
        footer.setData(vehicleDetail: self.vehicleDetail!)
        self.footerView.addSubview(footer)
    }
    
    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func setData() {
        
    }
    
    func addNotFoundCellIfNeeded() {
        if reviews.count == 0 {
            cells[6].count = 1
        }
    }
    
    func getReviews() {
        if self.slug == Slugs.LUXURY_MARKET.rawValue {
            APIManager.sharedInstance.getReviews(carId: carId ?? -1, success: { (result) in
                self.reviews = result
                self.addNotFoundCellIfNeeded()
                self.tableView.reloadData()
            }) { (error) in
                
            }
        } else {
            cells = cells.filter({$0.identifier != UsersReviewCell.identifier})
        }
        
    }
    
    func getVehicleDetail() {
        APIManager.sharedInstance.getVehiclesDetail(carId: self.carId ?? 0, success: { (result) in
            self.vehicleDetail = result
            if self.slug == nil {
              self.slug = self.vehicleDetail?.category?.slug
            }
            print(self.vehicleDetail?.specifications?.count)
            self.adjustCells()
            self.submitInteraction(type: .View)
            self.getSimilarCars()
            self.addFooter()
            

            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
//    func getVehicleDetailForDeepLink() {
//        APIManager.sharedInstance.getVehiclesDetailBySlug(slugId: self.carSlug ?? "", success: { (result) in
//            self.vehicleDetail = result
//            self.carId = self.vehicleDetail?.id
//            if self.slug == nil {
//                self.slug = self.vehicleDetail?.category?.slug
//            }
//            print(self.vehicleDetail?.specifications?.count)
//            self.getReviews()
//            self.adjustCells()
//            self.getSimilarCars()
//            self.addFooter()
//            
//            self.tableView.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    func getSimilarCars() {
//        let params : Parameters = ["category_id" : self.vehicleDetail?.category?.id ?? -1]

        
        var params : Parameters = ["category_id" : self.vehicleDetail?.category?.id ?? -1]
        if let filterModel = AppStateManager.sharedInstance.filterOptions {
            
            //            var brandIds = ""
            //            for (key, value) in filterModel.selectedBrands {
            //                brandIds += "\(key),"
            //            }
            //            params.updateValue(brandIds, forKey: "brand_ids")
            
            var modelsIds = ""
            for (key, item) in filterModel.selectedModels {
                if item.first?.value ?? false {
                    modelsIds += "\(key),"
                }
            }
            params.updateValue(modelsIds.dropLast(), forKey: "model_ids")
            
            var versionIds = ""
            for (key, _) in filterModel.selectedVersions {
                versionIds += "\(key),"
            }
            params.updateValue(modelsIds.dropLast(), forKey: "version_id")
            
            var regionsIds = ""
            for (key, _) in filterModel.selectedCountries {
                regionsIds += "\(key),"
            }
            params.updateValue(regionsIds.dropLast(), forKey: "regions")
            
            if let styles = filterModel.styles {
                params.updateValue(styles, forKey: "car_type")
            }
            
            if let transmissionType = filterModel.transmission_type {
                params.updateValue(transmissionType, forKey: "transmission_type")
            }
            
           
            if let styles = filterModel.styles {
                params.updateValue(styles, forKey: "car_type")
            }
            
            if let min_price = filterModel.min_price {
                params.updateValue(min_price, forKey: "min_price")
            }
            
            if let max_price = filterModel.max_price {
                params.updateValue(max_price, forKey: "max_price")
            }
            
            if let min_year = filterModel.min_model_year {
                params.updateValue(min_year, forKey: "min_year")
            }
            
            if let max_year = filterModel.max_model_year {
                params.updateValue(max_year, forKey: "max_year")
            }
            
            if let min_mileage = filterModel.min_mileage {
                params.updateValue(min_mileage, forKey: "min_mileage")
            }
            
            if let max_mileage = filterModel.max_mileage {
                params.updateValue(max_mileage, forKey: "max_mileage")
            }
            
            if let dealer_type = filterModel.dealer_type {
                params.updateValue(dealer_type, forKey: "dealer")
            }
        }
        
//        params.updateValue(limit, forKey: "limit")
//        params.updateValue(offset, forKey: "offset")
        
        APIManager.sharedInstance.getVehicles(params: params, success: { (result) in
            self.allVehicles = result
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
   
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func submitInteraction(type: InteractionType) {
        APIManager.sharedInstance.carInteraction(car_id: vehicleDetail?.id ?? -1,
                                                 interactionType: type, success: { (result) in
                                                    
        }) { (error) in
            
        }
    }
    
}

extension VehicleDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        if let vehicleDetail = self.vehicleDetail {
            if let vehicleImagesCell = cell as? VehicleImagesCell {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnSlideShow(sender:)))
                vehicleImagesCell.featureSlideShow.addGestureRecognizer(tapGesture)
                vehicleImagesCell.delegate = self
                vehicleImagesCell.hideControls()
                vehicleImagesCell.setData(vehicleDetail: vehicleDetail)
            } else if let aboutVehicleCell = cell as? AboutVehicleCell {
                aboutVehicleCell.slug = self.slug ?? ""
                aboutVehicleCell.setData(vehicleDetail: vehicleDetail, myTradeIn: nil)
            } else if let specificationCell = cell as? SpecificationCell {
                if hasMultipleSpecs {
                   specificationCell.delegate = self
                   specificationCell.isExpanded = self.specsItemState[indexPath.row] ?? false
                    specificationCell.row = indexPath.row
                   specificationCell.setData(specs: specs[indexPath.row], sectionTitle: Constants.specsSectionTitles[indexPath.row])
                } else {
                   specificationCell.delegate = self
                   specificationCell.setData(vehicleDetail: vehicleDetail)
                }
            } else if let contactInfoCell = cell as? ContactInfoCell {
                if (self.slug.unWrap == Slugs.LUXURY_MARKET.rawValue) && (vehicleDetail.dealers?.count ?? 0 > 0)  {
                    contactInfoCell.setData(showroom_details: vehicleDetail.dealers?[indexPath.row].showroom_details)
                } else {
                    contactInfoCell.setData(vehicleDetail: vehicleDetail)
                }
            } else if let optionsCell = cell as? OptionsCell {
                optionsCell.delegate = self
                optionsCell.setData(vehicleDetail: vehicleDetail)
            } else if let regionsCell = cell as? RegionsCell {
                regionsCell.setData(carRegions: vehicleDetail.car_regions ?? [])
            } else if let depreciationTrendCell = cell as? DepreciationTrendCell {
                depreciationTrendCell.setData(vehicleDetail: self.vehicleDetail!,trendValue: vehicleDetail.depreciation_trend_value ?? [])
            } else if let similarListingCell = cell as? SimilarListingCell {
                similarListingCell.allVehicles = allVehicles
                similarListingCell.delegate = self
                similarListingCell.setData(vehicleDetail: self.vehicleDetail!)
            } else if let descriptionCell = cell as? DescriptionCell {
                descriptionCell.vehicleDetail = vehicleDetail
            }  else if let lifeCycleCell = cell as? LifeCycleCell {
                lifeCycleCell.setData(vehicleDetail: self.vehicleDetail!)
            } else if let usersReviewCell = cell as? UsersReviewCell {
                if(reviews.count > 0){
                 usersReviewCell.setData(reviewsDetail: reviews[indexPath.row])
                }
            }
        } else {
           
        }
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells[section].count == -1 && cells[section].identifier == UsersReviewCell.identifier {
            return reviews.count > 2 ? 2 : reviews.count
        } else if cells[section].identifier == ContactInfoCell.identifier && self.slug == Slugs.LUXURY_MARKET.rawValue {
          return self.vehicleDetail?.dealers?.count ?? 1
        } else {
            return cells[section].count
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if cells[section].identifier == UsersReviewCell.identifier {
            let sectionHeader: UserReviewSectionHeader = UserReviewSectionHeader.fromNib()
            if let vehicleDetail = self.vehicleDetail {
                sectionHeader.setData(vehicleDetail: vehicleDetail)
            }
            sectionHeader.slug = self.slug
            sectionHeader.delegate = self
            sectionHeader.vehicleDetail = self.vehicleDetail
            return sectionHeader
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if cells[section].identifier == UsersReviewCell.identifier {
            let footerView: UsersReviewFooterView = UsersReviewFooterView.fromNib()
            footerView.delegate = { () in
                let vehicleReviewContoller = VehicleReviewContoller.instantiate(fromAppStoryboard: .Consultant)
                vehicleReviewContoller.carId = self.vehicleDetail?.id ?? 0
                vehicleReviewContoller.slug = self.slug
                self.navigationController?.pushViewController(vehicleReviewContoller, animated: true)
                self.needToReload = true
            }
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (cells[section].identifier == UsersReviewCell.identifier ? UserReviewSectionHeader.heightOfView : 0.0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (cells[section].identifier == UsersReviewCell.identifier && self.reviews.count > 0) ? 60 : 0
    }
}

extension VehicleDetailController: VechicleDetailCellsDelegate {
    func didReviewSubmitted() {
        self.needToReload = true
    }
    
    func didReview() {
        
    }

    func didTapOnSpecsSection(position: Int) {
        self.specsItemState[position] = !(self.specsItemState[position] ?? false)
        self.tableView.reloadData()
    }
    
    func didDataUpdate() {
        self.getVehicleDetail()
    }
    
    func didTapOnSimilarListing(vehicles: [VehicleBase], selectedVehicle: VehicleBase) {
        let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
        vehicleController.carId = selectedVehicle.id
        vehicleController.vehicleDetail = selectedVehicle
        vehicleController.allVehicles = vehicles
        vehicleController.slug = self.slug
        self.navigationController?.pushViewController(vehicleController, animated: true)
    }
    
    func didTapOnBack() {
        if let nc = self.navigationController {
           nc.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func didTapOnShare() {
        let string = self.vehicleDetail?.name ?? ""
//        let url = URL(string: self.vehicleDetail?.media?.first?.file_url ?? "www.google.com")!
        let url = URL(string: self.vehicleDetail?.link2 ?? "www.google.com")!
        var image = #imageLiteral(resourceName: "image_placeholder")
        if let imageData = try? Data(contentsOf: url){
            image = UIImage(data: imageData) ?? #imageLiteral(resourceName: "image_placeholder")
        }
        //let activityViewController = UIActivityViewController(activityItems: [string, url,image], applicationActivities: nil)
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func didTapOnTrade() {
        //self.navigationController?.pushViewController(SelectCarController.instantiate(fromAppStoryboard: .Home), animated: true)
        if (self.slug.unWrap == Slugs.LUXURY_MARKET.rawValue) {
            if let dealers = self.vehicleDetail?.dealers, dealers.count > 0 && self.vehicleDetail?.category?.id == Constants.LUXURY_MARKET_CATEGORY_ID  {
                
                let controller = SelectCarController.instantiate(fromAppStoryboard: .Home)
                controller.selectedVehicleDetail = self.vehicleDetail
                self.navigationController?.pushViewController(controller, animated: true)
                
                
//                if AppStateManager.sharedInstance.isUserLoggedIn() {
//                    let controller = SelectCarController.instantiate(fromAppStoryboard: .Home)
//                    controller.selectedVehicleDetail = self.vehicleDetail
//                    self.navigationController?.pushViewController(controller, animated: true)
//                } else {
//                    AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see your Profile. Do you want to signin?") {
//                        let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
//                        signinController.isGuest = true
//                        self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
//                    }
//                }
            } else {
                Utility.showErrorWith(message: "No dealer available")
            }
        } else {
            
            let controller = SelectCarController.instantiate(fromAppStoryboard: .Home)
            controller.selectedVehicleDetail = self.vehicleDetail
            self.navigationController?.pushViewController(controller, animated: true)
            
//            if AppStateManager.sharedInstance.isUserLoggedIn() {
//                let controller = SelectCarController.instantiate(fromAppStoryboard: .Home)
//                controller.selectedVehicleDetail = self.vehicleDetail
//                self.navigationController?.pushViewController(controller, animated: true)
//            } else {
//                AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see your Profile. Do you want to signin?") {
//                    let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
//                    signinController.isGuest = true
//                    self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
//                }
//            }
        }
    }
    
    func didTapOnPersonalShopper() {
        AlertViewController.showAlert(title: "Personal Shopper", description: "Write to us with your query and we will get back to you.", rightButtonText: "Request a Call", leftButtonText: "Call Now", delegate: self)
        
//        Utility.showAlert(title: , message: "", positiveText: , positiveClosure: { (alert) in
//        }, negativeClosure: { (alert) in
//
//        }, navgativeText: , preferredStyle: .alert)
        
    }
    
    func didTapOnVirtualBuy() {
    //self.navigationController?.pushViewController(VirtualBuyViewController.instantiate(fromAppStoryboard: .LuxuryMarket), animated: true)
        let controller = VirtualBuyViewController.instantiate(fromAppStoryboard: .LuxuryMarket)
        controller.selectedVehicleDetail = self.vehicleDetail
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension VehicleDetailController: AlertViewDelegates {
    func didTapOnRightButton() {
        submitInteraction(type: .Request)
        let controller = AskForConsultancyController.instantiate(fromAppStoryboard: .LuxuryMarket)
        controller.vehicleDetail = self.vehicleDetail
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapOnLeftButton() {
        submitInteraction(type: .Phone)
        CallViewController.makeCall(titleText: "Would you like to call \(self.vehicleDetail?.owner?.details?.first_name ?? "")" , phoneNumber: self.vehicleDetail?.owner?.details?.phone ?? "", carId: vehicleDetail?.id ?? 0)
    }
    
    
}
extension VehicleDetailController{
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
                if (carImage.media_type ?? 0) == 10 {
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


extension VehicleDetailController: PopupDelgates {
    
    func didTapOnClose() {
        
    }
}
