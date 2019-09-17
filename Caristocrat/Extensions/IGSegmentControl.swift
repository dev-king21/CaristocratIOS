import UIKit

class IGSegmentControl: UISegmentedControl {
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font  : UIFont(name: "Roboto-Regular", size: 15.0)!,
            ]
        let normalTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.56),
            NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 15.0)!,
            ]
     
        UISegmentedControl.appearance().setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes(normalTextAttributes, for: .normal)
    

        removeBorders()
    }
    
    
}
extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default) // divider coor
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
