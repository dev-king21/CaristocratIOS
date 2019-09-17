    //
//  VehiclesController.swift
    
    //Luxury New Cars
    
 import UIKit
import DZNEmptyDataSet

protocol SortModesDelegates {
    func didChangeMode(sortMode: Any)
}
    
class VehiclesController: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var discoverTabView:UIView!
    @IBOutlet weak var recentlyTabView:UIView!
    @IBOutlet weak var discoverTabLabel:UILabel!
    @IBOutlet weak var recentlyTabLabel:UILabel!
    @IBOutlet weak var sortModesView: VehicleSortModesView!
    @IBOutlet weak var reviewsSortModesView: ReviewsSortModesView!
    @IBOutlet weak var tvSearch: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var customNavigation: UINavigationBar!

    var slug: String?
    var didApplyFilter = true
    var didClearFilter = false
    var isForReview = false
    
    var cells: [CellWithoutHeight] = [(VehicleHeaderCell.identifier, 1),
                                      (VehicleCell.identifier,-1),
//                                    (LoadingCell.identifier,1)
                                      ]

    var vehicles: [VehicleBase] = []
    var sortedVehicles: [VehicleBase] = []
    var categoryId = 0
    var selectedTab = SelectTab.Discover
    var vehicleSelectedMode = VehicleSortModes.NewestToOldest
    var reviewsSelectedMode = ReviewsSortModes.HighestRatings
  //  var reviewsSelectedMode = ReviewsSortModes.LatestReviews
    var didPickerShown = false
    
//    var canLoadMore = true
//    var isLoading = false
//    var offset = 0
    
    
    //Paging work
    var limit = 50
    var offset = 0
    var tblFooter  = LoadMoreView.instanceFromNib()
    
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    override func viewDidLoad() {
        hideNavBar = true
        super.viewDidLoad()
        AppStateManager.sharedInstance.clearFilter(withCountry: false)
        didPickerShown = AppStateManager.sharedInstance.isRememberCountry
        self.customizeApperence()
        
        if !self.didPickerShown && !isForReview {
            self.presentCountrySelectionController()
        } else {
            if didApplyFilter {
                self.getVehicles()
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
//        if !self.didPickerShown && !isForReview {
//            self.presentCountrySelectionController()
//        } else {
//            if didApplyFilter {
//                self.getVehicles()
//            }
//        }
        
        if didClearFilter {
            self.getVehicles()
        }
        
        self.setNavigationBarFont()
    }
    
    func setNavigationBarFont() {
        if let font = UIFont(name: FontsType.Heading.rawValue, size: (self.title?.count ?? 0 > 11)  ? (self.title?.count ?? 0 > 15) ? 15 : 17 : 20){
            self.customNavigation.titleTextAttributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:UIColor.black]
        }
    }
    
    func customizeApperence() {
        self.prepareTableview()
        
        self.tvSearch.delegate = self
        self.sortModesView.delegate = self
        self.reviewsSortModesView.delegate = self
        
        if isForReview {
            self.customNavigation.topItem?.title = "Reviews"
            discoverTabLabel.text = "All Cars"
        } else {
            self.customNavigation.topItem?.title = navTitle
        }
        
        //local search work
        //tvSearch.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)

    }
    
    @objc func textFieldChanged() {
        if let text = tvSearch.text {
            if text.length == 0 {
                self.vehicles = self.sortedVehicles
            }
            else {
                if let text = tvSearch.text {
                    let keyword = text
                    self.vehicles = self.sortedVehicles.filter({$0.name?.lowercased().contains(keyword.lowercased()) ?? false})
                }
            }
        }
        
        self.tableView.reloadData()
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
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
    }
    
    func getVehicles() {
        didApplyFilter = false
        
        let showloader = offset == 0 ? true:false
        
        var params : Parameters = ["category_id" : self.categoryId]
        params["is_for_review"] = isForReview ? 1 : 0
        if let filterModel = AppStateManager.sharedInstance.filterOptions {
            
            
            
            var brandIds = ""
            for (key, _) in filterModel.selectedBrands {
                brandIds += "\(key),"
            }
            params.updateValue(brandIds.dropLast(), forKey: "brand_ids")
            
            var modelsIds = ""
            for (key, item) in filterModel.selectedModels {
                if item.first?.value ?? false {
                    
                    if key != -1 {
                        modelsIds += "\(key),"
                    }
                    
                }
            }
            params.updateValue(modelsIds.dropLast(), forKey: "model_ids")
            
            var versionIds = ""
            for (key, _) in filterModel.selectedVersions {
                if key != -1 {
                    versionIds += "\(key),"
                }
                
            }
            params.updateValue(versionIds.dropLast(), forKey: "version_id")
            

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
            
            if self.selectedTab == .RecentlyViewed {
                params.updateValue(1, forKey: "most_viewed")
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
            
            if let version = filterModel.version {
                params.updateValue(version, forKey: "version")
            }
            
            if let rating = filterModel.rating {
                params.updateValue(rating, forKey: "rating")
            }
         }
        
        if isForReview {
            //for required data only
            params.updateValue("2", forKey: "service_type")
            
            switch reviewsSelectedMode {
            case .HighestRatings:
                params.updateValue(-1, forKey: "sort_by_rating")
            case .LowestRatings:
                params.updateValue(1, forKey: "sort_by_rating")
            case .LatestReviews:
                params.updateValue(1, forKey: "sort_by_latest_review")
            case .NoofReviews:
                params.updateValue(-1, forKey: "sort_by_review_count")
                
            }
        }else{
            switch vehicleSelectedMode {
            case .HighestPrice:
                params.updateValue(-1, forKey: "sort_by_price")
            case .LowestPrice:
                params.updateValue(1, forKey: "sort_by_price")
            case .NewestToOldest:
                params.updateValue(-1, forKey: "sort_by_created")
            case .OldestToNewest:
                params.updateValue(1, forKey: "sort_by_created")
                
            }
        }
        
        if tvSearch.text != "" {
            params.updateValue(tvSearch.text!, forKey: "car_title")
        }
        
        params.updateValue(limit, forKey: "limit")
        params.updateValue(offset, forKey: "offset")

        
        //params.removeValue(forKey: "regions")
        
        print(params)
        
        //isLoading = true
        APIManager.sharedInstance.getVehiclesWithPaging(params: params,showLoader: showloader, success: { (result) in
            
//            self.sortedVehicles.removeAll()
//            self.vehicles.removeAll()
            
            
//            if result.count > 0 {
//
//                self.sortedVehicles += result
//                self.vehicles += result
//                if self.isForReview {
//                    self.applyReviewsSorting()
//                }
//            } else {
//                self.canLoadMore = false
//            }
            
            self.sortedVehicles += result
            self.vehicles += result
            
            if self.vehicles.count < LastService.totalCount {
                self.tableView.tableFooterView = self.tblFooter
            }else{
                self.tableView.tableFooterView = nil
            }
            
            
            //self.tableView.setContentOffset(.zero, animated: true)
            self.tableView.reloadData()
    
            
        }) { (error) in
            print("")
        }
    }
    
    func switchTab(selectedTab: SelectTab) {
        tvSearch.text = ""
   
        self.selectedTab = selectedTab
        if selectedTab == .Discover {
            discoverTabView.backgroundColor = .black
            discoverTabLabel.textColor = .white
            recentlyTabView.backgroundColor = .white
            recentlyTabLabel.textColor = .black
        } else {
            discoverTabView.backgroundColor = .white
            discoverTabLabel.textColor = .black
            recentlyTabView.backgroundColor = .black
            recentlyTabLabel.textColor = .white
        }
        
//        offset = 0
//        self.sortedVehicles.removeAll()
//        self.vehicles.removeAll()
//        self.tableView.tableFooterView = nil
//
//        tableView.reloadData()
//
//        self.getVehicles()
        resetDataSource()
    }
    
    func resetDataSource(){
        offset = 0
        self.sortedVehicles.removeAll()
        self.vehicles.removeAll()
        self.tableView.tableFooterView = nil
        
        tableView.reloadData()
        
        self.getVehicles()
    }
    
    func moveAhead(index: Int) {
        if isForReview {
            let vehicleReviewContoller = VehicleReviewContoller.instantiate(fromAppStoryboard: .Consultant)
//            vehicleReviewContoller.vehicleDetail = vehicles[index]
            vehicleReviewContoller.carId = vehicles[index].id
            vehicleReviewContoller.slug = self.slug
            self.navigationController?.pushViewController(vehicleReviewContoller, animated: true)
        } else {
            let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
            vehicleController.carId = vehicles[index].id
            vehicleController.allVehicles = vehicles
            vehicleController.slug = self.slug
            vehicleController.isForReview = isForReview
            self.navigationController?.pushViewController(vehicleController, animated: true)
        }
    }
    
    func appyVehiclesSorting() {
        switch self.vehicleSelectedMode {
        case .NewestToOldest:
            self.vehicles = self.sortedVehicles
        case .OldestToNewest:
            self.vehicles = self.sortedVehicles.reversed()
        case .HighestPrice:
            self.vehicles = self.vehicles.sorted(by: { $0.amount ?? 0 > $1.amount ?? 0 })
        case .LowestPrice:
            self.vehicles = self.vehicles.sorted(by: { $0.amount ?? 0 < $1.amount ?? 0 })
        }
        self.vehicles = self.vehicles.sorted(by: { $0.isFeature ?? 0 > $1.isFeature ?? 0 })
        self.tableView.reloadData()
    }
    
    func applyReviewsSorting() {
        switch self.reviewsSelectedMode {
        case .LatestReviews:
            self.vehicles = self.sortedVehicles
        case .HighestRatings:
            self.vehicles = self.vehicles.sorted(by: { $0.average_rating ?? 0 > $1.average_rating ?? 0 })
        case .LowestRatings:
            self.vehicles = self.vehicles.sorted(by: { $0.average_rating ?? 0 < $1.average_rating ?? 0 })
        case .NoofReviews:
            self.vehicles = self.vehicles.sorted(by: { $0.review_count ?? 0 > $1.review_count ?? 0 })
        }

      //  self.vehicles = self.vehicles.sorted(by: { $0.isFeature ?? 0 > $1.isFeature ?? 0 })
        
        self.tableView.reloadData()
    }
    
    func presentCountrySelectionController() {
        
        if(self.slug == Slugs.LUXURY_MARKET.rawValue){
            self.getVehicles()
            return
        }
        
        didPickerShown = true
        if !AppStateManager.sharedInstance.isRememberCountry {
            let countriesViewController = CountrySelectionController.instantiate(fromAppStoryboard: .LuxuryMarket)
            countriesViewController.delegate = self
            countriesViewController.modalPresentationStyle = .overCurrentContext
            countriesViewController.modalTransitionStyle = .crossDissolve
            present(countriesViewController, animated: true)
        }
    }
    
    @IBAction func discoverViewTapped() {
        switchTab(selectedTab: .Discover)
    }
    
    @IBAction func recentlyViewedTapped() {
        switchTab(selectedTab: .RecentlyViewed)
    }
    
    @IBAction func tappedOnFilter() {
        let filterController = FilterController.instantiate(fromAppStoryboard: .LuxuryMarket)
        filterController.delegate = self
        filterController.categoryId = self.categoryId
        filterController.slug = Slugs(rawValue: self.slug ?? "") ?? .LUXURY_MARKET
        self.navigationController?.pushViewController(filterController, animated: true)
    }
    
    @IBAction func tappedOnSortMode() {
        if isForReview {
            self.reviewsSortModesView.isHidden ? self.reviewsSortModesView.animShow() : self.reviewsSortModesView.animHide()

        } else {
            self.sortModesView.isHidden ? self.sortModesView.animShow() : self.sortModesView.animHide()

        }
    }
    
    @IBAction func tappedOnClose() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func closeSearchBar() {

        
        self.tvSearch.text = ""
        resetDataSource()
        
//            self.vehicles = self.sortedVehicles   //local search work
//            self.tableView.reloadData()           //local search work

            self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.searchViewWidthConstraint.constant = 0
                self.btnCancel.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.searchView.isHidden = true
            })
        }
    
    
    enum SelectTab {
        case Discover
        case RecentlyViewed
    }
}
// Search
extension VehiclesController {
    @IBAction func cancelSearch(_ sender: Any) {
        self.closeSearchBar()
       
    }
    
    @IBAction func showSearch(_ sender: Any) {
    
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchViewWidthConstraint.constant = self.view.bounds.width
            self.searchView.isHidden = false
            self.btnCancel.isHidden = false
            self.view.layoutIfNeeded()
            self.tvSearch.becomeFirstResponder()
        }, completion: nil)
    }
}

extension VehiclesController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            view.endEditing(true)
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        resetDataSource()
        self.view.endEditing(true)
        return true
    }
}

extension VehiclesController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        
        if let headerCell = cell as? VehicleHeaderCell {
            if isForReview {
               if selectedTab == .Discover {
                headerCell.setData(text: "Latest car reviews and ratings by the customers")
               } else {
                headerCell.setData(text: "Most popular car reviews")
               }
              
            } else {
                if slug == Slugs.LUXURY_MARKET.rawValue {
                    headerCell.setData(text: "The specification and prices of the latest luxury cars.")
                } else if slug == Slugs.THE_OUTLET_MALL.rawValue {
                    headerCell.setData(text: "The Best Deals you could ever look for")
                } else if slug == Slugs.APPROVED_PRE_OWNED.rawValue {
                    headerCell.setData(text: "For those who are looking for peace of mind")
                } else if slug == Slugs.CLASSIC_CARS.rawValue  {
                    headerCell.setData(text: "Oldies but Goldies")
                }
            }
        } else if let vehicleCell = cell as? VehicleCell {
            vehicleCell.setData(slug: self.slug ?? "", vehicleModel: vehicles[indexPath.row], isForReview: self.isForReview)
        } else if let _ = cell as? LoadingCell {
//            if !isLoading && canLoadMore {
//              self.getVehicles()
//            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells[section].count == -1 {
            if cells[section].identifier == VehicleCell.identifier {
                return vehicles.count
            }
        } else if cells[section].identifier == LoadingCell.identifier {
            return 0//canLoadMore ? 1 : 0
        } else {
             return cells[section].count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.moveAhead(index: indexPath.row)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        heightDictionary[indexPath.row] = cell.frame.size.height
        

        checkForMoreRecords(indexNo: indexPath.row)
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
    }
    
    
    func checkForMoreRecords(indexNo : Int) {
        
        if indexNo == (vehicles.count) - 1 {
            if (vehicles.count) < LastService.totalCount {
                
                offset = offset+limit
                
                getVehicles()
            }else{
                self.tableView.tableFooterView = nil
            }
        }
        
    }
    
}


extension VehiclesController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "Vehicles will show up here, so you can easily view them here later"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Vehicles found"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension VehiclesController: FilterControllerDelegate {
    func didTapOnAddBrand() {
    
    }
    
    func didTapOnCountrySelection() {
    
    }
    
    func didTapOnApplyFilter() {
        self.didApplyFilter = true
        
        resetDataSource()
    }
    func didTapOnClearFilter() {
        self.didClearFilter = true
        offset = 0
        self.sortedVehicles.removeAll()
        self.vehicles.removeAll()
        self.tableView.tableFooterView = nil
    }
}

extension VehiclesController: SortModesDelegates {
    func didChangeMode(sortMode: Any) {
        if isForReview {
            self.reviewsSortModesView.animHide()
            if let reviewsSelectedMode = sortMode as? ReviewsSortModes, self.reviewsSelectedMode != reviewsSelectedMode  {
                self.reviewsSelectedMode = reviewsSelectedMode
                //self.applyReviewsSorting()
                resetDataSource()
            }
        } else {
            self.sortModesView.animHide()
            if let vehicleSortModes = sortMode as? VehicleSortModes, self.vehicleSelectedMode != vehicleSortModes {
                self.vehicleSelectedMode = vehicleSortModes
                //self.appyVehiclesSorting()
                resetDataSource()
            }
        }
        
        
        
    }
}
    
extension VehiclesController: EventPerformDelegate {
    func didActionPerformed(eventName: EventName, data: Any) {
        if eventName == .didCountrySelected {
            self.getVehicles()
        }
    }
}

