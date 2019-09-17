//
//  CompareByCarView.swift
 import Foundation
import DZNEmptyDataSet

class CompareByCarView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    var cells: [CellWithoutHeight] = [(CompareCarCell.identifier,0)]
    var vehicles: [VehicleBase] = []
    var selectedVehicles: [Int] = []

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let customTextField = UINib(nibName: "CompareByCarView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        customTextField.frame = self.bounds
        addSubview(customTextField)
        
        self.customizeApperence()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func customizeApperence() {
        self.prepareTableAndCollectionview()
        self.getVehicles()
    }
    
    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func prepareTableAndCollectionview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        self.collectView?.register(UINib(nibName: SelectedCarsCell.identifier, bundle: nil), forCellWithReuseIdentifier: SelectedCarsCell.identifier)
        collectView?.delegate = self
        collectView?.dataSource = self
    }
    
    func getVehicles() {
        APIManager.sharedInstance.getVehicles(params: ["category_id" : Constants.LUXURY_MARKET_CATEGORY_ID], success: { (result) in
            self.vehicles = result
            self.tableView.reloadData()
        }) { (error) in
            print("")
        }
    }
    
    func moveToResult() {
        let compareCarResult = CompareResultController.instantiate(fromAppStoryboard: .Consultant)
        let selectedCarIds = selectedVehicles.map({$0.description}).joined(separator: ",")
        compareCarResult.carId = selectedCarIds
        Utility().topViewController()?.navigationController?.pushViewController(compareCarResult, animated: true)
    }
    
    @IBAction func tappedOnCompareAll() {
        self.moveToResult()
    }
}


extension CompareByCarView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        
        if let compareCarCell = cell as? CompareCarCell {
            compareCarCell.delegate = self
            compareCarCell.setData(vehicleDetail: self.vehicles[indexPath.row],
                                   isSelected: selectedVehicles.filter({$0 == (self.vehicles[indexPath.row].id ?? 0)}).count > 0)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vehicles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension CompareByCarView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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


extension CompareByCarView: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: SelectedCarsCell.identifier, for: indexPath) as! SelectedCarsCell
        cell.setData(imageURL: self.vehicles.filter({$0.id == self.selectedVehicles[indexPath.row]}).first?.media?.first?.file_url ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedVehicles.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
    }
    
}

extension CompareByCarView: CompareCarDelegates {
    func didCarSelected(vehicleDetail: VehicleBase) {
        let vehicleId = vehicleDetail.id ?? -1
        
        if let index = selectedVehicles.index(where: {$0 == vehicleId}) {
            selectedVehicles.remove(at: index)
        } else {
            selectedVehicles.append(vehicleId)
        }
        
        self.tableView.reloadData()
        self.collectView.reloadData()
    }
}



