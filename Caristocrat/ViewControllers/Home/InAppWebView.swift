//
//  InAppWebView.swift
 import UIKit

class InAppWebView: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var linkString = ""
    var customHeader = ""
    var scalesPageToFit = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if customHeader.isEmpty {
            self.lblTitle.text = self.linkString
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.text = customHeader
            self.lblTitle.textAlignment = .center
            self.lblTitle.font = UIFont(name: "Ailerons-Regular", size: 24)
        }
        if let linkURL = URL(string:self.linkString){
            let urlRequest = URLRequest(url:linkURL)
            self.webView.loadRequest(urlRequest)
        }
        
        self.webView.scalesPageToFit = scalesPageToFit
    }

    @IBAction func onBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension InAppWebView:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        Utility.startProgressLoading()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Utility.stopProgressLoading()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Utility.stopProgressLoading()
    }
}
