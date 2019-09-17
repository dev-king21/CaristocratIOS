import UIKit
import ImageSlideshow

class SlideShow: UIViewController {
//
    @IBOutlet weak var pager: UIPageControl!
    @IBOutlet weak var slider: ImageSlideshow!
    var ImageSliderArray = [Any]()
    var cur_image_index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slider.pageControl.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.slider.setImageInputs(ImageSliderArray as! [InputSource])
        //self.slider.contentScaleMode = .scaleAspectFill
        self.slider.circular = false
        self.slider.setCurrentPage(cur_image_index, animated: false)
        self.slider.zoomEnabled = true
        self.slider.pageControl.isHidden = true
        self.pager.numberOfPages = ImageSliderArray.count
        self.pager.currentPage = cur_image_index
        self.slider.currentPageChanged = { page in
        self.pager.currentPage = page
        }
        
        
    }
    
    @IBAction func onBtnBack(_ sender: UIButton) {
        if self.navigationController != nil{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
   
}
