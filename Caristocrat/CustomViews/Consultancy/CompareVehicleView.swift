//
//  CompareVehicleView.swift
 import UIKit

protocol CompareVehicleDelegates {
    func didCompareCriteriaUpdate(compareCarModel: CompareCarModel, position: Int)
    func didRemoveCar(position: Int)
    func addAnotherCar()
}

class CompareVehicleView: UIView {
    
    @IBOutlet weak var collectView: UICollectionView!
    var selectedCar: [CompareCarModel] = []
    var allBrands: [Brand] = []
    var deleteCarPosition: Int?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let compareVehicleView = UINib(nibName: "CompareVehicleView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        compareVehicleView.frame = self.bounds
        addSubview(compareVehicleView)
        
        self.customizeApperence()
    }
    
    func customizeApperence() {
        self.addDummyCar()
        self.getBrands()
        self.configureCollectionView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: CompareVehicleCell.identifier, bundle: nil), forCellWithReuseIdentifier: CompareVehicleCell.identifier)
        self.collectView?.register(UINib(nibName: AddCompareVehicleCell.identifier, bundle: nil), forCellWithReuseIdentifier: AddCompareVehicleCell.identifier)
    }
    
    func configureCollectionView() {
        self.registerCells()
        
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
    }
    
    func getBrands() {
        APIManager.sharedInstance.getBrands(for_comparision: 1, success: { (result) in
            self.allBrands = result
            self.collectView.reloadData()
        }) { (error) in
            
        }
    }
    
    
    func addDummyCar() {
        self.selectedCar.append(CompareCarModel())
        self.selectedCar.append(CompareCarModel())
    }

    @IBAction func tappedOnCompare() {
        let selectedCarsCount = self.selectedCar.filter({$0.carId != nil}).count
        if selectedCarsCount > 1 {
            self.moveToResult()
        } else {
            Utility.showErrorWith(message: Messages.SelectTwoCar.rawValue)
        }
    }
    
    func moveToResult() {
        let compareCarResult = CompareResultController.instantiate(fromAppStoryboard: .Consultant)
        let selectedCarIds = selectedCar.map({$0.carId.unWrap.description}).joined(separator: ",")
        compareCarResult.carId = selectedCarIds
        Utility().topViewController()?.navigationController?.pushViewController(compareCarResult, animated: true)
    }
}

extension CompareVehicleView: CompareVehicleDelegates {
    func addAnotherCar() {
        self.selectedCar.append(CompareCarModel())
        self.collectView.reloadData()
    }
    
    func didCompareCriteriaUpdate(compareCarModel: CompareCarModel, position: Int) {
        self.selectedCar[position] = compareCarModel
    }
    
    func didRemoveCar(position: Int) {
        self.deleteCarPosition = position
        AlertViewController.showAlert(title: "Delete Car", description: "Are you sure you want to delete this Car?", rightButtonText: "Delete", leftButtonText: "Cancel", delegate: self)
    }
}

extension CompareVehicleView: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell? = nil
        
        if indexPath.row > (self.selectedCar.count - 1) {
            if let addCompareVehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCompareVehicleCell.identifier, for: indexPath) as? AddCompareVehicleCell {
                addCompareVehicleCell.delegate = self
                cell = addCompareVehicleCell
            }
            
        } else {
            if let compareVehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: CompareVehicleCell.identifier, for: indexPath) as? CompareVehicleCell {
                compareVehicleCell.setData(compareCar: self.selectedCar[indexPath.row], brands: self.allBrands, position: indexPath.row, delegate: self)
                cell = compareVehicleCell
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedCar.count + 1 // +1 for add Car cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 5 , height: 227.5)
    }
    
}

extension CompareVehicleView: AlertViewDelegates {
    func didTapOnRightButton() {
        if let position = self.deleteCarPosition {
            self.selectedCar.remove(at: position)
            self.collectView.reloadData()
        }
    }
    
    func didTapOnLeftButton() {}
}
