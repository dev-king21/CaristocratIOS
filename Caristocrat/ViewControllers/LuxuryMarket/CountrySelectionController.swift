//
//  CountrySelectionController.swift
 import UIKit

class CountrySelectionController: UIViewController {
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var btnRememberCountry: UIButton!
    @IBOutlet weak var selectCountryLabel: UILabel!
    var isForFilter: Bool = false
    var delegate: EventPerformDelegate?
    
    var countries: [Region] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCountries()
        self.customizeApperance()
    }
    
    func customizeApperance() {
        self.prepareCollectionview()
        
        if self.isForFilter {
            btnRememberCountry.isHidden = true
            selectCountryLabel.isHidden = true
        }
        
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: CountryPickerCell.identifier, bundle: nil), forCellWithReuseIdentifier: CountryPickerCell.identifier)
    }
    
    func prepareCollectionview() {
        self.registerCells()
        
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
    }
    
    func getCountries() {
        APIManager.sharedInstance.getCountries(success: { (result) in
            self.countries = result
            self.collectView.reloadData()
        }) { (error) in
            
        }
    }
    
    func getSelectedCountries() -> [Int: String] {
        var selectedCountries: [Int: String] = [:]
        for index in 0...countries.count {
            if let cell = collectView.cellForItem(at: IndexPath(row: index, section: 0)) as? CountryPickerCell, cell.isChecked {
//                regionsids.append(countries[index].id ?? 0)
                selectedCountries.updateValue(countries[index].name ?? "", forKey: countries[index].id ?? -1)
            }
        }
        return selectedCountries
    }
    
    @IBAction func tappedOnDone() {
        AppStateManager.sharedInstance.isRememberCountry = btnRememberCountry.isSelected
        AppStateManager.sharedInstance.filterOptions?.selectedCountries = self.getSelectedCountries()

//        if isForFilter {
//            self.dismiss()
//        } else {
            let regionIds = getSelectedCountries()
            if regionIds.count > 0 {
                self.dismiss()

//                APIManager.sharedInstance.saveRegions(regionsId: Array(getSelectedCountries().keys), success: { (result) in
//                    self.dismiss()
//                    Utility.showSuccessWith(message: Messages.RegionUpdated.rawValue)
//                }) { (error) in
//                    print("error")
//                }
            } else {
                Utility.showErrorWith(message: Messages.SelectRegion.rawValue)
            }
//        }
        
        delegate?.didActionPerformed(eventName: .didCountrySelected, data: "")
    }
    
    @IBAction func tappedOnCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnRemember(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}

extension CountrySelectionController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: CountryPickerCell.identifier, for: indexPath)
        
        if let countryPickerCell = cell as? CountryPickerCell {
            countryPickerCell.setData(region: countries[indexPath.row], isForFilter: self.isForFilter)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectView?.cellForItem(at: indexPath) as? CountryPickerCell {
            cell.isChecked = !cell.isChecked
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.countries.count % 2 == 1 && indexPath.item == self.countries.count - 1{
            return CGSize(width: collectionView.frame.width, height: 146)
        }
        return CGSize(width: 138, height: 146)
    }
    
}

