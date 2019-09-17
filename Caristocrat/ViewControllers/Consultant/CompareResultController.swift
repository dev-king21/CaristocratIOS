//
//  CompareResultController.swift
 import UIKit
import SpreadsheetView

class CompareResultController: BaseViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    @IBOutlet weak var  spreadsheetView: SpreadsheetView!
    var allVehicles: [VehicleBase] = []
    var allSpecs: [[Specs]] = []
    var carId: String?
    var segmentId: Int?
    
    var navtitle = "Results"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.title = navtitle
        
        var label = UILabel()
        
        if let font = UIFont(name: FontsType.Heading.rawValue, size: 24){
            label.font = font
        }
        
        label.text = navtitle
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        self.navigationItem.titleView = label
        
        self.customizeAppearance()
    }
    
    func customizeAppearance() {
        self.getVehicles()
    }
    
    func configureSpreadSheet() {
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.alwaysBounceVertical = false
        spreadsheetView.alwaysBounceHorizontal = false
        spreadsheetView.bounces = false
        spreadsheetView.showsVerticalScrollIndicator = false
        spreadsheetView.showsHorizontalScrollIndicator = false
        spreadsheetView.isDirectionalLockEnabled = true
        spreadsheetView.register(UINib(nibName: String(describing: CompareResultCarImageCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CompareResultCarImageCell.self))
        spreadsheetView.register(UINib(nibName: String(describing: HeaderCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        spreadsheetView.register(UINib(nibName: String(describing: CompareResultCarAttributesCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CompareResultCarAttributesCell.self))

        spreadsheetView.backgroundColor = .clear
        
        let hairline = 1 / UIScreen.main.scale
        spreadsheetView.intercellSpacing = CGSize(width: hairline, height: hairline)
        spreadsheetView.gridStyle = .solid(width: hairline, color: .lightGray)
        spreadsheetView.circularScrolling = CircularScrolling.Configuration.none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
    
    func getVehicles() {
        var params : Parameters = ["category_id" : Constants.LUXURY_MARKET_CATEGORY_ID]
        
        //for required data only
        params["service_type"] = "1"
        
        if let carId = self.carId {
            params["car_ids"] = carId
        } else if let segmentId = self.segmentId {
            params["car_sub_type"] = segmentId
        }
        
        APIManager.sharedInstance.getVehicles(params: params, success: { (result) in
            self.allVehicles = result
            self.storeSpecs()

            if(self.allVehicles.count == 1){
                Utility.showInformationWith(message: "There is not enough car to compare with")
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            if self.allVehicles.count > 1 {
                self.configureSpreadSheet()
            } else {
                Utility.showInformationWith(message: Messages.NoCarsFound.rawValue)
                self.navigationController?.popViewController(animated: true)
            }
            
        }) { (error) in
            print("")
        }
    }
    
    func storeSpecs() {
        self.allSpecs.removeAll()

        for item in self.allVehicles {
            var specs: [Specs] = []
            specs += item.limited_edition_specs_array?.dimensions_Weight ?? []
            specs += item.limited_edition_specs_array?.seating_Capacity ?? []
            specs += item.limited_edition_specs_array?.drivetrain ?? []
            specs += item.limited_edition_specs_array?.engine ?? []
            specs += item.limited_edition_specs_array?.performance ?? []
            specs += item.limited_edition_specs_array?.transmission ?? []
            specs += item.limited_edition_specs_array?.brakes ?? []
            specs += item.limited_edition_specs_array?.suspension ?? []
            specs += item.limited_edition_specs_array?.wheels_Tyres ?? []
            specs += item.limited_edition_specs_array?.fuel ?? []
            specs += item.limited_edition_specs_array?.emission ?? []
            specs += item.limited_edition_specs_array?.warranty_Maintenance ?? []

            self.allSpecs.append(specs)
        }
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return (self.allSpecs.first?.count ?? 0) + 2
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return allVehicles.count + 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 150
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if row == 0 {
          return 75
        }
        return 150
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
       
        return 1
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let actualRow = indexPath.row - 1
        let actualColumn = indexPath.column - 1
        
        if indexPath.row == 0 {
            if let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as? HeaderCell {
                if indexPath.column == 0 {
                    cell.titleLabel.text = "Cars"
                    cell.titleLabel.backgroundColor = .white
                } else if actualColumn == (self.allSpecs.first?.count ?? 0) {
                    cell.titleLabel.text = "Remaining Life Cycle"
                } else {
                    var name = self.allSpecs.first?[actualColumn].name ?? ""
                    name = name.replacingOccurrences(of: "_", with: " ")
                    name = name.uppercased()
                    cell.titleLabel.text = name
                }
                
                return cell
            }
        }
        
        if indexPath.column == 0 {
            if let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: CompareResultCarImageCell.self), for: indexPath) as? CompareResultCarImageCell {
                cell.setData(vehicleDetail: self.allVehicles[actualRow])
                return cell
            }
        }
        
        
        if let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: CompareResultCarAttributesCell.self), for: indexPath) as? CompareResultCarAttributesCell {
            
            if actualColumn == (self.allSpecs.first?.count ?? 0) {
                if let lifeCycle = self.allVehicles[actualRow].life_cycle {
                    let currentYear = Utility.getDataComponent().year ?? 0
                    let years = lifeCycle.components(separatedBy: "-")
                    if years.count > 0 {
                      let endYear = Int(years[1]) ?? 0
                        let remaingLifeCycle = (endYear - currentYear)
                        cell.lblName.borderWidth = 0
                        if remaingLifeCycle > 0  {
                            cell.lblName.text = "    \(remaingLifeCycle) Year(s)    "
                        } else {
                            cell.lblName.text = "    < 1 Year    "
                        }
                        cell.lblName.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
                    }
                } else {
                     cell.lblName.borderWidth = 0
                     cell.lblName.text = "    -    "
                     cell.lblName.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
                }
            } else { // Other Columns
                let unit = (Constants.Units[(self.allSpecs.first?[actualColumn].name ?? "")]) ?? ""
                cell.lblName.text = "      "+(self.allSpecs[actualRow][actualColumn].value ?? "-") + (unit.isEmpty ? "" : " " + unit) + "      "
                cell.lblName.restartLabel()
                if self.allSpecs[actualRow][actualColumn].is_highlight?.value() ?? false {
                    cell.lblName.borderColor = UIColor(red:0.00, green:0.39, blue:0.00, alpha:1.0)
                    cell.lblName.borderWidth = 1
                    cell.lblName.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
                    cell.lblName.cornerRadius = cell.lblName.bounds.height / 2
                } else {
                    cell.lblName.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
                    cell.lblName.borderWidth = 0
                }
            }

            return cell
        }
        
        return nil
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}

