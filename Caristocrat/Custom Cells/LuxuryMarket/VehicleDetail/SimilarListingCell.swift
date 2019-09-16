//
//  SimilarListingCell.swift
 import UIKit

class SimilarListingCell: UITableViewCell {
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var delegate: VechicleDetailCellsDelegate?
    @IBOutlet weak var noDataFoundLabel: UILabel!
    var allVehicles: [VehicleBase] = []
    var similarVehicles: [VehicleBase] = []
    
    //Paging work
    var limit = 10
    var offset = 0
    var isLoading = false
    var tblFooter  = LoadMoreView.instanceFromNib()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(vehicleDetail: VehicleBase) {
        similarVehicles = allVehicles.filter({$0.id != vehicleDetail.id ?? -1})
        self.customizeApperance()

    }
    
    func customizeApperance() {
        self.prepareTableview()
        
        noDataFoundLabel.isHidden = similarVehicles.count > 0
    }
    
    func moveAhead(index: Int) {
//        var vehicles = allVehicles
//        vehicles.remove(at: index)
        delegate?.didTapOnSimilarListing(vehicles: allVehicles, selectedVehicle: similarVehicles[index])
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: SimilarVehicleCell.identifier, bundle: nil), forCellWithReuseIdentifier: SimilarVehicleCell.identifier)
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
        self.collectView?.reloadData()
    }
    
    
    
    
}

extension SimilarListingCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: SimilarVehicleCell.identifier, for: indexPath) as! SimilarVehicleCell
        
        cell.setData(vehicleModel: similarVehicles[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarVehicles.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveAhead(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (UIScreen.main.bounds.width / 2) , height: 195)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        checkForMoreRecords(indexNo: indexPath.row)
    }
    func checkForMoreRecords(indexNo : Int) {
        
        if indexNo == (similarVehicles.count) - 1 {
            if (allVehicles.count) < LastService.totalCount {
                
                offset = offset+limit //--ww (pageNo * limit) - 1
                
               // getSimilarNews()
            }else{
                // self.collectView.
            }
        }
        
    }
    
}
