//
//  ModelsViewController.swift
 import UIKit

protocol VersionSelectedDelegate {
    func didVersionSelected()
}

class VersionViewController: BaseViewController , VersionCellDelegate{
    
    var carVersion: [VersionModel] = []
    var modelId: Int?
    var carModel: CarModel?
    var delegate: VersionSelectedDelegate?
    
    @IBOutlet weak var collectView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareCollectionView()
        
    }
    
    func prepareCollectionView() {
        self.collectView?.register(UINib(nibName: VersionCell.identifier, bundle: nil), forCellWithReuseIdentifier: VersionCell.identifier)
        
        self.collectView?.delegate = self
        self.collectView?.dataSource = self
        
    }
    
    override func goBack() {
        self.storeSelectionState()
        super.goBack()
    }
    
    func storeSelectionState() {
        if self.carVersion.filter({$0.isSelected}).count > 0 {
            AppStateManager.sharedInstance.filterOptions?.selectedModels.updateValue([self.carModel?.name ?? "" : false], forKey: self.carModel?.id ?? 0)
        }
        
//        else {
//            AppStateManager.sharedInstance.filterOptions?.selectedModels.removeValue(forKey: self.carModel?.id ?? 0)
//        }
    }
    
    @IBAction func tappedOnSelect() {
        self.storeSelectionState()
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectUnSelectAllModels(isSelected:Bool) {
        
        if isSelected == true {
            for i in 0..<self.carVersion.count {
                self.carVersion[i].isSelected = false
                AppStateManager.sharedInstance.filterOptions?.selectedVersions.removeValue(forKey: carVersion[i].id ?? 0)
            }
            if let index = AppStateManager.sharedInstance.filterOptions?.selectedAllVersion.firstIndex(of: (carModel?.id)!) {
                AppStateManager.sharedInstance.filterOptions?.selectedAllVersion.remove(at: index)
            }
            
        }else{
            for i in 0..<self.carVersion.count {
                self.carVersion[i].isSelected = true
                AppStateManager.sharedInstance.filterOptions?.selectedVersions.updateValue(carVersion[i].name ?? "", forKey: carVersion[i].id ?? 0)
                
            }
            AppStateManager.sharedInstance.filterOptions?.selectedAllVersion.append((carModel?.id)!)
        }
        
        self.collectView.reloadData()
    }
    
    func versionSelection(row: Int) {
        if self.carVersion[row].isSelected {
            if row == 0 {
                if let index = AppStateManager.sharedInstance.filterOptions?.selectedAllVersion.firstIndex(of: (carModel?.id)!) {
                    AppStateManager.sharedInstance.filterOptions?.selectedAllVersion.remove(at: index)
                }
            }
            AppStateManager.sharedInstance.filterOptions?.selectedVersions.removeValue(forKey: carVersion[row].id ?? 0)
        } else {
            AppStateManager.sharedInstance.filterOptions?.selectedVersions.updateValue(carVersion[row].name ?? "", forKey: carVersion[row].id ?? 0)
        }
        
        self.carVersion[row].isSelected = !self.carVersion[row].isSelected
        self.collectView.reloadData()
        
        printForced("****",AppStateManager.sharedInstance.filterOptions?.selectedModels)
    }
    
    func checkBoxTapped(cell: VersionCell) {
        let indexPath = collectView.indexPath(for: cell)
        
        if carVersion[0].isSelected == true{
            
            self.versionSelection(row: 0)
        }
        
        versionSelection(row: (indexPath?.row)!)
        
    }
}

extension VersionViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: VersionCell.identifier, for: indexPath)
        
        if let cell = cell as? VersionCell {
            cell.delegate = self
            cell.setData(versionModel: self.carVersion[indexPath.row], modelId: (carModel?.id)!)
            carVersion[indexPath.row].isSelected = cell.isChecked
            
            if indexPath.item == 0 {
                cell.btnCheckBox.isHidden = true
                cell.parentView.backgroundColor = carVersion[indexPath.item].isSelected ? UIColor.black : UIColor.white
                cell.lblName.textColor = carVersion[indexPath.item].isSelected ? UIColor.white : UIColor.black
            }
            else {
                cell.btnCheckBox.isHidden = false
                cell.parentView.backgroundColor =  UIColor.white
                cell.lblName.textColor = UIColor.black
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carVersion.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectView?.cellForItem(at: indexPath) as? VersionCell {
            if indexPath.row == 0 {
                self.selectUnSelectAllModels(isSelected: carVersion[0].isSelected)
                
            }else{
                
//                if carVersion[0].isSelected == true{
//                    carVersion[0].isSelected = false
//                    AppStateManager.sharedInstance.filterOptions?.selectedVersions.removeValue(forKey: carVersion[0].id ?? 0)
//
//                }
//
//                if carVersion[indexPath.row].isSelected {
//                    carVersion[indexPath.row].isSelected = false
//                    AppStateManager.sharedInstance.filterOptions?.selectedVersions.removeValue(forKey: carVersion[indexPath.row].id ?? 0)
//                } else {
//                    carVersion[indexPath.row].isSelected = true
//                    AppStateManager.sharedInstance.filterOptions?.selectedVersions.updateValue(carVersion[indexPath.row].name ?? "", forKey: carVersion[indexPath.row].id ?? 0)
//                }
                
                printForced("****",AppStateManager.sharedInstance.filterOptions?.selectedVersions)
                
                //cell.isChecked = !cell.isChecked
                collectionView.reloadData()
            }

        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.carVersion[indexPath.item].name ?? "").size(withAttributes: nil).width
        return CGSize(width: width + 50.0, height: 50)
    }
    
    
    
}


