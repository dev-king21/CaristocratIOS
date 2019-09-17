
import UIKit

class Menu: NSObject {

    var menu_image: String!
    var menu_title: String!
    
    init(image: String, title: String) {
        
        self.menu_image = image
        self.menu_title = title
    }
}

