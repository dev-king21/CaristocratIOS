//
//  TutorialViewController.swift
 import UIKit
import AVFoundation
import AVKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var skipButtonTop: UIButton!

    var numbeOfItems = Constants.TUTORIAL_DESCRIPTIONS.count
    var data : [TutorialData] = []
    
    override func viewDidLoad() {
        customizeApperance()
        nextButton.isHidden = true
        skipButton.isHidden = true
        self.title = "Tutorial"
        Utility.printFonts() 
        AppStateManager.sharedInstance.isTutorialShown = true
        self.navigationController?.navigationBar.isHidden = true
        
//        if let flowLayout = collectView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//            flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getTutorialData()
    }

    
    func getTutorialData() {
        
        APIManager.sharedInstance.getTutorialData(success: { (result) in
            self.data = result
            print(self.data.count)
            if(self.data.count == 0) {
                Global.APP_DELEGATE.setupUX()
                return
            }
            
            if self.data.count == 1 {
                self.setNextButtonTitle()
            }

            self.nextButton.isHidden = false
            self.skipButton.isHidden = false
            self.pageControl.numberOfPages = self.data.count
            self.collectView.reloadData()
            
        }) { (error) in
            
        }
    }
    
    func customizeApperance() {
        self.prepareTableview()
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: TutorialViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TutorialViewCell.identifier)
    }
    
    func prepareTableview() {
        self.registerCells()
      //  pageControl.numberOfPages = self.data.count
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
        self.collectView.isPagingEnabled = true
    }
    
    @IBAction func tappedOnSkipButtonTop() {
        Global.APP_DELEGATE.setupUX()
    }
    
    @IBAction func tappedOnSkipButton() {
       if pageControl.currentPage == data.count - 1 {
            Global.APP_DELEGATE.presentLoginViewController()
       } else {
         Global.APP_DELEGATE.setupUX()
       }
      
    }
    
    @IBAction func tappedOnNextButton() {
      if pageControl.currentPage == data.count - 1 {
          Global.APP_DELEGATE.presentSignUpViewController()
      } else {
         collectView.scrollToItem(at: IndexPath(row: pageControl.currentPage + 1, section: 0), at: .right, animated:true)
         pageControl.currentPage = pageControl.currentPage + 1
         setNextButtonTitle()
      }
    }
    
    func setNextButtonTitle() {
        if pageControl.currentPage == data.count - 1 {
            skipButtonTop.isHidden = false
            
            let normalText = Constants.ALREADY_A_MEMEBER
            let normalString = NSMutableAttributedString(string:normalText)
            
            let boldText  = Constants.CLICK_HERE
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            normalString.append(attributedString)

            pageControl.isHidden = true
            self.collectView.isScrollEnabled = false
            skipButton.setAttributedTitle(normalString, for: .normal)
            nextButton.setTitle(Constants.SIGNUP, for: .normal)
        } else {
            skipButtonTop.isHidden = true
            skipButton.setTitle(Constants.SKIP, for: .normal)
            nextButton.setTitle(Constants.NEXT, for: .normal)
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}
extension TutorialViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: TutorialViewCell.identifier, for: indexPath) as! TutorialViewCell
        //      cell.tutorialImage.image = UIImage(named: "0\(indexPath.row + 1)step")
        //Constants.TUTORIAL_DESCRIPTIONS[indexPath.row]
        
        
        cell.desc.text =  self.data[indexPath.row].content ?? ""
        cell.title.text = self.data[indexPath.row].title ?? ""
        
        if(self.data[indexPath.row].media!.count > 0){
            
            if(self.data[indexPath.row].typeText  == "Text with Video"){
                
                cell.tutorialImage.isHidden = false
                cell.btnPlay.isHidden = false
                
                let url = URL(string: (self.data[indexPath.row].media?.first?.fileUrl)!)!
                print("URL------->" , url)
                DispatchQueue.global(qos: .background).async{
                    let thumbnailImage = self.getThumbnailImage(forUrl: url)
                    DispatchQueue.main.async {
                        cell.tutorialImage.image = thumbnailImage
                    }
                }
            }
            
            if(self.data[indexPath.row].typeText  == "Image Only"){
                
                cell.tutorialImage.isHidden = false
                cell.btnPlay.isHidden = true
                
             print("IMAGE URL -------->"  , self.data[indexPath.row].media?.first?.fileUrl)
             cell.tutorialImage.kf.setImage(with: URL(string: self.data[indexPath.row].media?.first?.fileUrl ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            }
            
            if(self.data[indexPath.row].typeText  == "Text with Image"){
                
                cell.tutorialImage.isHidden = false
                cell.btnPlay.isHidden = true
                
                print("IMAGE URL -------->"  , self.data[indexPath.row].media?.first?.fileUrl)
                cell.tutorialImage.kf.setImage(with: URL(string: self.data[indexPath.row].media?.first?.fileUrl ?? ""), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            }
            
        }else{
            
            cell.tutorialImage.isHidden = true
            cell.btnPlay.isHidden = true
        }
        
        
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: cells.count == 1 ? UIScreen.main.bounds.width : (UIScreen.main.bounds.width * 0.80), height: frame.height)
        return CGSize(width: UIScreen.main.bounds.width,height: collectView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            pageControl.currentPage = (self.collectView.indexPath(for: self.collectView.visibleCells.first!)?.row)!
            setNextButtonTitle()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10);
    }
    
}

extension TutorialViewController : TutorialViewCellDelegate {
    
    func didTapPlayButton(indexPath: IndexPath) {
        
        let videoURL = URL(string: self.data[indexPath.row].media?.first?.fileUrl ?? "")
        print(videoURL!)
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        //        playervc.delegate = self
        playervc.player = player
        Utility().topViewController()?.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
}
