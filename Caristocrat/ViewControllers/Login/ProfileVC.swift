    //
//  ProfileVC.swift
 import UIKit
import Kingfisher
import DZNEmptyDataSet
    
    
class ProfileVC: BaseViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutHeadingLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressPercent: NSLayoutConstraint!
    @IBOutlet weak var carsColectionView: UICollectionView!
    @IBOutlet weak var btnCompleteNow: UIButton!
    
    var favNews: [NewsFavoriteModel] = []
    var myVehicles: [VehicleBase] = []
    var myFavVehicles: [VehicleBase] = []
    var currentIndex: Int = 0
    var isProfileCompleted = false

    override func viewDidLoad() {
        hideNavBar = true
        super.viewDidLoad()
        self.customizeAppearance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getFavNews()
        self.getFavoriteCars()
        self.getMyCars()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setData()
    }
    
    func customizeAppearance() {
        self.registerCells()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.emptyDataSetSource = self
        self.tableview.emptyDataSetDelegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.carsColectionView.delegate = self
        self.carsColectionView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.getFavNews),
            name: NSNotification.Name(rawValue: Events.onNewsUpdate.rawValue),
            object: nil)
    }
    
    func registerCells() {
      self.tableview.register(UINib(nibName: CategoryDetailCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryDetailCell.identifier)
      self.tableview.register(UINib(nibName: MyTradeInsCell.identifier, bundle: nil), forCellReuseIdentifier: MyTradeInsCell.identifier)
      self.carsColectionView?.register(UINib(nibName: MyCarCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyCarCell.identifier)
        self.carsColectionView?.register(UINib(nibName: AddMyCarCell.identifier, bundle: nil), forCellWithReuseIdentifier: AddMyCarCell.identifier)
    }
    
    func getMyCars() {
        APIManager.sharedInstance.getMyCars(params: ["favorite": 1], success: { (result) in
            self.myVehicles = result
            self.carsColectionView.reloadData()
            self.reloadItems()
        }) { (error) in
            
        }
    }
    
    func getFavoriteCars() {
        let params : Parameters = ["favorite" : 1]

        APIManager.sharedInstance.getVehicles(params: params, success: { (result) in
            self.myFavVehicles = result
            self.tableview.reloadData()
            
        }) { (error) in
            print("")
        }
    }
    
    @IBAction func tappedOnSettings() {
        let settingsController = SettingsVC.instantiate(fromAppStoryboard: .Login)
        present(settingsController, animated: true, completion: nil)
    }
    
    @IBAction func tappedOnBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnCompleteNow() {
        if isProfileCompleted {
            Utility.showSuccessWith(message: Messages.ProfileCompleted.rawValue)
        } else {
            let editProfileController = EditProfileViewController.instantiate(fromAppStoryboard: .Login)
            present(editProfileController, animated: true, completion: nil)
        }

    }
    
    @IBAction func tappedOnJoinTheClub() {
        Utility.showInformationWith(message: Messages.ImplementLater.rawValue)
    }
    
    @IBAction func tappedOnMyTradeIns() {
        let myTradeInsController = MyTradeInsController.instantiate(fromAppStoryboard: .Login)
        myTradeInsController.type = .trade
        self.navigationController?.pushViewController(myTradeInsController, animated: true)
    }
    
    @IBAction func tappedOnMyCarEvaluations() {
        let myTradeInsController = MyTradeInsController.instantiate(fromAppStoryboard: .Login)
        myTradeInsController.type = .evaluate
        self.navigationController?.pushViewController(myTradeInsController, animated: true)
    }
    
    func setData() {
        if let userData = AppStateManager.sharedInstance.userData?.user {
            nameLabel.text = userData.details?.first_name
            emailLabel.text = userData.email
            if !(userData.details?.phone.unWrap.isEmpty ?? true) {
                phoneLabel.text = (userData.details?.country_code.unWrap ?? "") + " " + (userData.details?.phone.unWrap ?? "")
            }
            let gender = userData.details?.gender ?? 0
            profileImage.kf.setImage(with: URL(string: userData.details?.image_url ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            if !(userData.details?.about?.isEmpty ?? true) {
                aboutLabel.text =  userData.details?.about ?? ""
                aboutHeadingLabel.isHidden = false
            }
            else{
                aboutLabel.isHidden = true
                aboutHeadingLabel.isHidden = true
            }
            let alottedPercentage = 10.0
            var progress = 0.0
            progress += (userData.details?.first_name?.isEmpty ?? true) ? 0 : alottedPercentage
            progress += (userData.email?.isEmpty ?? true) ? 0 : alottedPercentage
//            progress += (userData.details?.country_code?.isEmpty ?? true) ? 0 : alottedPercentage
            progress += (userData.details?.phone?.isEmpty ?? true) ? 0 : 20
            progress += (userData.details?.image_url?.isEmpty ?? true) ? 0 : alottedPercentage
            progress += (userData.details?.dob?.isEmpty ?? true) ? 0 : alottedPercentage
            progress += (userData.details?.nationality?.isEmpty ?? true) ? 0 : alottedPercentage
            progress += (userData.details?.profession?.isEmpty ?? true) ? 0 : alottedPercentage
            if gender != 0{
                progress += alottedPercentage
            }
            
            progress += (userData.details?.about?.isEmpty ?? true) ? 0 : alottedPercentage

            progressPercent = progressPercent.setMultiplier(multiplier: CGFloat(progress / 100.0))

            progressLabel.text = "\(Int(progress.rounded()))% Complete"
            isProfileCompleted = Int(progress.rounded()) == 100
            if isProfileCompleted {
                self.btnCompleteNow.setTitle("Completed", for: .normal)
            }
            else{
                self.btnCompleteNow.setTitle("Complete Now", for: .normal)
            }
        }

    }
    
    @objc func getFavNews() {
        APIManager.sharedInstance.getFavoriteNews(success: { (result) in
            self.favNews = result
            self.reloadItems()
        }) { (error) in
            
        }
    }
    
    func reloadItems() {
        if currentIndex == 0 {
            let count = CGFloat(myFavVehicles.count)
            self.tableViewHeight.constant = (count == 0 ? 1 : count)  * 110
        } else {
            if favNews.count > (currentIndex - 1) {
                let count = CGFloat(favNews[(currentIndex - 1)].news?.count ?? 0)
                self.tableViewHeight.constant = (count == 0 ? 1 : count)  * 110
            }
        }
        
        
        self.tableview.reloadData()
        self.collectionView.reloadData()
    }
    
    func moveAhead(row: Int) {
        let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
        if let news = favNews[(currentIndex - 1)].news {
          furtherDetailVC.newsModel = news[row]
        }
        self.present(furtherDetailVC, animated: true)
    }
    
    func moveToCarDetail(index: Int) {
        let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
        vehicleController.carId = myFavVehicles[index].id ?? 0
        vehicleController.vehicleDetail = self.myFavVehicles[index]
        vehicleController.slug = self.myFavVehicles[index].category?.slug ?? ""
        self.navigationController?.pushViewController(vehicleController, animated: true)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 1 {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return favNews.count + 1
        } else {
            switch section{
            case 0:
                return 1
            case 1:
                return myVehicles.count
            default:
                return 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        if collectionView.tag == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavNewsTabCell.identifier, for: indexPath)
            
            if let cell = cell as? FavNewsTabCell {
                if indexPath.row == 0 {
                    cell.setTitle(title: " Cars ")
                } else {
                    cell.setData(favNewsModel: favNews[indexPath.row-1])
                }
                
                if currentIndex == indexPath.row {
                    cell.backgroundColor = UIColor.black
                    cell.titleLabel?.textColor = UIColor.white
                } else {
                    cell.backgroundColor = UIColor.white
                    cell.titleLabel?.textColor = UIColor.black
                }
            }
        } else {
            switch indexPath.section{
            case 0:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMyCarCell.identifier, for: indexPath) as! AddMyCarCell
            case 1:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCarCell.identifier, for: indexPath) as! MyCarCell
                if let cell = cell as? MyCarCell {
                    cell.setData(vehicleDetail: myVehicles[indexPath.row])
                }
            default:
                return UICollectionViewCell()
            }
           
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 && indexPath.section == 0{
            self.navigationController?.pushViewController(TradeCarController.instantiate(fromAppStoryboard: .Home), animated: true)
            return
        }
        else if collectionView.tag == 2 && indexPath.section == 1{
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "TradeCarController") as! TradeCarController
            controller.tradeCarType = .editAddedCar
            controller.selectedVehicleDetail = self.myVehicles[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            currentIndex = indexPath.row
            self.reloadItems()
        }
    }
    
    func collectionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if collectionView.tag == 1 {
            if indexPath.row == 0 {
                if var textSize = Utility.getWidthOfText(text: " Cars ") {
                    textSize.width += 5
                    textSize.height = 30
                    return textSize
                }
            } else {
                let text = favNews[indexPath.row-1].name
                if var textSize = Utility.getWidthOfText(text: text ?? "") {
                    textSize.width += 5
                    textSize.height = 30
                    return textSize
                }
            }
            
        }
        
        return CGSize(width: 175, height: 175)

    }
    
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTradeInsCell.identifier) as! MyTradeInsCell
            cell.setData(vehicleDetail: myFavVehicles[indexPath.row], forEvaluation: false, forFavorite: true)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailCell.identifier)
            
            if let categoryDetailCell = cell as? CategoryDetailCell {
                if let news = favNews[(currentIndex - 1)].news {
                    categoryDetailCell.isForProfile = true
                    categoryDetailCell.setData(news: news[indexPath.row])
                }
                
                return categoryDetailCell
            }
        }
        
       
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentIndex == 0 {
            return myFavVehicles.count
        } else if favNews.count > (currentIndex - 1) {
            return favNews[(currentIndex - 1)].news?.count ?? 0
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIndex > 0 {
            self.moveAhead(row: indexPath.row)
        }  else {
           self.moveToCarDetail(index: indexPath.row)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

extension ProfileVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = ""
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You have not added anything in your favorites"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

