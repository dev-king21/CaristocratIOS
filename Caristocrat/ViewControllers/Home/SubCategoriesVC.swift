//
//  AutoLifeVC.swift
 import UIKit
import TableViewDragger

class SubCategoriesVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private var dragView: UIView?
    var dragger: TableViewDragger!
    var subCategoryOrder: [String: Any] = [:]
    var subCateogories: [CategoryModel] = []
    var categoryId: Int = 0
    var type: Int?
    
    var statusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden : Bool {
        return statusBarHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeApperence()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func customizeApperence() {
        self.prepareTableview()
    }
    
    func prepareTableview() {
        sortCategory()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.dragger = TableViewDragger(tableView: self.tableView)
        self.dragger.dataSource = self
        self.dragger.delegate = self
        self.dragger.scrollVelocity = 0.1
        self.dragger.alphaForCell = 1
        self.dragger.isHiddenOriginCell = true
    }
    
    func sortCategory() {
        subCategoryOrder = AppStateManager.sharedInstance.subCategoryOrder
        // Filter Subcategory by current Category. It is for optimization
        let subCategoryByCat = AppStateManager.sharedInstance.subCategoryOrder.filter({
            ($0.value as! String).split(separator: "-")[0] == categoryId.description
        })
        let sortedOrder = Array(subCategoryByCat.keys).sorted(by: <)
        for item in sortedOrder {
            if let value = subCategoryByCat[item] as? String, let catIndex = subCateogories.index(where: {$0.id == Int(value.split(separator: "-")[1])}), let toIndex = Int(item) {
                subCateogories.swapAt(catIndex, toIndex)
            }
        }
    }
    
    func submitInteraction(index: Int) {
//        APIManager.sharedInstance.carInteraction(car_id: subCateogories[index].id ?? 0,
//                                                 interactionType: .SubCat, success: { (result) in
//
//        }) { (error) in
//
//        }
    }
    
    func moveAhead(index: Int) {
        if type == CategoryType.Consultant.rawValue {
            switch (Slugs(rawValue: subCateogories[index].slug ?? "") ?? .COMPARE) {
            case .COMPARE:
                self.navigationController?.pushViewController(CompareCarController.instantiate(fromAppStoryboard: .Consultant), animated: true)
            case .EVALUATE_MY_CAR:
              //  if AppStateManager.sharedInstance.isUserLoggedIn()  {
                    let controller = SelectCarController.instantiate(fromAppStoryboard: .Home)
                    controller.forEvaluation = true
                    self.navigationController?.pushViewController(controller, animated: true)
//                } else {
//                    AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see the list of your cars and get them evaluated. Do you want to signin?") {
//                        let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
//                        signinController.isGuest = true
//                        self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
//                    }
//                }
            case .VIN_CHECK:
                Utility.showInformationWith(message: Messages.ImplementLater.rawValue)
                break
            case .ASK_FOR_CONSULTANCY:
                let controller = AskForConsultancyController.instantiate(fromAppStoryboard: .LuxuryMarket)
                self.navigationController?.pushViewController(controller, animated: true)
                break
            case .REVIEWS:
                 self.moveToVehiclesVC()
            default:
                Utility.showInformationWith(message: Messages.ImplementLater.rawValue)
                break
            }
            
            
        } else {
            let autoDetailVC = DetailVC.instantiate(fromAppStoryboard: .Home)
            autoDetailVC.categoryId = subCateogories[index].id ?? 0
            autoDetailVC.navTitle = subCateogories[index].name ?? ""
            
            autoDetailVC.removeUnreadCount = { [weak self] in
                self?.subCateogories[index].unreadCount = 0
                self?.tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(autoDetailVC, animated: true)
         //   subCateogories[index].unreadCount = 0
            self.tableView.reloadData()
        }
        
    }
    
    func moveToVehiclesVC() {
        let vehicleController = VehiclesController.instantiate(fromAppStoryboard: .LuxuryMarket)
        vehicleController.categoryId = Constants.LUXURY_MARKET_CATEGORY_ID
        vehicleController.navTitle = "Reviews"
        vehicleController.isForReview = true
        vehicleController.slug = Slugs.LUXURY_MARKET.rawValue
        self.navigationController?.pushViewController(vehicleController, animated: true)
    }
}

extension SubCategoriesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoryCell.identifier) as! SubCategoryCell
        cell.titleLabel.text = indexPath.row.description
        cell.setData(category: subCateogories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.layer.transform = CATransform3DMakeScale(0.4,0.1,1)
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1.0,1.0,1)
//        },completion: { finished in
//
//        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCateogories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveAhead(index: indexPath.row)
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

extension SubCategoriesVC: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        print("Before "+subCategoryOrder.description)
        let cat = subCateogories[indexPath.row]
        subCategoryOrder.updateValue("\(categoryId)-\(cat.id ?? 0)", forKey: String(newIndexPath.row))
        subCategoryOrder.updateValue("\(categoryId)-\(subCateogories[newIndexPath.row].id ?? 0)", forKey: String(indexPath.row))
        subCateogories.remove(at: indexPath.row)
        subCateogories.insert(cat, at: newIndexPath.row)
        tableView.moveRow(at: indexPath, to: newIndexPath)
        AppStateManager.sharedInstance.subCategoryOrder = subCategoryOrder
        print("After "+subCategoryOrder.description)
        return true
    }

}



