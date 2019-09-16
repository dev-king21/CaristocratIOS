//
//  AutoLifeVC.swift
 import UIKit
import TableViewDragger

class CategoriesVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    var dragger: TableViewDragger!
    var categories: [CategoryModel] = []
    var categoryOrder: [String: Any] = [:]
    var needToRefresh = false
    var regions: [Region] = []
    var selectedRegion: Int?
    
    var isFirstTime:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeApperence()
        
        self.showRegionDialogIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
        if needToRefresh {
            needToRefresh = false
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
        }

        if(self.categories.count > 0){
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
        }
        
        self.setProfilePicture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getCategories(showLoader: true)
        
//        if isFirstTime {
//            self.getCategories(showLoader: true)
//            isFirstTime = false
//        }else{
//            self.getCategories(showLoader: false)
//        }
        
        
        // This Delay because when user come from background notificaiton controller automatically dismiss after few seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            if AppStateManager.sharedInstance.refId != nil {
                let myTradeInDetailController = MyTradeInDetailController.instantiate(fromAppStoryboard: .Login)
                myTradeInDetailController.refId = AppStateManager.sharedInstance.refId
                self.present(myTradeInDetailController, animated: true, completion: nil)
                AppStateManager.sharedInstance.refId = nil
            }
            
           /* if AppStateManager.sharedInstance.urlData != nil {
                if let urlData = AppStateManager.sharedInstance.urlData,let type = urlData["type"], let id = urlData["id"] {
                    if type == "10" {
                        let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
                        vehicleController.carId = Int(id)
                        Utility().topViewController()?.navigationController?.pushViewController(vehicleController, animated: true)
                    } else {
                        let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
                        furtherDetailVC.newsId = Int(id) ?? -1
                        Utility().topViewController()?.navigationController?.pushViewController(furtherDetailVC, animated: true)
                    }
                    
                     AppStateManager.sharedInstance.urlData = nil
                }
            }*/
        }
    }
    
    func customizeApperence() {
        self.prepareTableview()
        self.setObservers()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    @objc func setProfilePicture() {
//        if let userData = AppStateManager.sharedInstance.userData?.user {
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//            let button: UIButton = UIButton(type: UIButtonType.custom)
//            imageView.kf.setImage(with: URL(string: userData.details?.image_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"), options: nil, progressBlock: { (progress, val) in
//            }, completionHandler: { (image, error, type, url) in
//                button.setImage(imageView.image, for: UIControlState.normal)
//                //                button.setBackgroundImage(UIImage(named: "top_circle_border"), for: .normal)
//                button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
//
//                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//                button.imageView?.contentMode = .scaleAspectFill
//                button.imageView?.isCircular = true
//                button.addTarget(self, action: #selector(self.moveToProfileController), for: .touchUpInside)
//                let barButton = UIBarButtonItem(customView: button)
//                let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 35)
//                currWidth?.isActive = true
//                let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 35)
//                currHeight?.isActive = true
//                self.navigationItem.rightBarButtonItem?.width = 15
//                self.navigationItem.rightBarButtonItem = barButton
//            })
//        }
        
        let navBarButton = ProfileNavBar.instanceFromNib() as! ProfileNavBar
        
        navBarButton.btnNavBar.addTarget(self, action: #selector(self.moveToProfileController), for: .touchUpInside)
        if let userData = AppStateManager.sharedInstance.userData?.user {
            if let image_url = userData.details?.image_url {
                navBarButton.imgProfile.kf.setImage(with: URL(string: image_url), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            } else {
                navBarButton.imgProfile.image = UIImage(named: "image_placeholder")
            }
        }
        let barButtonItem = UIBarButtonItem(customView: navBarButton)
        barButtonItem.width = 40.0
        self.navigationItem.rightBarButtonItem?.width = 15
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.setNeedRefresh),
            name: NSNotification.Name(rawValue: Events.onNewsSeen.rawValue),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.setProfilePicture),
            name: NSNotification.Name(rawValue: Events.onProfileUpdate.rawValue),
            object: nil)
    }
   
    func prepareTableview() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.dragger = TableViewDragger(tableView: self.tableView)
        self.dragger.dataSource = self
        self.dragger.delegate = self
        self.dragger.scrollVelocity = 1
        self.dragger.alphaForCell = 1
        self.dragger.isHiddenOriginCell = true
    }
    
    func sortCategory() {
//     for item in categories {
//         if let val = categoryOrder[String(describing: item.id)] as? Int {
//
//         }
//     }

       categoryOrder = AppStateManager.sharedInstance.categoryOrder
       let sortedOrder = Array(categoryOrder.keys).sorted(by: <)
        for item in sortedOrder {
            if let catId = categoryOrder[item] as? Int, let catIndex = categories.index(where: {$0.id == catId}), let toIndex = Int(item) {
                categories.swapAt(catIndex, toIndex)
            }
        }
    }
    
    @objc func getCategories(showLoader:Bool = true) {
        //self.tableView.isHidden = true
        APIManager.sharedInstance.getCategories(showLoader:showLoader ,success: { (result) in
            self.categories = result
            self.sortCategory()
            self.tableView.reloadData()
            //self.tableView.isHidden = false
        }) { (error) in
            
        }
    }
    
    @objc func setNeedRefresh() {
        self.needToRefresh = true
        self.getCategories()
    }
    
    func applyOrder() {
        
    }
    
    @objc func moveToProfileController() {
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            let profileController = ProfileVC.instantiate(fromAppStoryboard: .Login)
            let navController = UINavigationController(rootViewController: profileController)
            present(navController, animated: true, completion: nil)
        } else {
            AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see your Profile. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
        }
    }
    
    func moveAhead(forRow: Int) {
//        if categories[forRow].type == CategoryType.News.rawValue || categories[forRow].type == CategoryType.Consultant.rawValue {
//            if let subcategories = categories[forRow].subCategories, subcategories.count > 0 {
//                let subCategoriesVC = SubCategoriesVC.instantiate(fromAppStoryboard: .Home)
//                subCategoriesVC.subCateogories = subcategories
//                subCategoriesVC.categoryId = categories[forRow].id ?? 0
//                subCategoriesVC.navTitle = categories[forRow].name ?? ""
//                subCategoriesVC.type = categories[forRow].type ?? 0
//                self.navigationController?.pushViewController(subCategoriesVC, animated: true)
//            } else {
//                let autoDetailVC = DetailVC.instantiate(fromAppStoryboard: .Home)
//                autoDetailVC.navTitle = categories[forRow].name ?? ""
//                autoDetailVC.categoryId = categories[forRow].id ?? 0
//                self.navigationController?.pushViewController(autoDetailVC, animated: true)
//            }
//        } else if categories[forRow].type == CategoryType.LuxuryMarket.rawValue {
//            let marketSelectionController = MarketSelectionController.instantiate(fromAppStoryboard: .LuxuryMarket)
//            marketSelectionController.subCateogories = categories[forRow].subCategories ?? []
//            self.navigationController?.pushViewController(marketSelectionController, animated: true)
//        }
        
        if categories[forRow].type ?? 0 > CategoryType.Consultant.rawValue {
            Utility.showInformationWith(message: Messages.ImplementLater.rawValue)
            return
        }
        
        if categories[forRow].type == CategoryType.LuxuryMarket.rawValue {
            let marketSelectionController = MarketSelectionController.instantiate(fromAppStoryboard: .LuxuryMarket)
            marketSelectionController.subCateogories = categories[forRow].subCategories ?? []
            self.navigationController?.pushViewController(marketSelectionController, animated: true)
        } else if let subcategories = categories[forRow].subCategories, subcategories.count > 0 {
            let subCategoriesVC = SubCategoriesVC.instantiate(fromAppStoryboard: .Home)
            subCategoriesVC.subCateogories = subcategories
            subCategoriesVC.categoryId = categories[forRow].id ?? 0
            subCategoriesVC.navTitle = categories[forRow].name ?? ""
            subCategoriesVC.type = categories[forRow].type ?? 0
            self.navigationController?.pushViewController(subCategoriesVC, animated: true)
        } else {
            let autoDetailVC = DetailVC.instantiate(fromAppStoryboard: .Home)
            autoDetailVC.navTitle = categories[forRow].name ?? ""
            autoDetailVC.categoryId = categories[forRow].id ?? 0
            self.navigationController?.pushViewController(autoDetailVC, animated: true)
        }
    }
    
    func submitInteraction(index: Int) {
        APIManager.sharedInstance.carInteraction(car_id: categories[index].id ?? 0,
                                                 interactionType: .MainCat, success: { (result) in
                                                    
        }) { (error) in
            
        }
    }
    
    @IBAction func tappedOnProfileButton() {
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            let profileController = ProfileVC.instantiate(fromAppStoryboard: .Login)
            present(profileController, animated: true, completion: nil)
        } else {
            AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see your Profile. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tappedOnNotificationButton() {
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            let notificationsController = NotificationsController.instantiate(fromAppStoryboard: .Home)
            self.navigationController?.pushViewController(notificationsController, animated: true)
        } else {
            AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see your Notifications. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
        }
    }
    
    func showRegionDialogIfNeeded() {
        if let _ = AppStateManager.sharedInstance.userData {
            if let _ = AppStateManager.sharedInstance.userData?.user?.details?.region {
                return
            } else {
                self.getRegions()
            }
        }
    }
    
    func getRegions() {
        if regions.count == 0 {
            APIManager.sharedInstance.getCountries(success: { (result) in
                self.regions = result
                Utility().showSelectionPopup(title: "Regions", items: self.regions.map({$0.name.unWrap}), tapClouser: { (position, tag) in
                    self.selectedRegion = self.regions[position].id.unWrap
                    AppStateManager.sharedInstance.userData?.user?.details?.region = self.regions[position]
                    self.saveRegion()
                })
            }) { (error) in
                
            }
        } else {
            Utility().showSelectionPopup(title: "Regions", items: self.regions.map({$0.name.unWrap}), tapClouser: { (position, tag) in
                self.selectedRegion = self.regions[position].id.unWrap
                self.saveRegion()
            })
        }
    }
    
    func saveRegion() {
        Utility.startProgressLoading()
        APIManager.sharedInstance.updateProfile(params: ["region_id": self.selectedRegion?.description ?? ""], images: [:], success: { (result) in
            Utility.stopProgressLoading()
        }, failure: { (error) in
            Utility.stopProgressLoading()
        }, showLoader: true)
    }

    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CategoriesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as? CategoryCell {
            cell.setData(category: categories[indexPath.row], index: indexPath.row)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveAhead(forRow: indexPath.row)
        self.submitInteraction(index: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width
        return (width / 4) * 2.5
    }
    
}

extension CategoriesVC: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        print("Before "+categoryOrder.description)
        let cat = categories[indexPath.row]
        categoryOrder.updateValue(cat.id ?? 0, forKey: String(newIndexPath.row))
        categoryOrder.updateValue(categories[newIndexPath.row].id ?? 0, forKey: String(indexPath.row))
        categories.remove(at: indexPath.row)
        categories.insert(cat, at: newIndexPath.row)
        tableView.moveRow(at: indexPath, to: newIndexPath)
        AppStateManager.sharedInstance.categoryOrder = categoryOrder
        print("After "+categoryOrder.description)
        return true
    }
}

extension CategoriesVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

