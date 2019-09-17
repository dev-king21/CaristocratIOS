////
////  CompareVehiclesController.swift
////  Caristocrat
////
////  Created by     on 2/6/19.
////  Copyright © 2019 Ingic. All rights reserved.
////
//
//import UIKit
//
//class CompareVehiclesController: UIViewController {
//    
//    @IBOutlet weak var collectView: UICollectionView!
//    var selectedCar: [CompareCarModel] = []
//    var allBrands: [Brand] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.getBrands()
//    }
//    
//    func registerCells() {
//       self.collectView?.register(UINib(nibName: CompareVehicleCell.identifier, bundle: nil), forCellWithReuseIdentifier: CompareVehicleCell.identifier)
//       self.collectView?.register(UINib(nibName: AddCompareVehicleCell.identifier, bundle: nil), forCellWithReuseIdentifier: AddCompareVehicleCell.identifier)
//    }
//    
//    func configureCollectionView() {
//        self.registerCells()
//        
//        self.collectView?.dataSource = self
//        self.collectView?.delegate = self
//    }
//    
//    func getBrands() {
//        APIManager.sharedInstance.getBrands(success: { (result) in
//            self.allBrands = result
//        }) { (error) in
//            
//        }
//    }
//}
//
//extension CompareVehiclesController: CompareVehicleDelegates {
//    func didCompareCriteriaUpdate(compareCarModel: CompareCarModel, position: Int) {
//        self.selectedCar[position] = compareCarModel
//    }
//    
//    func didRemoveCar(position: Int) {
//        self.selectedCar.remove(at: position)
//        self.collectView.reloadData()
//    }
//}
//
//extension CompareVehiclesController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        var cell: UICollectionViewCell? = nil
//        
//        if let compareVehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: CompareVehicleCell.identifier, for: indexPath) as? CompareVehicleCell {
//            compareVehicleCell.setData(compareCar: self.selectedCar[indexPath.row], brands: self.allBrands, position: indexPath.row, delegate: self)
//            cell = compareVehicleCell
//        } else if let addCompareVehicleCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCompareVehicleCell.identifier, for: indexPath) as? AddCompareVehicleCell {
//            
//            cell = addCompareVehicleCell
//        }
//
//        return cell!
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.selectedCar.count + 1 // +1 for add Car cell
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 250, height: 250)
//    }
//    
//}
//
//
