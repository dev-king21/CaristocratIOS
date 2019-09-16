//
//  SplashViewController.swift
 import UIKit

class SplashViewController: UIViewController {
  
    @IBOutlet weak var imgSplash: UIImageView!
    @IBOutlet weak var lableCount: UILabel!
    var counter = 0
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.animate(sender:)), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func animate(sender : Timer) {
        UIView.transition(with: lableCount,
                          duration: 0.2,
                          options: [.curveEaseInOut],
                          animations: { () -> Void in
        self.counter += 10
        if self.counter == 100 {
            self.timer?.invalidate()
            self.timer = nil
        }
    self.lableCount.text = "\(self.counter)%"
        }, completion: { (val) -> Void in})
    }

    @objc func splashTimeOut(sender : Timer) {
        Global.APP_DELEGATE.setupUX()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}
