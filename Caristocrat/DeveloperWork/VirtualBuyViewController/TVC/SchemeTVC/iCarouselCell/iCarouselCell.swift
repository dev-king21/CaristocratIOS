//
//  iCarouselView.swift
 import UIKit

class iCarouselCell: UIView {
    
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblOfferedPercentage: UILabel!
    @IBOutlet weak var btnRequestACall: UIButton!
    @IBOutlet weak var btnCallNow: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "iCarouselCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func setData(data:BankRateModel){
        
        self.lblOfferedPercentage.text = "\(data.rate ?? 0.0) %"
        
        if let image_url = data.media?.first?.file_url {
            self.imgCompany.kf.setImage(with: URL(string: image_url), placeholder: #imageLiteral(resourceName: "image_placeholder"))
        } else {
            self.imgCompany.image = UIImage(named: "image_placeholder")
        }
    }

}
