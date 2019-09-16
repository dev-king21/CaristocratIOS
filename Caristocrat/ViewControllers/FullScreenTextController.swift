//
//  FullScreenTextController.swift
 import UIKit

class FullScreenTextController: UIViewController , UIWebViewDelegate{
   
    //MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: PopupDelgates?
    var content: String?
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad()                       {
        super.viewDidLoad()
        
        self.webView.delegate = self
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.webView.scrollView.bounces = false
        // Do any additional setup after loading the view.
        setTitle()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
   
    func setTitle() {
      lblTitle.text = "TERMS AND CONDITIONS"
      //textView.text = content
        textView.attributedText = Utility.getAttributedStringForHTMLWithFont(htmlStr: content!, textSize: 12, fontName: "Poppins-Regular")?.trimmedAttributedString()
        
        self.webView.loadHTMLString(content!, baseURL: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Actions
    @IBAction func actionBack(_ sender: UIButton)      {

        delegate?.didTapOnClose()

        if self.navigationController?.isBeingPresented ?? true {
            dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
}
