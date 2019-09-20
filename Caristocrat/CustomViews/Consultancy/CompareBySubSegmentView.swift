
//
//  CompareBySegmentView.swift
 import Foundation
import DZNEmptyDataSet

class CompareBySubSegmentView: UIView {
    
    var cells: [CellWithSection] = [(SegmentCell.identifier,1, SubSegmentHeaderCell.identifier)]
    var segments: [BodyStyleModel] = []
    
    private var selectedSegment: (section: Int, row: Int)?
    var isComparisonSubscribed = false
    var shouldShowSubscribed = false
    
    @IBOutlet weak var tableView:UITableView!
    var groups = [Group]()
    var groupDatas = [GroupData]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let compareBySegmentView = UINib(nibName: "CompareBySubSegmentView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        compareBySegmentView.frame = self.bounds
        addSubview(compareBySegmentView)
        
        self.customizeAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func customizeAppearance() {
        self.prepareTableview()
        self.checkComparisionPayment()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier:  cell.headerIdentifier)
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setBodyStyleData(data: BodyStyleModel) {
        guard let childSegments = data.childSegment else {
            return
        }
        for curBsd in childSegments {
            guard let bsdName = curBsd.name else {
                continue
            }
            
            if let start = bsdName.index(of: "("), let end = bsdName.index(of: ")") {
                let md = String(bsdName[..<start]).trimmingCharacters(in: .whitespaces)
                let smd = String(bsdName[bsdName.index(start, offsetBy: 1)  ..< end])
                var grpIdx = -1
                //if segments.count > 0 {
                    for idx in (0..<groups.count) {
                        if groups[idx].group == md {
                            grpIdx = idx
                            break
                        }
                    }
                //}
                if grpIdx == -1 {
                    //var bsd = data
                    //bsd.childSegment = [ChildSegment]()
                    //bsd.group = bsdName
                    //segments.append(bsd)
                    groups.append(Group(group: md, checked: false))
                }
                groupDatas.append(GroupData(id: curBsd.id ?? 0, group: md, version: smd))
                
            } else {
                //groups.append(bsdName)
            }
        }
        
        self.tableView.reloadData()
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
    
    func moveToResult(section: Int,row: Int) {
        let subGroupData = self.groupDatas.filter{$0.group == self.groups[section].group}
        let compareCarResult = CompareResultController.instantiate(fromAppStoryboard: .Consultant)
        compareCarResult.segmentId = subGroupData[row].id
        compareCarResult.navtitle = "\(subGroupData[row].group) (\(subGroupData[row].version) )"
        Utility().topViewController()?.navigationController?.pushViewController(compareCarResult, animated: true)
    }
    
}

extension CompareBySubSegmentView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SegmentCell.identifier)
        
        if let segmentCell = cell as? SegmentCell {
            let subGroupData = self.groupDatas.filter{$0.group == groups[indexPath.section].group}
            segmentCell.setData(groupData: subGroupData[indexPath.row])
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !groups[section].isChecked {
            return 0
        }
        
        return self.groupDatas.filter{$0.group == groups[section].group}.count
        // segments[section].childSegment?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSegment = (indexPath.section, indexPath.row)
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
    
    func showResult() {
        if isComparisonSubscribed {
            guard let segment = self.selectedSegment else { return }
            self.moveToResult(section: segment.section, row: segment.row)
        } else {
            //show alert
            let subscribeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ComparisonSubscribeViewController") as! ComparisonSubscribeViewController
            subscribeViewController.modalPresentationStyle = .overCurrentContext
            subscribeViewController.modalTransitionStyle = .crossDissolve
            subscribeViewController.subscribedSuccessfully = {
                self.isComparisonSubscribed = true
                if let segment = self.selectedSegment {
                    self.moveToResult(section: segment.section, row: segment.row)
                }
            }
            Utility().topViewController()?.present(subscribeViewController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: SubSegmentHeaderCell.identifier)
        
        if let cell = cell as? SubSegmentHeaderCell {
            cell.setData(group: self.groups[section], delegate: self, forRow: section, isExpanded: self.groups[section].isChecked)
        }
        
        return cell
    }
    
}

extension CompareBySubSegmentView: EventPerformDelegate {
    func didActionPerformed(eventName: EventName, data: Any) {
        if eventName == .didTapOnCollapseExpand {
            if self.groups[data as! Int].isChecked  {
                self.groups[data as! Int].isChecked = false
            } else {
                self.groups[data as! Int].isChecked = true
            }
            
            self.tableView.reloadData()
        }
    }
}



