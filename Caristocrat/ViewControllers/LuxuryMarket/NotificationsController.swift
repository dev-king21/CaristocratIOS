//
//  NotificationsController.swift
 import UIKit
import DZNEmptyDataSet

class NotificationsController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var notifications: [NotificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getNotifications()
        self.customizeApperence()
    }
    
    func customizeApperence() {
        self.prepareTableview()
        
    }
    
    func getNotifications() {
        APIManager.sharedInstance.getNotifications(success: { (result) in
            self.notifications = result
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    func prepareTableview() {
        self.tableView.register(UINib(nibName: NotificationCell.identifier, bundle: nil), forCellReuseIdentifier: NotificationCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
    }
    
    func moveToCarDetail(index: Int) {
        let myTradeInDetailController = MyTradeInDetailController.instantiate(fromAppStoryboard: .Login)
        myTradeInDetailController.refId = notifications[index].ref_id ?? -1

        if "\(self.notifications[index].action_type ?? 0)" == TradeEvaluateCarType.trade.rawValue {
            myTradeInDetailController.detailType = .trade
        }
        else{
            myTradeInDetailController.detailType = .evaluate
        }
        
        self.navigationController?.pushViewController(myTradeInDetailController, animated: true)
    }
    
    
}

extension NotificationsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier) as? NotificationCell {
            cell.setData(notification: notifications[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveToCarDetail(index: indexPath.row)


    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NotificationsController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "Notifications will show up here, so you can easily view them here later"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Notifications found"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

