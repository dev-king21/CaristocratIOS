//
//  TutorialViewCell.swift
 import UIKit
import AVFoundation
import AVKit

protocol TutorialViewCellDelegate {
    func didTapPlayButton(indexPath : IndexPath)
}

class TutorialViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var tutorialImage: UIImageView!

    
    var delegate : TutorialViewCellDelegate!
    var indexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    @IBAction func tappedOnPlayButton() {
        self.delegate.didTapPlayButton(indexPath: indexPath)
    }
    
 
    
    

}
