//
//  MarketSelectionController.swift
 import UIKit

class MarketSelectionController: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var cells: [CellWithoutHeight] = [
                         (MarketCell.identifier,-1)]
    var subCateogories: [CategoryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        presentEnableNotificationController()
        
        self.customizeApperence()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func customizeApperence() {
        self.prepareTableview()
        
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
   
    
    func presentEnableNotificationController() {
        if AppStateManager.sharedInstance.isUserLoggedIn() && (!(AppStateManager.sharedInstance.userData?.user?.push_notification?.value() ?? false)) {
            let notificationsController = StayUpdatedPopupController.instantiate(fromAppStoryboard: .Popups)
            notificationsController.modalPresentationStyle = .overCurrentContext
            notificationsController.modalTransitionStyle = .crossDissolve
            present(notificationsController, animated: true)
        }
    }
    
    func moveAhead(index: Int) {
        let vehicleController = VehiclesController.instantiate(fromAppStoryboard: .LuxuryMarket)
        vehicleController.categoryId = self.subCateogories[index].id ?? 0
        vehicleController.navTitle = self.subCateogories[index].name ?? ""
        vehicleController.slug = self.subCateogories[index].slug
        self.navigationController?.pushViewController(vehicleController, animated: true)
    }
}


extension MarketSelectionController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        
        if let marketCell = cell as? MarketCell {
            marketCell.setData(category: subCateogories[indexPath.row])
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells[section].count == -1 {
            if cells[section].identifier == MarketCell.identifier {
                return subCateogories.count
            }
        } else {
           return cells[section].count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveAhead(index: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

