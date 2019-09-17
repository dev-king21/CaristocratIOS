//
//  TableViewCell.swift
 import Foundation


extension UITableViewCell
{
    static func dequeueReusableCell(tableView: UITableView, ofType: Any) -> UITableViewCell
    {
        tableView.register(UINib(nibName: String(describing: ofType), bundle: nil), forCellReuseIdentifier: String(describing: ofType))
        return tableView.dequeueReusableCell(withIdentifier: String(describing: ofType))!
        
    }
}
