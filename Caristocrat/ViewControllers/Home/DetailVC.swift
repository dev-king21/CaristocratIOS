//
//  AutoDetailVC.swift
 import UIKit
import ImageSlideshow
import Kingfisher
import DZNEmptyDataSet

class DetailVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var lblFeaturedThisWeek: UILabel!
    @IBOutlet weak var featureSlideConstriant: NSLayoutConstraint!
    @IBOutlet weak var featureSlideShow: ImageSlideshow!
    var categoryId: Int = 0
    var news: [NewsModel] = []
    var featuredNews: [NewsModel] = []
    var needToReload = false
    var videoID : String = ""
    
    var removeUnreadCount : (() -> Void)?

    //Paging work
    var limit = 10
    var offset = 0

    var tblFooter  = LoadMoreView.instanceFromNib()
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeApperence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if needToReload {
//            self.getNews()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
  
    func customizeApperence() {
        self.prepareTableview()
        self.getNews()
        featureSlideShow.slideshowInterval = 3
        featureSlideShow.contentScaleMode = .scaleAspectFill
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.OnNewsUpdate(_:)),
            name: NSNotification.Name(rawValue: Events.onNewsUpdate.rawValue),
            object: nil)
    }
    
    func prepareTableview() {
        self.registerCells()
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    
    func setEmptyDataSet() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    func moveAhead(row: Int, isFeature: Bool) {
        let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
        //furtherDetailVC.newsModel = isFeature ? featuredNews[row] : news[row]
        furtherDetailVC.newsId = (isFeature ? featuredNews[row].id : news[row].id)!
//        furtherDetailVC.allNews = featuredNews
//        furtherDetailVC.allNews += news
//        if news[row].media?.first?.media_type == 20{
//            self.videoID = Utility.extractYoutubeVideoId(from: (self.news[row].media?.first?.file_url)!)!
//            furtherDetailVC.videoID = self.videoID
//        }
        self.navigationController?.pushViewController(furtherDetailVC, animated: true)
       
    }
    
    @objc func OnNewsUpdate(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let news = dict["news"] as? NewsModel{
                if news.is_featured == 1 {
                    if let index = featuredNews.firstIndex(where: {$0.id == news.id}){
                        self.featuredNews[index] = news
                    }
                    
                }else{
                    if let index = self.news.firstIndex(where: {$0.id == news.id}){
                        self.news[index] = news
                    }
                }
            }
        }
        
        tableView.reloadData()
        
        //self.needToReload = true
    }
    
    @objc func getNews() {
        let showloader = offset == 0 ? true:false
        APIManager.sharedInstance.getNewsWithPagination(categoryId: categoryId, limit: limit, offset: offset, success: { (result)  in
            
            self.news += result.filter({ (news) -> Bool in
                return news.is_featured == 0
            })
            
            self.featuredNews += result.filter({ (news) -> Bool in
                return news.is_featured == 1
            })

            
            if (self.news.count+self.featuredNews.count) <  LastService.totalCount {
                self.tableView.tableFooterView = self.tblFooter
            }else{
                 self.tableView.tableFooterView = nil //CustomReferesh.getCustomLoaderToFooter()
            }
            
            
            if self.featuredNews.count == 0 && self.featureSlideConstriant != nil &&  self.featureSlideConstriant.isActive {
                self.featureSlideConstriant.isActive = false
            }
            
            if self.news.count == 0 && self.featuredNews.count == 0 {
                self.featureSlideShow.isHidden = true
                self.setEmptyDataSet()
            }
            else{
                self.lblFeaturedThisWeek.isHidden = true
            }
            
            self.loadFeatureNews()
            
            if showloader {
                NotificationCenter.default.post(name: Notification.Name(Events.onNewsSeen.rawValue), object: nil)
            }
            
            self.tableView.reloadData()
            
            self.removeUnreadCount?()
            
        }, showLoader: showloader) { (error) in   //self.news.count == 0 && self.featuredNews.count == 0
            
        }
    }
    
    func registerCells() {
        self.tableView.register(UINib(nibName: CategoryDetailCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryDetailCell.identifier)
    }
    
    func loadFeatureNews() {
        var images: [KingfisherSource] = []
//        for news in featuredNews {
//            if let media = news.media, media.count > 0 {
//                if let source = KingfisherSource(urlString: media[0].file_url ?? "") {
//                    images.append(source)
//                }
//            }
//        }
        for news in featuredNews {
            if let source = news.media?.first?.file_url {
                if (news.media?.first?.media_type ?? 0) == 10{
                    guard let kingfisherSource = KingfisherSource(urlString:source) else {return}
                    images.append(kingfisherSource)
                }
                else{
                    let youtubeURL = Utility.youtubeThumbnail(url: source)
                    guard let kingfisherSource = KingfisherSource(urlString:youtubeURL) else {return}
                    images.append(kingfisherSource)
                }
            }
        }

        featureSlideShow.willBeginDragging = {
            self.titleLabel.fadeOut()
            self.descLabel.fadeOut()
        }
        
        featureSlideShow.currentPageChanged = { (page: Int) -> Void in
            self.titleLabel.text = " "+(self.featuredNews[page].headline ?? "")+" "
            
            self.titleLabel.text = self.titleLabel.text?.uppercased()
            self.descLabel.attributedText =  self.featuredNews[page].description?.htmlToAttributedString
            
        }
        
        featureSlideShow.didEndDecelerating = {
            self.titleLabel.fadeIn()
            self.descLabel.fadeIn()
        }
        
        if featuredNews.count > 0 {
            self.titleLabel.text = " "+(self.featuredNews[0].headline ?? "")+" "
            self.titleLabel.text = self.titleLabel.text?.uppercased()
            self.descLabel.text = self.featuredNews[0].description
        }
        featureSlideShow.setImageInputs(images)
    }
    
    @IBAction func tappedOnSearch() {
        Utility.showInformationWith(message: Messages.ImplementLater.rawValue)
    }
    
    @IBAction func tappedOnHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
        
    @IBAction func tappedOnFeatureNews() {
        if self.news.isEmpty && self.featuredNews.isEmpty {return}
        self.moveAhead(row: featureSlideShow.pageControl.currentPage, isFeature: true)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
   
}

extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailCell.identifier) as? CategoryDetailCell {
            cell.setData(news: news[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        needToReload = false
        self.moveAhead(row: indexPath.row, isFeature: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        heightDictionary[indexPath.row] = cell.frame.size.height
        
        checkForMoreRecords(indexNo: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
    }
    
    
    func checkForMoreRecords(indexNo : Int) {
    
        if indexNo == (news.count) - 1 {
            if (news.count+featuredNews.count) < LastService.totalCount {

                offset = offset+limit //--ww (pageNo * limit) - 1
                
                getNews()
            }else{
                self.tableView.tableFooterView = nil
            }
        }

    }

    
    
}

extension DetailVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "Data will show up here, so you can easily view them here later"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Data found"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}


