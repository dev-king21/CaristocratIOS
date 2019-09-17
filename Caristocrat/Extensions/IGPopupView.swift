//
 import UIKit



enum Background{
    
    case blur
    
    case light
    
    case dark
    
}


struct Options{
    
    var backgroundType : Background? = .light
    
    var backgroundTapDismisal: Bool? = false
    
    var cornerRadius: CGFloat? = 0.0
    
    init() {}
    
}


extension  UIView {
    
    
    
    fileprivate var parentView : UIWindow!{
        
        get{
            
            return UIApplication.shared.windows.first
            
        }
        
    }
    
    
    func showAsPopup()
    {
        self.handleBackgroundTap(Options().backgroundTapDismisal!)
        
        let height =  CGFloat(self.subviews[0].subviews.map( { $0.frame.size.height } ).max()!) +  CGFloat(self.subviews[0].subviews.map( { $0.frame.origin.y } ).max()!)
        
        
        let VERTICAL_SPACING : CGFloat = 40.0
        
        let width = UIScreen.main.bounds.width - VERTICAL_SPACING
        
        let x = VERTICAL_SPACING / 2
        
        let y = ( UIScreen.main.bounds.height / 2 ) - ( height / 2 )
        
        let frame = CGRect.init(x: x , y: y, width: width, height: height)
        
        self.frame = frame
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.bindKeyboardEvent()
        
        self.handleBackground(bgType: Options().backgroundType!)
        
        self.layer.cornerRadius = Options().cornerRadius!
        
        self.layer.masksToBounds = true
        
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.parentView?.addSubview(self)
            
            self.parentView.bringSubviewToFront(self)
            
        })
        
    }
    
    
    
    func showAsPopup(_ options: Options)
    {
        self.handleBackgroundTap(options.backgroundTapDismisal!)
        
        let height =  CGFloat(self.subviews[0].subviews.map( { $0.frame.size.height } ).max()!) +  CGFloat(self.subviews[0].subviews.map( { $0.frame.origin.y } ).max()!)
        
        
        let VERTICAL_SPACING : CGFloat = 40.0
        
        let width = UIScreen.main.bounds.width - VERTICAL_SPACING
        
        let x = VERTICAL_SPACING / 2
        
        let y = ( UIScreen.main.bounds.height / 2 ) - ( height / 2 )
        
        let frame = CGRect.init(x: x , y: y, width: width, height: height)
        
        self.frame = frame
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.bindKeyboardEvent()
        
        self.handleBackground(bgType: options.backgroundType!)
        
        self.layer.cornerRadius = options.cornerRadius!
        
        self.layer.masksToBounds = true
        
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.parentView?.addSubview(self)
            
            self.parentView.bringSubviewToFront(self)
            
        })
        
    }
    
    
    
    func showAsPopup(_ options: Options, with height: CGFloat)
    {
        self.handleBackgroundTap(options.backgroundTapDismisal!)
        
        let VERTICAL_SPACING : CGFloat = 40.0
        
        let width = UIScreen.main.bounds.width - VERTICAL_SPACING
        
        let x = VERTICAL_SPACING / 2
        
        let y = ( UIScreen.main.bounds.height / 2 ) - ( height / 2 )
        
        let frame = CGRect.init(x: x , y: y, width: width, height: height)
        
        self.frame = frame
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.bindKeyboardEvent()
        
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.layer.cornerRadius = options.cornerRadius!
            
            self.layer.masksToBounds = true
            
            self.handleBackground(bgType: options.backgroundType!)
            
            self.parentView?.addSubview(self)
            
            self.parentView.bringSubviewToFront(self)
            
        })
        
        
        
    }
    
    
    
    fileprivate func handleBackgroundTap(_ status: Bool){
        
        if status {
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            
            tapRecognizer.cancelsTouchesInView = false
            
            self.topViewController()?.view.addGestureRecognizer(tapRecognizer)
            
        }
        else{
            
            self.topViewController()?.view.isUserInteractionEnabled = false
            
        }
        
    }
    
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        
        self.dismiss()
        
    }
    
    
    func dismiss(){
        
        if  (self.parentView?.subviews.count as! Int) >= 2
        {
            UIView.animate(withDuration: 0.25, animations: {
                
                self.parentView?.subviews.last?.removeFromSuperview()
                
                self.resetValues()
            })
        }
    }
    
    
    fileprivate func resetValues(){
        
        self.topViewController()?.view.alpha = 1.0
        
        self.topViewController()?.view.isUserInteractionEnabled = true
        
    }
    
    
    fileprivate  func bindKeyboardEvent(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let KEYBOARD_HEIGHT : CGFloat = 150.0
            
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let endFrameY = endFrame?.origin.y ?? 0
            
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.frame = CGRect.init(x: self.frame.origin.x , y: self.frame.origin.y + KEYBOARD_HEIGHT, width: self.frame.size.width, height: self.frame.size.height)
                
            } else {
                
                self.frame = CGRect.init(x: self.frame.origin.x , y: self.frame.origin.y - KEYBOARD_HEIGHT, width: self.frame.size.width, height: self.frame.size.height)
                
            }
            
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.layoutIfNeeded() },
                           completion: nil)
        }
        
    }
    
    
    fileprivate func handleBackground(bgType: Background){
        
        switch bgType {
            
        case .blur:
            
            break
            
        case .dark:
            break
            
        case .light:
            self.topViewController()?.view.alpha = 0.7
            break
            
        default:
            break
        }
        
    }
}


extension UIView
{
    
    fileprivate func topViewController(base: UIViewController? = (UIApplication.shared.delegate!).window??.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            
            return topViewController(base: nav.visibleViewController)
            
        }
        
        if let tab = base as? UITabBarController {
          
            if let selected = tab.selectedViewController {
              
                return topViewController(base: selected)
           
            }
        }
       
        if let presented = base?.presentedViewController {
            
            return topViewController(base: presented)
       
        }
        
        return base
    }
    
}

