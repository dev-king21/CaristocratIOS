//
//  MySubscriptionsViewController.swift
//  Caristocrat
//
//  Created by Khunshan Ahmad on 12/09/2019.
//  Copyright © 2019 Ingic. All rights reserved.
//

import UIKit
import SwiftDate

class MySubscriptionsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var model: [AllSubscriptionsModel]? {
        didSet { arrangeData() }
    }
    
    var allData: [[AllSubscriptionsModel]]? {
        didSet { tableView.reloadData() }
    }
    
    
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        fetchData()
    }

    @IBAction func tappedOnBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

//TableView
extension MySubscriptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! MySubscriptionsCell
        
        
        if let data = self.allData?[indexPath.section][indexPath.row] {
            //Title
            cell.titleLabel.text = data.title
            //From Date
            if data.fromDate == nil || (data.fromDate?.isEmpty ?? true) {
                cell.secondLabel.text = "Subscribed on: N/A"
            } else {
                let from = data.fromDate?.toDate()?.date.toFormat("MMM dd, yyyy") ?? ""
                cell.secondLabel.text = "Subscribed on: \(from)"
            }
            //Till Date
            if data.toDate == nil || (data.toDate?.isEmpty ?? true) {
                cell.thirdLabel.text = "Valid till: Lifetime"
            } else {
                let till = data.toDate?.toDate()?.date.toFormat("MMM dd, yyyy") ?? ""
                cell.thirdLabel.text = "Valid till: \(till)"
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var type = allData?[section].first?.type
        type = type?.replacingOccurrences(of: "_", with: " ") //remove underscores
        type = type?.capitalized
        return type
    }
    

}

//API
extension MySubscriptionsViewController {
    
    func fetchData() {
        
        guard let userId = AppStateManager.sharedInstance.userData?.user?.id else { return }

        APIManager.sharedInstance.fetchAllSubscription(userId: "\(userId)", success: { (model) in
            self.model = model
        }, failure: { (error) in
            print(error)
        })
    }
    
    func arrangeData() {
        
        guard let data_model = self.model else { return }
        
        var dic = [String: [AllSubscriptionsModel]]()
        
        for modelObj in data_model {
            
            let type = modelObj.type!
            var temp = dic[type] ?? [AllSubscriptionsModel]()
            temp.append(modelObj)
            dic[type] = temp
        }
        
        print(dic)
        
        let allValues = Array(dic.values)
        self.allData = allValues
        
    }
}


class MySubscriptionsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
}
