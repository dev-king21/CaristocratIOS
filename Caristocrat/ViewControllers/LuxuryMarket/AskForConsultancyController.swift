//
//  AskForConsultancyController.swift
 import UIKit

protocol  AskForConsultancyProtocol {
    func didTapOkButton(status : Bool)
}


class AskForConsultancyController: BaseViewController {

    var vehicleDetail: VehicleBase?
    var bank: BankRateModel?
    @IBOutlet weak var personalShopperView: ConsultancyView!
    @IBOutlet weak var consultancyView: ConsultancyView!
    @IBOutlet weak var consultancyCollapseButton: UIButton!
    @IBOutlet weak var shopperCollapseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getSettings()
    }
    
    func setViews() {
        personalShopperView.vehicleDetail = self.vehicleDetail
        personalShopperView.bank = self.bank
      //  personalShopperView.contentLabel.attributedText = personalShopperContent.htmlToAttributedString
        
        let attStr = getAttributedStringForHTMLWithFont(htmlStr: personalShopperContent, textSize: 12, fontName: "Poppins-Regular")?.trimmedAttributedString()
  
        personalShopperView.contentLabel.attributedText = attStr

        //personalShopperView.contentLabel.attributedText = getAttributedStringForHTMLWithFont(htmlStr: personalShopperContent, textSize: 12, fontName: "Poppins-Regular")
        

        personalShopperView.contactType = .MyShopper
        personalShopperView.isHidden = false
        personalShopperView.lblHeading.isHidden = true
        personalShopperView.parentView.isHidden = true
        shopperCollapseButton.isSelected = true
        personalShopperView.heightMainView.constant = 300
        personalShopperView.stackHeight.constant = 0
        personalShopperView.layoutIfNeeded()
        personalShopperView.delegate = self
        consultancyView.vehicleDetail = self.vehicleDetail
        consultancyView.bank = self.bank
     //   consultancyView.contentLabel.attributedText = askForConsultancyContent.htmlToAttributedString
        
        let attStr1 = getAttributedStringForHTMLWithFont(htmlStr: askForConsultancyContent, textSize: 12, fontName: "Poppins-Regular")?.trimmedAttributedString()
        
        consultancyView.contentLabel.attributedText = attStr1
        
        
        //consultancyView.contentLabel.attributedText = getAttributedStringForHTMLWithFont(htmlStr: askForConsultancyContent, textSize: 12, fontName: "Poppins-Regular")
        consultancyView.contactType = .Consultancy
        consultancyView.isHidden = false
        consultancyView.lblHeading.isHidden = true
        consultancyView.parentView.isHidden = true
        consultancyCollapseButton.isSelected = true
        consultancyView.heightMainView.constant = 300
        consultancyView.stackHeight.constant = 0
        consultancyView.layoutIfNeeded()
        consultancyView.delegate = self
        

    }
    
    
    
     func getAttributedStringForHTMLWithFont( htmlStr : String , textSize : Int , fontName : String )->NSAttributedString?{
        
         var htmlStr = htmlStr
        do {
            if htmlStr .isEmpty{
                htmlStr = "<p></p>"
                
            }
            
            let str = "<div style=\"color:#5A5A5A; font-size: \(textSize)px\"><font face=\"\(fontName)\">\(htmlStr)</font></div>"
            
            
            let data  = str .data(using: String.Encoding.unicode)!
            
           do {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            } catch {
                return NSAttributedString()
            }
            
        }
    }
    
    var askForConsultancyContent = ""
    var personalShopperContent = ""
    
    func getSettings() {
        APIManager.sharedInstance.getSettings(success: { (result) in
            self.askForConsultancyContent = result.first?.ask_for_consultancy.unWrap ?? ""
            self.personalShopperContent = result.first?.personal_shopper.unWrap ?? ""
            self.setViews()
        }) { (error) in
            
        }
    }
    
    @IBAction func tappedOnPersonalShopper() {
       personalShopperView.isHidden = !personalShopperView.isHidden
       shopperCollapseButton.isSelected = !personalShopperView.isHidden
    }
    
    @IBAction func tappedOnAskConsultancy() {
       consultancyView.isHidden = !consultancyView.isHidden
       consultancyCollapseButton.isSelected = !consultancyView.isHidden
    }
    
}

extension AskForConsultancyController : AskForConsultancyProtocol {
    
    func didTapOkButton(status: Bool) {
        
        if(status){
            self.navigationController?.popViewController(animated: true)
        }
    }
}




