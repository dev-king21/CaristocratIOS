//
//  TableView.swift
 import Foundation
//import DGElasticPullToRefresh



extension UITableView{
    //Nib name and reusable identifier should be same
    func dequeueReusableCell(ofType: Any) -> UITableViewCell{
        
        self.register(UINib(nibName: String(describing: ofType), bundle: nil), forCellReuseIdentifier: String(describing: ofType))
        
        self.tableFooterView = UIView()

        return self.dequeueReusableCell(withIdentifier: String(describing: ofType))!
    }
    
//    func addPullToRefresh(loaderColor: UIColor,  target: Selector, _ on: Any){
//
//        NotificationCenter.default.addObserver(on, selector: target, name: Notification.Name(target.description), object: nil)
//
//        let circleView = DGElasticPullToRefreshLoadingViewCircle()
//
//        circleView.tintColor = loaderColor
//
//        self.dg_addPullToRefreshWithActionHandler({
//            NotificationCenter.default.post(name: Notification.Name(target.description), object: nil)
//        }, loadingView: circleView)
//
//        self.dg_setPullToRefreshBackgroundColor(.clear)
//
//        self.dg_setPullToRefreshFillColor(Constants.APP_COLOR)
//    }
    
//    func stopRefreshing(){
//
//        self.dg_stopLoading()
//
//    }
    
    
}


