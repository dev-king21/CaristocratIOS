//
//  BrandsControllers.swift
 import UIKit
import RangeSeekSlider
import BDKCollectionIndexView

protocol BrandDelegate {
    func didSelectBrands()
}

class BrandsController: BaseViewController {
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvSearch: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var customNavigation: UINavigationBar!
   // @IBOutlet weak var alphabetSlider: AlphabetSlider!
    @IBOutlet weak var alphabetSlider: BDKCollectionIndexView!
    
    
    
    var filteredBrands: [Brand] = []
    var allBrands: [Brand] = []

    var itemsCount: [Int] = []
    var delegate: BrandDelegate?
    let alphabets =  ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var slug: String = Slugs.LUXURY_MARKET.rawValue
    
    var selectedItemId:Int?
    var categoryId = 0

    
    override func viewWillAppear(_ animated: Bool) {
        hideNavBar = true
        super.viewWillAppear(true)
        searchView.isHidden = true
        searchViewWidthConstraint.constant = 0
        
        if let font = UIFont(name: FontsType.Heading.rawValue, size: 24){
            self.customNavigation.titleTextAttributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:UIColor.black]
        }
    }

    override func viewDidLoad() {
       super.viewDidLoad()

       self.customizeApperance()
       self.getBrands()
        
        self.alphabetSlider.indexTitles = self.alphabets
        self.alphabetSlider.addTarget(self, action: #selector(indexViewValueChanged), for: .valueChanged)
        

    }
    
    func setSelectedBrandIndex(){
        let id = AppStateManager.sharedInstance.filterOptions?.selectedBrands.first?.key
        selectedItemId = id
    }
    
    @objc func indexViewValueChanged(sender: BDKCollectionIndexView) {
        var scrollToIndex = 0
        let index = Int(sender.currentIndex)
        let alphabet = self.alphabets[index]
        for (index,item) in self.filteredBrands.enumerated(){
            if let name = item.name {
                if let firstCharacter = name.first{
                    let char = String(firstCharacter)
                    if alphabet == char{
                        scrollToIndex = index
                        break
                    }
                }
            }
        }
        let indexPath = IndexPath(item: scrollToIndex, section: 0)
        self.collectView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    func customizeApperance() {
        self.tvSearch.delegate = self
        self.prepareCollectionview()
    }
    func registerCells() {
        self.collectView?.register(UINib(nibName: BrandItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: BrandItemCell.identifier)
        let headerNib = UINib.init(nibName: BrandSectionHeaderCell.identifier, bundle: nil)
        self.collectView?.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandSectionHeaderCell.identifier)

    }
    
    func getBrands() {
        APIManager.sharedInstance.getBrands(for_comparision: 0, success: { (result) in
            self.filteredBrands = result
            self.allBrands = result
            
            self.setSelectedBrandIndex()
            
//            self.sortBrands()
//            self.applySelection()
            self.collectView.reloadData()
        }) { (error) in
            
        }
    }
    
    func applySelection() {
        if let keys =  AppStateManager.sharedInstance.filterOptions?.selectedBrands.keys {
            for item in keys {
                self.filteredBrands[self.filteredBrands.index(where: {$0.id == item}) ?? 0].isChecked = true
            }
        }
    }
    
    func storeSelectedBrands() {
        if AppStateManager.sharedInstance.filterOptions?.selectedBrands.first?.key != selectedItemId {
            AppStateManager.sharedInstance.filterOptions?.selectedVersions.removeAll()
            AppStateManager.sharedInstance.filterOptions?.selectedModels.removeAll()
        }
     
        
        let brands = self.filteredBrands.filter({$0.id == selectedItemId})
        var brandsIds: [Int:String] = [:]
       
        for item in brands {
            brandsIds.updateValue(item.name ?? "", forKey: item.id ?? 0)
        }
        
        AppStateManager.sharedInstance.filterOptions?.selectedBrands = brandsIds
    }
    
    func sortBrands() {
        if self.filteredBrands.count > 0 {
            var count = 0
            for item in 0..<filteredBrands.count {
                count += 1
                let currentBrand = self.filteredBrands[item]
                if (item + 1) < self.filteredBrands.count { // Check it's last item?
                    let nextBrand = self.filteredBrands[item+1]
                    if currentBrand.name?.starts(with: nextBrand.name?.first?.description ?? "")  ?? false {
                        continue
                    } else {
                        itemsCount.append(count)
                        count = 0
                    }
                    
                } else {
                    // For Last Item
                    itemsCount.append(count)
                    count = 0
                }
               
            }
        }
    }
    
    @IBAction func tappedOnClose() {
       // self.storeSelectedBrands()

        delegate?.didSelectBrands()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOnBack(_ sender: Any) {
//        self.storeSelectedBrands()
        delegate?.didSelectBrands()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelSearch(_ sender: Any) {
        self.tvSearch.text = ""
        filteredBrands = allBrands
        self.collectView.reloadData()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchViewWidthConstraint.constant = 0
            self.btnCancel.isHidden = true
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.searchView.isHidden = true
        })
    }
    
    @IBAction func showSearch(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchViewWidthConstraint.constant = self.view.bounds.width
            self.searchView.isHidden = false
            self.btnCancel.isHidden = false
            self.view.layoutIfNeeded()
            self.tvSearch.becomeFirstResponder()
        }, completion: nil)
    }
    
    func getRow(forSection: Int) -> Int {
        var sum  = 0
        for item in 0..<forSection {
            sum += self.itemsCount[item]
        }
        
        return sum
    }
    
    func prepareCollectionview() {
        self.registerCells()
        
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
    }
}

extension BrandsController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            filteredBrands = allBrands
        } else {
            filteredBrands = allBrands.filter({$0.name?.lowercased().starts(with: string.lowercased()) ?? false})
        }
        
        self.collectView.reloadData()
        
        return true
    }
}

extension BrandsController:  ModelSelectedDelegate , BrandItemCellDelegate{

    func didModelsSelected() {
        self.collectView.reloadData()
    }
    
    func checkBoxTapped(cell: BrandItemCell) {
        let indexPath = collectView.indexPath(for: cell)
        selectedItemId = filteredBrands[indexPath!.row].id
        
        collectView.reloadData()
        
        storeSelectedBrands()
    }
    
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: BrandItemCell.identifier, for: indexPath)
        
        if let brandItemCell = cell as? BrandItemCell {
//            brandItemCell.setData(brand: brands[self.getRow(forSection: indexPath.section) + indexPath.row])
            brandItemCell.setData(brand: filteredBrands[indexPath.row])
            brandItemCell.delegate = self

            //brandItemCell.btnCheckBox.isHidden = true
            
            if filteredBrands[indexPath.row].id == selectedItemId {
                brandItemCell.btnCheckBox.isSelected = true
                brandItemCell.updateSelection(isChecked: true)
                //filteredBrands[indexPath.row].isChecked = true
            }else{
                brandItemCell.btnCheckBox.isSelected = false
                brandItemCell.updateSelection(isChecked: false)
                //filteredBrands[indexPath.row].isChecked = false
            }
            

        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectView?.cellForItem(at: indexPath) as? BrandItemCell {
//          let isChecked = filteredBrands[self.getRow(forSection: indexPath.section) + indexPath.row].isChecked
////        brands[self.getRow(forSection: indexPath.section) + indexPath.row].isChecked = !isChecked
//          filteredBrands[indexPath.row].isChecked = !isChecked
//          cell.updateSelection(isChecked: !isChecked)
            
            checkBoxTapped(cell: cell)
            
            let modelViewController = ModelsViewController.instantiate(fromAppStoryboard: .LuxuryMarket)
            modelViewController.brandId = self.filteredBrands[indexPath.row].id ?? 0
            modelViewController.brand = self.filteredBrands[indexPath.row]
            modelViewController.delegate = self
            modelViewController.categoryId = self.categoryId
            modelViewController.slug = slug
            self.navigationController?.pushViewController(modelViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return itemsCount[section]
        return filteredBrands.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 50) //add your height here
//    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 2) - 5), height: 130)
    }
    
    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return ["A","B"]
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return IndexPath(item: 0, section: 0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BrandSectionHeaderCell.identifier, for: indexPath) as? BrandSectionHeaderCell {
//
//            sectionHeader.lblTitle.text = brands[self.getRow(forSection: indexPath.section) + indexPath.row].name?.uppercased().first?.description
//            return sectionHeader
//        }
//        return UICollectionReusableView()
//    }
//    @objc func scrollToIndex(_ sender: AlphabetSlider) {
//        // Only listen to the events that were generated by the user dragging on
//        // the index slider.
//        guard self.alphabetSlider.userIsUsing else { return }
//        
//        print(sender.value)
//       // let indexPath = IndexPath(item: 0, section: sender.value)
//        ///self.collectView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//    }

}
