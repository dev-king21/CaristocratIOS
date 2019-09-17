//
//  SpecificationCell.swift
 import UIKit

class SpecificationCell: UITableViewCell {

    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var imgArrow: UIButton!
    
    var isExpanded = false
    var attributes: [MyCarAttributes] = []
    var specs: [Specs] = []
    var hasMultipleSpecs = false
    var delegate: VechicleDetailCellsDelegate?
    var row: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customizeApperance()
    }
    
    func customizeApperance() {
        self.prepareTableview()
        
    }
    
    func setData(vehicleDetail: VehicleBase) {
        if let carAttributes = vehicleDetail.specifications {
            self.sectionTitle.text = "Specifications"
            self.attributes = carAttributes
            self.collectView.reloadData()
        }
    }
    
    func setData(specs: [Specs], sectionTitle: String) {
        self.sectionTitle.text = sectionTitle
        self.hasMultipleSpecs = true
        self.specs = specs
        if isExpanded {
            let totalRows = (CGFloat(hasMultipleSpecs ? self.specs.count : self.attributes.count) / 2.0).rounded(.awayFromZero)
            self.collectionViewHeight.constant = CGFloat(totalRows * 60.0) + 2
            // 10 For Divider spacing (Cell Spacing between rows)
        } else {
            self.collectionViewHeight.constant = 0
        }
        
        self.collectView.reloadData()
        
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: SpecificationItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: SpecificationItemCell.identifier)
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
    }
    
    @IBAction func tappedOnExpandButton() {
        if hasMultipleSpecs {
            delegate?.didTapOnSpecsSection(position: row)
        } else {
           collapseExpand()
        }
    }
    
    func collapseExpand() {
        if isExpanded {
            self.collectionViewHeight.constant = 0
        } else {
            let totalRows = (CGFloat(hasMultipleSpecs ? self.specs.count : self.attributes.count) / 2.0).rounded(.awayFromZero)
            self.collectionViewHeight.constant = CGFloat(totalRows * 60.0) + 2
            // 10 For Divider spacing (Cell Spacing between rows)
        }
        
        isExpanded = !isExpanded
        if !isExpanded{
            self.imgArrow.setImage(#imageLiteral(resourceName: "downarrow-1"), for: .normal)
        }
        else{
            self.imgArrow.setImage(#imageLiteral(resourceName: "uparrow"), for: .normal)
        }
        if let parentTable = superview as? UITableView {
            parentTable.reloadData()
            
        }
    }
}


extension SpecificationCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: SpecificationItemCell.identifier, for: indexPath) as! SpecificationItemCell
        if hasMultipleSpecs {
            cell.setData(specs: specs[indexPath.row])
            cell.lblName?.restartLabel()
        } else {
            cell.setData(carAttributes: attributes[indexPath.row])
            cell.lblName?.restartLabel()
        }
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hasMultipleSpecs ? specs.count : attributes.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(hasMultipleSpecs){
            if(specs.count > 1){
                return CGSize(width: (collectionView.frame.size.width/2), height: 60)
            }else{
                return CGSize(width: (collectionView.frame.size.width - 20), height: 60)
            }
        }else{
            return CGSize(width: (collectionView.frame.size.width/2), height: 60)
        }
        return CGSize()
    }
    
}
