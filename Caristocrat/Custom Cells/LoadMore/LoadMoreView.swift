

import UIKit

class LoadMoreView: UIView {

    @IBOutlet weak var lblLoading: UIButton!
    
    class func instanceFromNib() -> LoadMoreView {
        let footer = UINib(nibName: "LoadMoreView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! LoadMoreView
        footer.frame = CGRect(x: 0, y: 0, width: 375, height: 70)
        return footer
    }

}
