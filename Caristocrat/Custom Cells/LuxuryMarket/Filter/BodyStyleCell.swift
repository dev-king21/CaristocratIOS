//
//  BodyStyleCell.swift
 import UIKit

class BodyStyleCell: UITableViewCell {
    
    @IBOutlet weak var collectView: UICollectionView!
    var selectedPosition: Int = 0
    var bodyStyles: [BodyStyleModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.customizeApperance()
        self.getBodyStyle()
    }
    
    func resetSelection() {
        for (index,_) in bodyStyles.enumerated() {
            bodyStyles[index].isChecked = false
        }
        self.collectView.reloadData()
    }
    
    func customizeApperance() {
        self.prepareTableview()
        
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: BodyStyleItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: BodyStyleItemCell.identifier)
    }
    
    func getBodyStyle() {
        APIManager.sharedInstance.getBodyStyles(success: { (result) in
            self.bodyStyles = result
            self.applySelection()
            self.collectView.reloadData()
        }) { (error) in
            
        }
    }
    
    func applySelection() {
        if let keys =  AppStateManager.sharedInstance.filterOptions?.styles?.split(separator: ",") {
            for item in keys {
                self.bodyStyles[self.bodyStyles.index(where: {$0.id == Int(item)}) ?? 0].isChecked = true
            }
        }
    }
    
    func storeSelectedStyles() {
        let styles = self.bodyStyles.filter({$0.isChecked == true})
        var stylesIds: String = ""
        for item in styles {
            stylesIds += (item.id?.description ?? "") + ","
        }
        
        AppStateManager.sharedInstance.filterOptions?.styles = stylesIds.dropLast().description
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
    }
    
    
}

extension BodyStyleCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: BodyStyleItemCell.identifier, for: indexPath) as! BodyStyleItemCell
        cell.isChecked = selectedPosition == indexPath.row
        cell.setData(bodyStyle: bodyStyles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bodyStyles.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectView?.cellForItem(at: indexPath) as? BodyStyleItemCell {
            let isChecked = bodyStyles[indexPath.row].isChecked
            bodyStyles[indexPath.row].isChecked = !isChecked
            cell.updateSelection(isChecked: !isChecked)
            self.storeSelectedStyles()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 130)
    }
    
}
