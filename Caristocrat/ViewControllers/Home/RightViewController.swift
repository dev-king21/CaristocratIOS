//
//  RightViewController.swift
 import UIKit
import DZNEmptyDataSet
import RESideMenu

class RightViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var cells: [Cells] = []
    var resetSelection: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeApperence()
        self.sideMenuViewController.delegate = self
    }
     
    
    func customizeApperence() {
        self.prepareTableview()
    }
    
    func registerCells() {
        for cell in cells {
            self.tableView.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func prepareTableview() {
        self.registerCells()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
}

extension RightViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.section].identifier)
        
      
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.section].height
    }
    
}

extension RightViewController: RESideMenuDelegate {
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        if self.resetSelection ?? false {
            deSelectRow()
            resetSelection = false
        }
    }
    
    func deSelectRow() {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}
