//
//  ModelsViewController.swift
 import UIKit

protocol ModelSelectedDelegate {
    func didModelsSelected()
}

class ModelsViewController: BaseViewController, ModelCellDelegate {
    
    var carModels: [CarModel] = []
    var brandId: Int?
    var brand: Brand?
    var delegate: ModelSelectedDelegate?
    var slug: String = Slugs.LUXURY_MARKET.rawValue
    var categoryId = 0

    @IBOutlet weak var collectView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.collectView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareCollectionView()
        self.getBrandModels()
    }
    
    func prepareCollectionView() {
        self.collectView?.register(UINib(nibName: ModelCell.identifier, bundle: nil), forCellWithReuseIdentifier: ModelCell.identifier)
        
        self.collectView?.delegate = self
        self.collectView?.dataSource = self
    
    }
    
    func getBrandModels() {
        APIManager.sharedInstance.getCarModels(brandId: brandId!, categoryId: self.categoryId, for_comparision: 0, success: { (result) in
            
            if result.count == 0 {
                Utility.showErrorWith(message: Messages.VersionsNotFound.rawValue)
                self.goBack()
                return
            }
            
            self.carModels = result
            
            let car = CarModel.init()
            self.carModels.insert(car, at: 0)
            
            //self.setSelectionState()
            self.collectView.reloadData()
        }) { (error) in
            
        }
    }
    
    override func goBack() {
        self.didSelectModels()
        super.goBack()
    }
    
    func setSelectionState() {
//        for i in 0..<carModels.count {
//            if self.brand?.selectedCarModels.filter({$0.id == carModels[i].id}).count ?? 0 > 0 {
//                carModels[i].isSelected = true
//            }
//        }
    }
    
//    func getSelectedCarModels() -> [Int] {
//        var carModelId: [Int] = []
//        for index in 0...carModels.count {
//            if let cell = collectView.cellForItem(at: IndexPath(row: index, section: 0)) as? ModelCell, cell.isChecked {
//                carModelId.append(carModels[index].id ?? 0)
//            }
//        }
//        return carModelId
//    }
    
    func didSelectModels() {
        if self.carModels.filter({$0.isSelected}).count > 0 {
            AppStateManager.sharedInstance.filterOptions?.selectedBrands.removeAll()
            AppStateManager.sharedInstance.filterOptions?.selectedBrands.updateValue(self.brand?.name ?? "", forKey: self.brand?.id ?? -1)
        }
//        else {
//            AppStateManager.sharedInstance.filterOptions?.selectedBrands.removeValue(forKey: self.brand?.id ?? -1)
//        }

        delegate?.didModelsSelected()

    }
    
    @IBAction func tappedOnSelect() {
        self.didSelectModels()
//        self.navigationController?.popViewController(animated: true)
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FilterController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func selectModel(row: Int) {
        if slug == Slugs.LUXURY_MARKET.rawValue {
            self.getVersion(row: row)
        } else {
            self.modelSelection(row: row)
        }
    }
    
    func modelSelection(row: Int) {
        if self.carModels[row].isSelected {
            AppStateManager.sharedInstance.filterOptions?.selectedModels.removeValue(forKey: carModels[row].id ?? 0)
        } else {
            AppStateManager.sharedInstance.filterOptions?.selectedModels.updateValue([self.carModels[row].name ?? "" : true], forKey: self.carModels[row].id ?? 0)
        }
        
        self.carModels[row].isSelected = !self.carModels[row].isSelected
        self.collectView.reloadData()
        
        printForced("****",AppStateManager.sharedInstance.filterOptions?.selectedModels)
    }
    
    func selectUnSelectAllModels(isSelected:Bool) {
        
        if isSelected == true {
            AppStateManager.sharedInstance.filterOptions?.selectedModels.removeAll()
            for i in 0..<self.carModels.count {
                self.carModels[i].isSelected = false
            }
        }else{
            for i in 0..<self.carModels.count {
                self.carModels[i].isSelected = true
                AppStateManager.sharedInstance.filterOptions?.selectedModels.updateValue([self.carModels[i].name ?? "" : true], forKey: self.carModels[i].id ?? 0)
            }
        }

        self.collectView.reloadData()
    }
    
    func getVersion(row: Int) {
        APIManager.sharedInstance.getCarVersion(model_id: carModels[row].id.unWrap, success: { (result) in
            if result.count > 0 {
                self.moveToVersionsVC(versions: result, carModel: self.carModels[row])
            } else {
              if !self.carModels[row].isSelected {
                Utility.showErrorWith(message: Messages.VersionsNotFound.rawValue)
              }
                //remove didselect selection
              //self.modelSelection(row: row)

            }
        }) { (error) in
            
        }
    }
    
    func moveToVersionsVC(versions: [VersionModel], carModel: CarModel) {
        let versionViewController = VersionViewController.instantiate(fromAppStoryboard: .LuxuryMarket)
        versionViewController.carVersion = versions
        versionViewController.carVersion.insert(VersionModel.init(), at: 0)
        versionViewController.carModel = carModel
        self.navigationController?.pushViewController(versionViewController, animated: true)
    }
    
    func checkBoxTapped(cell: ModelCell) {
        let indexPath = collectView.indexPath(for: cell)
        
        if carModels[0].isSelected == true{
 
            self.modelSelection(row: 0)
        }
        
        modelSelection(row: (indexPath?.row)!)
        
    }
}

extension ModelsViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelCell.identifier, for: indexPath)
        
        if let cell = cell as? ModelCell {
            
            printForced(indexPath.item)
//            printForced(carModels)
            printForced(carModels[indexPath.item])
            cell.delegate = self
            
            cell.setData(carModel: carModels[indexPath.item])
            carModels[indexPath.item].isSelected = cell.isChecked

           
            
            if indexPath.item == 0 {
                cell.btnCheckBox.isHidden = true
                cell.parentView.backgroundColor = carModels[indexPath.item].isSelected ? UIColor.black : UIColor.white
                cell.lblName.textColor = carModels[indexPath.item].isSelected ? UIColor.white : UIColor.black
            }
            else {
                cell.btnCheckBox.isHidden = false
                cell.parentView.backgroundColor =  UIColor.white
                cell.lblName.textColor = UIColor.black
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        printForced("******")
        printForced(carModels)
        return carModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.selectUnSelectAllModels(isSelected: carModels[0].isSelected)
            
        }else{
            //remove didselect selection
            //self.selectModel(row: indexPath.row)
            
            self.getVersion(row: indexPath.row)
        }
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.carModels[indexPath.item].name ?? "").size(withAttributes: nil).width
        return CGSize(width: width + 50.0, height: 50)
    }
    
  
    
}

