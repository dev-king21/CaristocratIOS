//
//  FurtherDetailVC.swift
 import UIKit
//import Bottomsheet
import FaveButton
import EasyTipView
import ImageSlideshow


class FurtherDetailVC: BaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var commentView: UIStackView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet var heartButton: FaveButton?
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var sourceTitleLabel: UILabel!
    @IBOutlet weak var sourceURLButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var desctv: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentsCountsLabel: UILabel!
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var viewSlideShow: ImageSlideshow!
    @IBOutlet weak var viewYouTubePlayer: YoutubePlayerView!
    @IBOutlet weak var viewMoreInfo: UIView!
    @IBOutlet weak var commentsParentView: CommentsView!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
     var observing = false
    var MyObservationContext = 0
    var videoID : String = ""

    var newsModel: NewsModel?
    var images: [KingfisherSource] = []
    var isFirstTime = true
    var similarNews: [NewsModel] = []
    var allNews: [NewsModel] = []
    var newsId: Int = -1
    
    //Paging work
    var limit = 10
    var offset = 0
    var isLoading = false
    var tblFooter  = LoadMoreView.instanceFromNib()

    override func viewDidLoad() {
        hideNavBar = true
        super.viewDidLoad()
        
        //viewYouTubePlayer.delegate = self
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnSlideShow(sender:)))
        viewSlideShow.addGestureRecognizer(tapGesture)
        
        self.heartButton?.isSelected = false
        
        if let _ = self.newsModel {
            customizeAppearance()
        } else {
            self.mainScrollView.isHidden = true
            self.getNewsDetail()
        }
        
        
    }
    
    
    
    deinit {
        if observing {
            stopObservingHeight()
        }
    }
    
    func customizeAppearance() {
        //self.prepareCollectionView()
        self.setData()
        self.isAlreadyView()
        heartButton?.delegate = self
        
        commentsParentView.delegate = self
        commentsParentView.newsModel = self.newsModel
    }
    
    func isAlreadyView() {
       // if !(newsModel?.is_viewed ?? false) {
            submitInteraction(type: .View)
        //}
    }
//    let commentsView: CommentsView = .fromNib()
    func setupBottomSheet() {
//        commentsView.newsModel = self.newsModel
//        commentsView.delegate = self
//        commentsView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        bottomController = Bottomsheet.Controller()
//        bottomController?.initializeHeight = UIScreen.main.bounds.height
//        bottomController?.viewActionType = .swipe
//        bottomController?.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
//        bottomController?.addContentsView(commentsView)
//        let view  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        view.addSubview(commentView)
        
//        DispatchQueue.main.async {
//            self.present(self.bottomController!, animated: true, completion: nil)
//        }
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: SimilarNewsCell.identifier, bundle: nil), forCellWithReuseIdentifier: SimilarNewsCell.identifier)
        self.collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "loadingcell")
    }
    
    func prepareCollectionView() {
        self.similarNews = self.allNews
        if let index = self.similarNews.index(where: {$0.id == self.newsModel?.id}) {
            self.similarNews.remove(at: index)
        }
        self.registerCells()
        if self.similarNews.count > 0 {
            noDataFoundLabel.isHidden = true
        }
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
        self.collectView?.reloadData()
    }
    
    func setData() {
        if let news = newsModel {
            self.dateLabel.text = Utility.dateFormatterWithFormat(news.created_at ?? "", withFormat: DateFormats.Date.rawValue)
            titleLabel.text = news.headline
            let viewCount = (news.views_count ?? 0)
            let likeCount = (news.like_count ?? 0)
            let commentsCount = (news.comments_count ?? 0)
            viewsCountLabel.text = viewCount.description + " View\(viewCount > 1 ? "s" : "")"
            likeCountLabel.text = likeCount.description + " Like\(likeCount > 1 ? "s" : "")"
            commentsCountsLabel.text = commentsCount.description + " Comment\(commentsCount > 1 ? "s" : "")"
            let source = news.source ?? ""
            if !source.isEmpty{
                sourceURLButton.setTitle(news.source ?? "", for: .normal)
            }
            else{
                self.viewMoreInfo.alpha = 0.0
            }
            print(news.description)
          //  desctv.attributedText = news.description?.htmlToAttributedString
            var test = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
            
            self.webView.loadHTMLString(test.appending(news.description!), baseURL: nil)
            
            if news.is_liked != heartButton?.isSelected {
                heartButton?.isSelected = news.is_liked ?? false
            }
            
            if isFirstTime {
                if let sourceImageStringURL = news.source_image_url {
                    print(sourceImageStringURL)
                    self.sourceImage.kf.setImage(with: URL(string: sourceImageStringURL), placeholder: #imageLiteral(resourceName: "image_placeholder"))
                }
                if let sourceStringURL = news.media?.first?.file_url {
                    if (news.media?.first?.media_type ?? 0) == 10{
                        //self.bannerImage.kf.setImage(with: URL(string: sourceStringURL))
                        self.loadFeatureNews()
                        self.viewYouTubePlayer.isHidden = true
                    }
                    else{
                        self.viewYouTubePlayer.isHidden = false
                       // print(self.viewYouTubePlayer.ready)
                        print(sourceStringURL)
                        if let sourceURL = URL(string:sourceStringURL){
                            print(self.videoID)

                            let vidID = Utility.extractYoutubeVideoId(from: sourceStringURL)
                            
                            let playerVars: [String: Any] = [
                                "controls": 1,
                                "modestbranding": 1,
                                "playsinline": 1,
                                "rel": 0,
                                "autoplay": 1
                            ]
                            
                            viewYouTubePlayer.loadWithVideoId(vidID!, with: playerVars)
                            
                            
                        }
                    }
                }
            }
            
            isFirstTime = false
        }
    }
    
    func loadFeatureNews() {
        guard let newsImages = newsModel?.media else {return}
        self.images.removeAll()
        for news in newsImages {
            if let source = news.file_url {
                if (news.media_type ?? 0) == 10{
                    guard let kingfisherSource = KingfisherSource(urlString:source) else {return}
                    self.images.append(kingfisherSource)
                }
                else{
                    let youtubeURL = Utility.youtubeThumbnail(url: source)
                    guard let kingfisherSource = KingfisherSource(urlString:youtubeURL) else {return}
                    self.images.append(kingfisherSource)
                }
            }
        }
        
        viewSlideShow.slideshowInterval = 3
        viewSlideShow.contentScaleMode = .scaleAspectFill
        viewSlideShow.setImageInputs(images)
    }
    
    var tipView: EasyTipView?
    func showToolTip() {
        if tipView == nil {
            self.view.alpha = 0.8
            var preferences = EasyTipView.Preferences()
            preferences.drawing.foregroundColor = UIColor.black
            preferences.drawing.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
            
            tipView = EasyTipView(text: newsModel?.is_favorite ?? false ? "Remove from favourites" : "Add to favourites", preferences: preferences, delegate: self)
            
            tipView?.show(forView: self.addFavoriteButton)
        }
    }
    
    func dismissToolTip() {
        if let tipView = tipView {
            self.view.alpha = 1
            tipView.dismiss()
            self.tipView = nil
        }
    }
    
    func submitInteraction(type: InteractionType) {
        APIManager.sharedInstance.newsInteraction(newsId: newsModel?.id ?? 0,
                                                  interactionType: type,
                                                  success: { (result) in
            self.updateInteraction(type: type)
            if type == .Favorite {
                Utility.showSuccessWith(message:  self.newsModel?.is_favorite ?? false ? "Added to favourites" : "Removed from favourites" )
            }
        }) { (error) in

        }
    }
    
    func updateInteraction(type: InteractionType) {
//        switch (type) {
//        case .Like:
//            if newsModel?.is_liked ?? false {
//                newsModel?.is_liked = false
//            } else {
//                newsModel?.is_liked = true
//            }
//            likeCountLabel.text = ((Int(likeCountLabel.text ?? "0") ?? 0) + (newsModel?.is_liked ?? false ? +1 : -1 )).description
//            break
//        case .View:
////            newsModel?.is_viewed = !(newsModel?.is_viewed ?? false) // Crash: Simulteneosly Access :(
//            if newsModel?.is_viewed ?? false {
//                newsModel?.is_viewed = false
//            } else {
//                newsModel?.is_viewed = true
//            }
//            viewsCountLabel.text = ((Int(likeCountLabel.text ?? "0") ?? 0) + (newsModel?.is_viewed ?? false ? +1 : -1 )).description
//            break
//
//        case .Favorite:
//            // newsModel?.is_favorite = !(newsModel?.is_favorite ?? false) // Crash: Simulteneosly Access :(
//            if newsModel?.is_favorite ?? false {
//                newsModel?.is_favorite = false
//            } else {
//                newsModel?.is_favorite = true
//            }
//            break
//
//        }
        
        switch (type) {
            case .Like:
                self.getNewsDetail()
                break
            case .View:
                NotificationCenter.default.post(name: Notification.Name(Events.onNewsSeen.rawValue), object: nil)
                self.getNewsDetail()
//                if newsModel?.views_count != nil {
//                    let a = newsModel!.views_count! + 1
//                    self.newsModel?.views_count = a
//                    self.setData()
//
//                }
                
                //self.notifyNewsUpdate()
                break
            case .Favorite:
                // newsModel?.is_favorite = !(newsModel?.is_favorite ?? false) // Crash: Simulteneosly Access :(
                if newsModel?.is_favorite ?? false {
                    newsModel?.is_favorite = false
                } else {
                    newsModel?.is_favorite = true
                }
                break
            default:
            
            break
        }
        
        
    }
    
    func getNewsDetail() {

        
        APIManager.sharedInstance.getNewsDetail(newsId: newsModel?.id ?? newsId , success: { (result) in
            self.mainScrollView.isHidden = false
            if let _ = self.newsModel {
                self.newsModel = result
                self.setData()
                self.notifyNewsUpdate()
            } else {
                self.newsModel = result
                self.customizeAppearance()
                self.getSimilarNews()
            }
            
        }, failure: { (error) in
            
        }, showLoader: self.newsModel == nil)
    }
    
    func getSimilarNews() {
        
        let showloader = offset == 0 ? true:false
        
        APIManager.sharedInstance.getNewsWithPagination(categoryId: self.newsModel?.category_id ?? -1, limit: limit,offset: offset, success: { (result) in
            self.allNews += result
            
            if (self.allNews.count) <  LastService.totalCount {
                self.isLoading = true
            }else{
                self.isLoading = false
            }
            
            self.prepareCollectionView()

            
        }, showLoader: showloader) { (error) in
            
        }
    }
    
    @IBAction func tappedParentView() {
        self.dismissToolTip()
    }
    
    @IBAction func tappedOnComments() {
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            self.commentsParentView.animShow()
        } else {
            AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see your Profile. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tappedOnBack(_ sender: Any) {
        self.dismissToolTip()
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else  {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedOnFav(_ sender: Any) {
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            self.showToolTip()
        } else {
            AlertViewController.showAlert(title: "Require Signin", description: "This action requires a user signin. Do you want to signin ?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tappedOnShare(_ sender: Any) {
        let string = self.newsModel?.headline ?? ""
        //let url = URL(string: self.newsModel?.media?.first?.file_url ?? "www.google.com")!
        let url = URL(string: self.newsModel?.link2 ?? "www.google.com")!
        var image = #imageLiteral(resourceName: "image_placeholder")
        if let imageData = try? Data(contentsOf: url){
            image = UIImage(data: imageData) ?? #imageLiteral(resourceName: "image_placeholder")
        }
       // let activityViewController = UIActivityViewController(activityItems: [string, url,image], applicationActivities: nil)
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedOnLink(_ sender: Any) {
        //guard let url = URL(string: sourceURLButton.titleLabel?.text ?? "") else { return }
         //   UIApplication.shared.open(url)
        let controller = InAppWebView.instantiate(fromAppStoryboard: .Home)
        controller.linkString = sourceURLButton.titleLabel?.text ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func tappedOnFeatureNews() {
        let currentPage = self.viewSlideShow.currentPage
        let controller = SlideShow.instantiate(fromAppStoryboard: .Home)
        controller.cur_image_index = currentPage
        controller.ImageSliderArray = self.images
        
    }
    
    @objc func didTapOnSlideShow(sender:UIGestureRecognizer){
        if let slideShowView = sender.view as? ImageSlideshow{
            let currentPage = slideShowView.currentPage
            let controller = SlideShow.instantiate(fromAppStoryboard: .Home)
            controller.cur_image_index = currentPage
            controller.ImageSliderArray = self.images
            if self.navigationController != nil{
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else{
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func increaseCommentsCount() {
//        commentsCountsLabel.text = ((Int(commentsCountsLabel.text.spl ?? "0") ?? 0) + 1 ).description
        self.getNewsDetail()
        //self.notifyNewsUpdate()
    }
    
    func notifyNewsUpdate() {
        NotificationCenter.default.post(name: Notification.Name(Events.onNewsUpdate.rawValue), object: nil ,userInfo:["news":newsModel!])
    }
    
    @IBAction func tappedOnWriteComment() {
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            self.commentsParentView.animShow()
        } else {
            
            AlertViewController.showAlert(title: "Require Signin", description: "This action requires a user signin. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
        }
    }
    
    func moveAhead(newsModel: NewsModel) {
        let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
        
        //furtherDetailVC.newsModel = newsModel
        furtherDetailVC.newsId = newsModel.id!
       // furtherDetailVC.allNews = allNews
        self.navigationController?.pushViewController(furtherDetailVC, animated: true)
    }
}

extension FurtherDetailVC: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        self.submitInteraction(type: .Favorite)
        dismissToolTip()
    }
}

extension FurtherDetailVC: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
        
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            self.submitInteraction(type: .Like)
        } else {
                self.heartButton?.isSelected = false
                AlertViewController.showAlert(title: "Require Signin", description: "This action requires a user signin. Do you want to signin?") {
                    let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                    signinController.isGuest = true
                    self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
                }
            
        }
    }
}

extension FurtherDetailVC: WriteCommentDelegate {
    func didCommentSent() {
        self.increaseCommentsCount()
    }
    
    func closeView() {
//        self.dismiss(animated: true, completion: nil)
    }
}

extension FurtherDetailVC: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == (similarNews.count){
            let cell = collectView?.dequeueReusableCell(withReuseIdentifier: "loadingcell", for: indexPath)
            tblFooter.frame = (cell?.contentView.bounds)!
            tblFooter.lblLoading.isHidden = true
            cell?.contentView.addSubview(tblFooter)
            return cell!
        }else{
            let cell = collectView?.dequeueReusableCell(withReuseIdentifier: SimilarNewsCell.identifier, for: indexPath) as! SimilarNewsCell
            
            cell.setData(newModel: self.similarNews[indexPath.row])
            
            return cell
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading == true ? similarNews.count+1:similarNews.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveAhead(newsModel: self.similarNews[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == (similarNews.count){
            return CGSize(width: 50 , height: 195)
        }else{
            return CGSize(width: (UIScreen.main.bounds.width / 2) , height: 195)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        checkForMoreRecords(indexNo: indexPath.row)
    }
    func checkForMoreRecords(indexNo : Int) {
        
        if indexNo == (similarNews.count) - 1 {
            if (allNews.count) < LastService.totalCount {
                
                offset = offset+limit //--ww (pageNo * limit) - 1
                
                getSimilarNews()
            }else{
               // self.collectView.
            }
        }
        
    }
    
}


extension FurtherDetailVC : UIWebViewDelegate {
    
   
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        webView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "contentSize":
            if context == &MyObservationContext {
                webViewHeight.constant = webView.scrollView.contentSize.height
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewHeight.constant = webView.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
}


//extension FurtherDetailVC : YouTubePlayerDelegate{
//
//
//
//    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState){
//        print("Player state changed! \(playerState)")
//    }
//}
