//
//  SortModesView.swift
 import Foundation
class ReviewsSortModesView: UIView {
    
    var lastSelected: UIButton?
    @IBOutlet weak var newToOldButton: UIButton?
    @IBOutlet weak var hightReviewButton: UIButton?
    var delegate: SortModesDelegates?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let sortModesView = UINib(nibName: "ReviewsSortModesView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as! UIView
        sortModesView.frame = self.bounds
        
        addSubview(sortModesView)
        
        hightReviewButton?.isSelected = true
        lastSelected = hightReviewButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func tappedOnSortMode(_ sender: UIButton) {
        if let button = self.lastSelected {
            button.isSelected = false
        }
        sender.isSelected = !sender.isSelected
        self.lastSelected = sender
        
        delegate?.didChangeMode(sortMode: ReviewsSortModes(rawValue: lastSelected?.tag ?? ReviewsSortModes.LatestReviews.rawValue) ?? ReviewsSortModes.LatestReviews)
    }
}
