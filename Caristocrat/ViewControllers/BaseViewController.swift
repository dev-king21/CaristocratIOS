
import UIKit
import Device
import NVActivityIndicatorView
import SwiftMessages
import RESideMenu
import SkeletonView

protocol ACBaseViewControllerSearchDelegate {
    
    func searchWith(term: String)
    
    func cancelSearch()
}


class BaseViewController: UIViewController, NVActivityIndicatorViewable {

    
    var isColorBar = false
    
    var searchButton: UIBarButtonItem!
    
    var searchDelegate: ACBaseViewControllerSearchDelegate?
    
    var searchBar = UISearchBar()
    
    var leftSearchBarButtonItem : UIBarButtonItem?
    
    var rightSearchBarButtonItem : UIBarButtonItem?
    
    var cancelSearchBarButtonItem: UIBarButtonItem?
    
    var logoImageView : UIImageView!
    
    var transparentNavBar = false
    var hideNavBar = false
    var navTitle: String = ""
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = hideNavBar
        navigationItem.setHidesBackButton(true, animated: false)
        
        if transparentNavBar {
          setupTransparentNavBar()
        }
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            addBackButtonToNavigationBar()
       }

        setNavTitle(title: navTitle)
        setNavTitleFont()
        closeKeyboard()
    }
    
    func closeKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setNavTitleFont() {
        if let font = UIFont(name: FontsType.Heading.rawValue, size: 24){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:UIColor.black]

        }
        
    }
    
    func setNavTitle(title: String) {
        if (!title.isEmpty) {
          self.title = title
        }
    }
    
    func setupColorNavBar(){
        if let font = UIFont(name: "Raleway-Medium", size: 18){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.barStyle = .black
        }
        
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 199.0/255.0, green: 16.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //    UIColor(red: 189.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        
        self.navigationItem.leftBarButtonItem = nil
    }

    

    func setupTransparentNavBar(){
        if let font = UIFont(name: "Raleway-Medium", size: 18){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:UIColor.black]
            self.navigationController?.navigationBar.barStyle = .default
        }
        
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.barTintColor = UIColor.red //UIColor(red: 189.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //    UIColor(red: 189.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = hideNavBar
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addBackButtonToNavigationBar(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "back_button"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        var leftBar: [UIBarButtonItem] = []
        leftBar.append(self.leftSearchBarButtonItem!)
        if let barItem = self.navigationItem.leftBarButtonItem {
            barItem.imageInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            leftBar.append(barItem)
        }
        self.navigationItem.leftBarButtonItems = leftBar
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }

    
    func addMenuButtonToNavigationBar(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "side_menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(showSideMenu))
        
        self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem;
    }
    
    func addSearchButtonToNavigationBar(){
       self.rightSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(doSearch))
        self.navigationItem.rightBarButtonItem = self.rightSearchBarButtonItem;
    }
    
    @objc func goBack(){
       self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doSearch(){
        self.showSearchbar()
    }
    
    @objc func showSideMenu(){
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

   
    @available(*, deprecated, message: "Use startSkeletonAnimation() instead.")
    func startLoading(){
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: "", type: NVActivityIndicatorType.ballTrianglePath)

    }
    
    @available(*, deprecated, message: "Use stopSkeletonAnimation() instead.")
    func stopLoading(){
        stopAnimating()
    }

    func startSkeletonAnimation(){
        self.view.startSkeletonAnimation()
    }
    func stopSkeletonAnimation(){
        self.view.stopSkeletonAnimation()
    }

       
    
    func showErrorWith(message: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "", body: message)
        //error.button?.setTitle("Stop", for: .normal)
        error.button?.isHidden = true
        SwiftMessages.show(config: config, view: error)
    }
    
    
    
    
    func hideSearchBarAndMakeUIChanges(){
       
        navigationItem.setRightBarButton(self.rightSearchBarButtonItem, animated: true)
        navigationItem.setLeftBarButton(self.leftSearchBarButtonItem, animated: true)

        let navigationTitlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        navigationTitlelabel.center = CGPoint(x: 160, y: 284)
        navigationTitlelabel.textAlignment = NSTextAlignment.center
        navigationTitlelabel.textColor  = UIColor.white
        navigationTitlelabel.text = "Car Stock"
        
        if let font = UIFont(name: "Roboto-Light", size: 18){
            navigationTitlelabel.font = font
        }
        searchBar.text = ""
        
        self.navigationController!.navigationBar.topItem!.titleView = navigationTitlelabel
        
        
        self.searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 0;
        }, completion: { finished in
            self.searchBar.isHidden = true
        })
    }
    
    func hideSearchBar(){
        
        self.hideSearchBarAndMakeUIChanges()
    
    }
   
 
    
    func activateInitialSetupUI(){
    
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        
    }
    
    
    func showSearchbar(){
        searchBar.alpha = 0
        searchBar.isHidden = false
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.white
         UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
        
        searchBar.setImage( UIImage.init(named: "search"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        

        navigationItem.titleView = searchBar
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.setLeftBarButton(nil, animated: true)

        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1;
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
}

extension BaseViewController: UISearchBarDelegate{


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if(self.searchDelegate != nil){
            self.searchDelegate?.searchWith(term: searchBar.text!)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.setHidesBackButton(true, animated: false)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if(self.searchDelegate != nil){
            self.searchDelegate?.cancelSearch()
        }

        hideSearchBar()
    }
}


