
//
//  CompareBySegmentView.swift
 import Foundation
import DZNEmptyDataSet

class CompareBySegmentView: UIView {
    
    var cells: [CellWithSection] = [(SegmentCell.identifier, 1, SegmentHeaderCell.identifier)]
    var segments: [BodyStyleModel] = []
    
    private var selectedSegment: Int!
    var isComparisonSubscribed = false
    var shouldShowSubscribed = false

    @IBOutlet weak var tableView:UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let compareBySegmentView = UINib(nibName: "CompareBySegmentView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        compareBySegmentView.frame = self.bounds
        addSubview(compareBySegmentView)
        
        self.customizeAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func customizeAppearance() {
        self.prepareTableview()
        self.getBodyStyle()
        self.checkComparisionPayment()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
            self.tableView.register(UINib(nibName: cell.headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier:  cell.headerIdentifier)
        }
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func getBodyStyle() {
        APIManager.sharedInstance.getBodyStyles(success: { (result) in
            self.segments = result
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    func checkComparisionPayment() {
        
        guard let userId = AppStateManager.sharedInstance.userData?.user?.id else { return }
        
        APIManager.sharedInstance.checkComparisionSubscription(userId: "\(userId)", success: { (model: [ComparisionPaymentCheckModel]) in
                //Already subsribed
                self.isComparisonSubscribed = model.count > 0
        }, failure: { (error) in
            print(error)
        }, showLoader: false)
    }
    
    func moveToResult(row: Int) {
        let compareCarResult = CompareResultController.instantiate(fromAppStoryboard: .Consultant)
        compareCarResult.segmentId = self.segments[row].id ?? 0
        compareCarResult.navtitle = self.segments[row].name ?? "Results"
        Utility().topViewController()?.navigationController?.pushViewController(compareCarResult, animated: true)
    }
    
}

extension CompareBySegmentView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func showResult() {
        if isComparisonSubscribed {
            guard let segmentId = self.selectedSegment else { return }
            self.moveToResult(row: segmentId)
        } else {
            //show alert
            let subscribeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ComparisonSubscribeViewController") as! ComparisonSubscribeViewController
            subscribeViewController.modalPresentationStyle = .overCurrentContext
            subscribeViewController.modalTransitionStyle = .crossDissolve
            subscribeViewController.subscribedSuccessfully = {
                self.isComparisonSubscribed = true
                if let segmentId = self.selectedSegment {
                    self.moveToResult(row: segmentId)
                }
            }
            Utility().topViewController()?.present(subscribeViewController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return segments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: SegmentHeaderCell.identifier)
        
        if let cell = cell as? SegmentHeaderCell {
            cell.setData(bodyStyle: self.segments[section], delegate: self, forRow: section, isExpanded: segments[section].isChecked)
        }
        
        return cell
    }
    
}

extension CompareBySegmentView: EventPerformDelegate {
    func didActionPerformed(eventName: EventName, data: Any) {
        if eventName == .didTapOnCollapseExpand {
            self.selectedSegment = data as? Int
            
            if (self.segments[selectedSegment].childSegment?.count ?? 0 > 0) {
                let compareCarSubSegment = CompareCarSubController.instantiate(fromAppStoryboard: .Consultant)
                compareCarSubSegment.segment = self.segments[selectedSegment]
                Utility().topViewController()?.navigationController?.pushViewController(compareCarSubSegment, animated: true)
            } else {
                if AppStateManager.sharedInstance.isUserLoggedIn() {
                    showResult()
                } else {
                    shouldShowSubscribed = true
                    let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                    signinController.isGuest = true
                    signinController.guestLabelText = "CANCEL"
                    Utility().topViewController()?.present(signinController, animated: true, completion: nil)
                }
            }
        }
    }
}



