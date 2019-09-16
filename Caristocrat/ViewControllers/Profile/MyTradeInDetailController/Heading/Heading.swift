import UIKit

class Heading: UIView {
    
    @IBOutlet weak var lblHeading: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Heading", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
