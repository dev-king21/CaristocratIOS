
import UIKit

@IBDesignable
class IGTextField: UIView {

    var view: UIView!
    
    
    @IBOutlet weak var dropDownArrow: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var errorIcon: UIImageView!
    
    var selected_icon: String!
    var placeHolderColorValue: UIColor?
    
    @IBInspectable var titleValue: String? {
        
        get{
            return titleLabel.text
        }
        
        set(fieldValue){
            titleLabel.text = fieldValue
        }
    }
    
    
    
    @IBInspectable var selectedIcon: String? {
        
        get{
            return self.selected_icon
        }
        
        set(fieldValue){
            self.selected_icon = fieldValue
        }
    }
    
    @IBInspectable var fieldIcon: UIImage?{
        
        get{
            return icon.image
        }
        
        set(fieldIcon){
            if(fieldIcon != nil){
                icon.image = fieldIcon
            }
        }
    }
    
    @IBInspectable var placeHolderString: String?{
        
        get{
            return textField.placeholder
        }
        
        set(placeHolderString){
            textField.placeholder = placeHolderString
        }
    }
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return placeHolderColorValue
        }
        set(newValue) {
            self.placeHolderColorValue = newValue
            self.textField.attributedPlaceholder = NSAttributedString(string:self.textField.placeholder != nil ? self.textField.placeholder! : textField.placeholder!, attributes:[NSAttributedString.Key.foregroundColor: newValue!
                ])
        }
    }
    
    @IBInspectable var isSecure: Bool{
        
        get{
            return textField.isSecureTextEntry
        }
        
        set(isSecure){
            if(isSecure){
                textField.isEnabled = false
                textField.isSecureTextEntry = true
                textField.isEnabled = true
            }else{
                textField.isEnabled = false
                textField.isSecureTextEntry = false
                textField.isEnabled = true
            }
        }
    }
    
    @IBInspectable var isDropDown: Bool{
        
        get{
            return dropDownArrow.isHidden
        }
        
        set(isSecure){
            if(isSecure){
                dropDownArrow.isHidden = true
            }else{
                dropDownArrow.isHidden = false
            }
        }
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
     //   self.textField.delegate = self
        addSubview(view)
       // self.resetError()
        self.textField.delegate = self
    }
    
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
        
    }
    
    
    func resetError(){
        self.errorLabel.isHidden = true
    }
    
    func setErrorWith(message: String){
    }
    
    func setFieldAsVerified(){
        self.errorIcon.isHidden = false
        self.errorIcon.image = #imageLiteral(resourceName: "text_field_verified")
    }
    
    func setFieldAsNotVerified(){
        self.errorIcon.isHidden = false
        self.errorIcon.image = #imageLiteral(resourceName: "text_field_not_verified")
        self.errorLabel.isHidden = false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        self.resetError()
    }


}

extension IGTextField: UITextFieldDelegate{


    
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if(self.selected_icon != nil){
            if(self.textField.text != nil){
                self.icon.image = UIImage(named: self.selected_icon)
            }
        }

    }
}
