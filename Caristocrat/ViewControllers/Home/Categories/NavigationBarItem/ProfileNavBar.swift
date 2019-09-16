import UIKit

class ProfileNavBar: UIView {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnNavBar: UIButton!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ProfileNavBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

