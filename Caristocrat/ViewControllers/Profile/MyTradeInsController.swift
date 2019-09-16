    //
//  MyTradeInsController.swift
//  Caristocrat
//
//  Created by Muhammad Muzammil on 10/20/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyTradeInsController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tradeInsVehicles: [MyTradeIns] = []
    var type: TradeEvaluateCarType = .trade
    
    override func viewDidLoad() {
        title = type == .trade ? "MY TRADE INS" : "MY CARS EVALUATIONS"
        super.viewDidLoad()
        self.customizeApperence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTradeInCars()
    }
    
    func customizeApperence() {
        self.prepareTableview()
    }
    
    func registerCells() {
        self.tableView.register(UINib(nibName: MyTradeInsCell.identifier, bundle: nil), forCellReuseIdentifier: MyTradeInsCell.identifier)
    }
    
    func getTradeInCars() {
        APIManager.sharedInstance.getTradeInCars(params: ["type":type.rawValue], success: { (result) in
            self.tradeInsVehicles = result
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
    }
    
    func moveAhead(index: Int) {
        let myTradeInDetailController = MyTradeInDetailController.instantiate(fromAppStoryboard: .Login)
        myTradeInDetailController.myTradeIns = tradeInsVehicles[index]
        myTradeInDetailController.detailType = type
        
        if type == .trade {
            if let vehicleDetail = tradeInsVehicles[index].my_car {
                myTradeInDetailController.vehicleDetail = vehicleDetail
            }
        } else {
            if let vehicleDetail = tradeInsVehicles[index].trade_against {
                myTradeInDetailController.vehicleDetail = vehicleDetail
            }
        }
        
        self.navigationController?.pushViewController(myTradeInDetailController, animated: true)
    }
    
    @IBAction func tappedOnAddTrade() {
         self.navigationController?.pushViewController(TradeCarController.instantiate(fromAppStoryboard: .Home), animated: true)
    }
    
    @IBAction func tappedOnBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MyTradeInsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTradeInsCell.identifier)
        
        if let myTradeInsCell = cell as? MyTradeInsCell {
            if type == .trade {
                if let vehicleDetail = tradeInsVehicles[indexPath.row].my_car {
                    myTradeInsCell.setData(vehicleDetail: vehicleDetail, forEvaluation: false, forFavorite: false)
                }
            } else {
                if let vehicleDetail = tradeInsVehicles[indexPath.row].trade_against {
                    myTradeInsCell.setData(vehicleDetail: vehicleDetail, forEvaluation: true, forFavorite: false)
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeInsVehicles.count
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveAhead(index: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MyTradeInsController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "\(type == .trade ? "Trades" : "Evaluations")"+" will show up here, so you can easily view them here later"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No " + "\(type == .trade ? "Trades" : "Evaluations")" + " found"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}



