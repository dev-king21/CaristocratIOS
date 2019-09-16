import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleIcon: UIImageView!
    
    
    var data : Menu!{
        didSet{
            
            self.titleLabel.text = data.menu_title
            self.titleIcon.image = UIImage(named: data.menu_image)
        }
    }

    
   
       
    
}
