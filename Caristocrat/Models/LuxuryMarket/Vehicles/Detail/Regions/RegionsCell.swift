//
//  RegionsCell.swift
 import UIKit

class RegionsCell: UITableViewCell {

    @IBOutlet weak var collectView: UICollectionView!
    var carRegions: [Car_regions] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.customizeApperance()
    }
    
    func setData(carRegions: [Car_regions]) {
        self.carRegions = carRegions
        self.collectView.reloadData()
    }
    
    func customizeApperance() {
        self.prepareTableview()
        
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: RegionsItemCells.identifier, bundle: nil), forCellWithReuseIdentifier: RegionsItemCells.identifier)
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
    }
}

extension RegionsCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: RegionsItemCells.identifier, for: indexPath) as! RegionsItemCells
        
        cell.setData(region: carRegions[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carRegions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 133)
    }
    
}
