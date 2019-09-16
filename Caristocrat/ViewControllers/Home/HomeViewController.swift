    //
//  HomeViewController.swift
//  Bolwala
//
//  Created by     on 4/4/18.
//  Copyright © 2018 Bol. All rights reserved.


import UIKit
import DZNEmptyDataSet
import RESideMenu
import SkeletonView
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var cells: [Cells] = []

    @IBOutlet weak var parentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeApperence()
    }
    
    func customizeApperence() {
        self.prepareTableview()
    }
    
    func registerCells() {
        for cell in cells {
           tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func prepareTableview() {
        self.registerCells()
    }
  
    func reloadSection(identifier: String, countOfCells: Int?) {
        if let sectionIndex = self.cells.index(where: { $0.identifier == identifier }) {
            if let count = countOfCells {
                self.cells[sectionIndex].count = count
            }
            self.tableView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .none)
        }
    }
    
    func getIndexByIdentifier(identifier: String) -> Int? {
        return self.cells.index(where: { $0.identifier == identifier })
    }
   
}

 
extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "Products will show up here, so you can easily view them here later"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Products found"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes) 
    }
    
}
 

