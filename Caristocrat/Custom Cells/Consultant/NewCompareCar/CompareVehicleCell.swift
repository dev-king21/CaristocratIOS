//
//  CompareVehicleCell.swift
 import UIKit

class CompareVehicleCell: UICollectionViewCell {
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    
    var compareCarModel: CompareCarModel?
    var delegate: CompareVehicleDelegates?
    var position: Int = -1
    var allBrands: [Brand] = []
    var carModels: [CarModel] = []
    var vehicles: [VehicleBase] = []

    enum CompareTags: String {
        case BRANDS = "Brands"
        case MODELS = "Models"
        case YEARS = "Years"
        case VERSION = "Versions"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(compareCar: CompareCarModel, brands: [Brand], position: Int, delegate: CompareVehicleDelegates) {
        self.compareCarModel = compareCar
        self.position = position
        self.allBrands = brands
        self.brandLabel.text = compareCar.brandName ?? "Select Brand"
        self.modelLabel.text = compareCar.modelName ?? "Select Model"
        self.yearLabel.text = compareCar.year ?? "Select Year"
        self.carImage.kf.setImage(with: URL(string: compareCar.carImage.unWrap), placeholder: #imageLiteral(resourceName: "compare_car_thumb"))
        self.delegate = delegate
    }
    
    @IBAction func tappedOnClose() {
        self.delegate?.didRemoveCar(position: position)
    }
    
    @IBAction func tappedOnBrand() {
        Utility().showSelectionPopup(title: CompareTags.BRANDS.rawValue, items: allBrands.map({$0.name ?? ""}), delegate: self)
    }
    
    @IBAction func tappedOnModel() {
        self.getBrandModels()
    }
    
    @IBAction func tappedOnVersion() {
        self.getVehicles(forVersion: true)
    }
    
    @IBAction func tappedOnYear() {
       self.getVersions()
    }
    
    func getBrandModels() {
        if let _ = compareCarModel?.brandId {
            APIManager.sharedInstance.getCarModels(brandId: compareCarModel?.brandId ?? -1, for_comparision: 1, success: { (result) in
                self.carModels = result
                Utility().showSelectionPopup(title: CompareTags.MODELS.rawValue, items: self.carModels.map({$0.name ?? ""}), delegate: self)
            }) { (error) in
                
            }
        } else {
            Utility.showErrorWith(message: Messages.SelectBrand.rawValue)
        }
        
    }
    
    func getVersions() {
       self.getVehicles(forVersion: false)
    }
    
    func getVehicles(forVersion: Bool) {
        if let modelId = compareCarModel?.modelId {
            
            if forVersion && compareCarModel?.year == nil {
                Utility.showErrorWith(message: Messages.SelectYear.rawValue)
                return
            }
            
            var params : Parameters = ["category_id" : Constants.LUXURY_MARKET_CATEGORY_ID]
            params["is_for_review"] = 0
            params.updateValue(modelId , forKey: "model_ids")
            
            if forVersion {
              params["sort_by_version"] = 1
              params["sort_by_year"] = 0
              params["min_year"] = compareCarModel?.year.unWrap
              params["max_year"] = compareCarModel?.year.unWrap
            } else {
                params["sort_by_year"] = 1
            }
            
            APIManager.sharedInstance.getVehicles(params: params, success: { (result) in
                self.vehicles = result
                if self.isVehiclesExists(forVersions: forVersion) {
                    if forVersion {
                       self.showVersionPopup()
                    } else {
                       self.showYearsPopup()
                    }
                    
                }
            }) { (error) in
                print("")
            }
        } else {
            if let _ = compareCarModel?.brandId {
                Utility.showErrorWith(message: Messages.SelectModel.rawValue)
            } else {
                Utility.showErrorWith(message: Messages.SelectBrand.rawValue)
            }
        }
    }
    
    func isVehiclesExists(forVersions: Bool) -> Bool {
        if self.vehicles.count == 0 {
            if forVersions {
                Utility.showErrorWith(message: Messages.VersionsNotFound.rawValue)
            } else {
                Utility.showErrorWith(message: Messages.VehiclesNotFound.rawValue)
            }
           
        }
        return self.vehicles.count != 0
    }
    
    func showYearsPopup() {
        Utility().showSelectionPopup(title: CompareTags.YEARS.rawValue, items: self.vehicles.map({$0.year.unWrap.description}), delegate: self)
    }
    
    func showVersionPopup() {
        Utility().showSelectionPopup(title: CompareTags.VERSION.rawValue, items: self.vehicles.map({$0.version?.name ?? ""}), delegate: self)
    }
}

extension CompareVehicleCell: ItemSelectionDelegate {
    func didItemSelect(position: Int, tag: String) {
        if tag == CompareTags.BRANDS.rawValue {
            let brand = allBrands[position]
            self.compareCarModel?.brandId = brand.id.unWrap
            self.compareCarModel?.brandName = brand.name.unWrap
            self.compareCarModel?.modelId = nil
            self.compareCarModel?.modelName = nil
            self.compareCarModel?.carId = nil
            self.compareCarModel?.carImage = nil
            self.compareCarModel?.year = nil
            self.compareCarModel?.versionId = nil
            self.compareCarModel?.versionName = nil
            self.carImage.image = nil
        } else if tag == CompareTags.MODELS.rawValue  {
            let model = carModels[position]
            self.compareCarModel?.modelId = model.id.unWrap
            self.compareCarModel?.modelName = model.name.unWrap
            self.compareCarModel?.carId = nil
            self.compareCarModel?.carImage = nil
            self.compareCarModel?.year = nil
            self.compareCarModel?.versionId = nil
            self.compareCarModel?.versionName = nil
            self.carImage.image = nil
        } else if tag == CompareTags.YEARS.rawValue  {
            self.compareCarModel?.versionId = nil
            self.compareCarModel?.versionName = nil
            let vehicle = vehicles[position]
            self.compareCarModel?.year = vehicle.year.unWrap.description
            self.yearLabel.text = vehicle.year.unWrap.description
            self.carImage.image = nil
        } else if tag == CompareTags.VERSION.rawValue  {
             let vehicle = vehicles[position]
            let url = vehicle.media?.first?.file_url ?? ""
            self.compareCarModel?.carId = vehicle.id.unWrap
            self.compareCarModel?.carImage = url
            self.compareCarModel?.versionId = vehicle.version?.id.unWrap.description
            self.compareCarModel?.versionName = vehicle.version?.name.unWrap
            self.carImage.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "compare_car_thumb"))
            self.versionLabel.text = vehicle.version?.name.unWrap.description
        }
        
        self.setUpdatedData()
        self.delegate?.didCompareCriteriaUpdate(compareCarModel: self.compareCarModel!, position: self.position)
    }
    
    func setUpdatedData() {
        self.brandLabel.text = self.compareCarModel?.brandName ?? "Select Brand"
        self.modelLabel.text = self.compareCarModel?.modelName ?? "Select Model"
        self.yearLabel.text = self.compareCarModel?.year ?? "Select Year"
        self.versionLabel.text = self.compareCarModel?.versionName ?? "Select Version"
        self.carImage.kf.setImage(with: URL(string: self.compareCarModel?.carImage ?? ""), placeholder: #imageLiteral(resourceName: "compare_car_thumb"))
    }
    
}



