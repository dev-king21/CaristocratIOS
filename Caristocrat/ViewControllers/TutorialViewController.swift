//
//  TutorialViewController.swift
//  Bolwala
//
//  Created by Muhammad Muzammil on 5/9/18.
//  Copyright © 2018 Bol. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var skipButtonTop: UIButton!

    var numbeOfItems = Constants.TUTORIAL_DESCRIPTIONS.count
    
    override func viewDidLoad() {
        customizeApperance()
        self.title = "Tutorial"
        Utility.printFonts()
        AppStateManager.sharedInstance.isTutorialShown = true
        self.navigationController?.navigationBar.isHidden = true
        
//        if let flowLayout = collectView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//            flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize
//        }
    }

    func customizeApperance() {
        self.prepareTableview()
    }
    
    func registerCells() {
        self.collectView?.register(UINib(nibName: TutorialViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TutorialViewCell.identifier)
    }
    
    func prepareTableview() {
        self.registerCells()
        pageControl.numberOfPages = numbeOfItems
        self.collectView?.dataSource = self
        self.collectView?.delegate = self
        self.collectView.isPagingEnabled = true
    }
    
    @IBAction func tappedOnSkipButtonTop() {
        Global.APP_DELEGATE.setupUX()
    }
    
    @IBAction func tappedOnSkipButton() {
       if pageControl.currentPage == numbeOfItems - 1 {
            Global.APP_DELEGATE.presentLoginViewController()
       } else {
         Global.APP_DELEGATE.setupUX()
       }
      
    }
    
    @IBAction func tappedOnNextButton() {
      if pageControl.currentPage == numbeOfItems - 1 {
          Global.APP_DELEGATE.presentSignUpViewController()
      } else {
         collectView.scrollToItem(at: IndexPath(row: pageControl.currentPage + 1, section: 0), at: .right, animated:true)
         pageControl.currentPage = pageControl.currentPage + 1
         setNextButtonTitle()
      }
    }
    
    func setNextButtonTitle() {
        if pageControl.currentPage == numbeOfItems - 1 {
            skipButtonTop.isHidden = false
            
            let normalText = Constants.ALREADY_A_MEMEBER
            let normalString = NSMutableAttributedString(string:normalText)
            
            let boldText  = Constants.CLICK_HERE
            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
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
}
extension TutorialViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectView?.dequeueReusableCell(withReuseIdentifier: TutorialViewCell.identifier, for: indexPath) as! TutorialViewCell
//      cell.tutorialImage.image = UIImage(named: "0\(indexPath.row + 1)step")
        cell.desc.text = Constants.TUTORIAL_DESCRIPTIONS[indexPath.row]
        cell.title.text = Constants.TUTORIAL_TITLES[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbeOfItems
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

        return UIEdgeInsetsMake(0, 0, 0, 10);
    }
    
}
