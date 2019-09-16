//
//  EditProfileViewController.swift
 import UIKit
import Photos
import Alamofire

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameField: CustomTextField!
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var aboutField: CustomUITextView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var professionView: UIView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var professionField: UITextField!
    @IBOutlet weak var nationalityLabel: UILabel!
    
    var selectedNationality = ""
    var selectedGender = Gender.None

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setupField()
        self.setData()
        
        self.emailField.textField.keyboardType = .emailAddress
    }
    
    func setupField() {
        self.countryCode.delegate = self
        self.countryCode.phonePickerDelegate = self
        let currentLocale = NSLocale.current as NSLocale
        let code = currentLocale.object(forKey: .countryCode) as? String
       // self.countryCode.country = Country.country(for: NKVSource(countryCode: code ?? ""))
        
        self.countryCode.country = Country.country(for: NKVSource(countryCode: "AE"))
        
    }
    
    func getPhoneNumber() -> String {
        if !(phoneNumber.text?.isEmpty ?? false) {
            return (phoneNumber.text ?? "")
        }
        return ""

    }
    
    func isValidPhone() -> Bool {
        if phoneNumber.text?.isEmpty ?? true ||  ValidationsUtility.isValidPhone(phone: phoneNumber.text ?? "") {
            return true
        } else {
            Utility.showErrorWith(message: Errors.InvalidPhone.rawValue)
            return false
        }
    }
    
    let formatter = DateFormatter()
    var selectedDate: Date?
    func showDateTimePicker() {
        DatePickerDialog().show("Date of Birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: Calendar.current.date(byAdding: .year, value: -100, to: Date()),  maximumDate:  Calendar.current.date(byAdding: .year, value: -10, to: Date()), datePickerMode: UIDatePicker.Mode.date) { (date) in
            if let dt = date {
                self.formatter.dateFormat = "yyyy-MM-dd"
                self.selectedDate = date
                self.dateField.text = self.formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func tappedOnUpdate() {
        self.view.endEditing(true)
        let formData = ValidationsUtility.isFormDataValid(parent: self.view)
        if formData.isValid && self.isValidPhone() {
            var params = formData.params
            params.updateValue(getPhoneNumber(), forKey: "phone")
            params.updateValue(countryCode.code ?? "", forKey: "country_code")
            
            if selectedGender != .None {
               params.updateValue(selectedGender.rawValue.description, forKey: "gender")
            }
            
            if selectedDate != nil {
                params.updateValue(self.dateField.text ?? "", forKey: "dob")
            }
            if !(self.professionField.text?.isEmpty ?? true) {
                params.updateValue(self.professionField.text ?? "", forKey: "profession")
            }
            if !self.selectedNationality.isEmpty {
                params.updateValue(self.selectedNationality, forKey: "nationality")
            }
            params.updateValue(aboutField.isPlaceholder() ? "" : aboutField.text , forKey: "about")
            self.updatProfile(params: params)
        }
    }
    
    @IBAction func tappedOnSelectDate() {
        self.showDateTimePicker()
    }
    
    @IBAction func tappedOnNationality() {
        Utility().showSelectionPopup(title: "Nationalities", items: Constants.NATIONALITIES, delegate: self)
    }
    
    @IBAction func tappedOnCodeField() {
        countryCode.presentCountriesViewController()
    }
    
    @IBAction func tappedOnBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnImage() {
//        self.showDialog()
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.showDialog()
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.showDialog()
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            Utility().openSettings()
        }
    }
    
    func getProfileImage() -> UIImage {
        if self.profileImage.image != nil {
            let imageInJPEG = self.profileImage.image!.jpegData(compressionQuality: 0.1)
            let compressImage = UIImage.init(data: imageInJPEG!)
            let targetSize = CGSize(width: 200, height: 200)
            return Utility().resizeImage(image: profileImage.image!, targetSize: targetSize)
        }
        
        return UIImage()
    }

    func presentImagePicker(fromCamera: Bool) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = fromCamera ? .camera : .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func showDialog() {
        Utility.showAlert(title: "Choose Image", message: "", positiveText: "Camera", positiveClosure: { (alert) in
            self.presentImagePicker(fromCamera: true)
        }, negativeClosure: { (alert) in
            self.presentImagePicker(fromCamera: false)
        }, navgativeText: "Gallery", preferredStyle: .actionSheet)

    }

    func updatProfile(params: Parameters) {
        Utility.startProgressLoading()
        APIManager.sharedInstance.updateProfile(params: params, images: ["key":"image", "value": self.getProfileImage()], success: { (result) in
            let token = AppStateManager.sharedInstance.userData?.user?.access_token
            AppStateManager.sharedInstance.userData = result
            AppStateManager.sharedInstance.userData?.user?.access_token = token
            Utility.showSuccessWith(message: Messages.ProfileUpdate.rawValue)
            NotificationCenter.default.post(name: Notification.Name(Events.onProfileUpdate.rawValue), object: nil)
            Utility.stopProgressLoading()
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error) in

            Utility.stopProgressLoading()
        }, showLoader: true)
    }
    
    func setData() {
        if let userData = AppStateManager.sharedInstance.userData?.user {
            fullNameField.textField.text = userData.details?.first_name
            emailField.textField.text = userData.email
            phoneNumber.text = userData.details?.phone
            
            if !(userData.details?.about?.isEmpty ?? true) {
                aboutField.text =  userData.details?.about ?? ""
                self.aboutField.textColor = UIColor.black
            }
            else{
                self.aboutField.textColor = UIColor.lightGray
            }

            if !(userData.details?.phone?.isEmpty ?? true) {
                self.countryCode.country = Country.country(for: NKVSource.init(phoneExtension: userData.details?.country_code ?? "AE"))
            }

            if let imageURL = userData.details?.image_url {
                cameraIcon.isHidden = true
                profileImage.kf.setImage(with: URL(string: imageURL), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            } else {
                cameraIcon.isHidden = false
            }

            if let dob = userData.details?.dob {
                self.dateField.text = dob
            }

            if let nationality = userData.details?.nationality {
                self.nationalityLabel.text = nationality
            }

            if let profession = userData.details?.profession {
                self.professionField.text = profession
            }
            
            if let gender = Gender(rawValue: userData.details?.gender ?? 0) {
                switch gender {
                    case .Male:
                     selectedGender = .Male
                     maleButton.isSelected = true
                    break
                    case .Female:
                     selectedGender = .Female
                     femaleButton.isSelected = true
                    break
                    default:
                    break
                }
            }
            
        }
    }
    
    @IBAction func tappedOnMaleButton(sender: UIButton) {
        selectedGender = .Male
        maleButton.isSelected = true
        femaleButton.isSelected = false
    }
    
    @IBAction func tappedOnFemaleButton(sender: UIButton) {
        selectedGender = .Female
        maleButton.isSelected = false
        femaleButton.isSelected = true
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCode {
            return false
        }
        
        return true
    }
}

extension  EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        profileImage.image = selectedImage
        cameraIcon.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: ItemSelectionDelegate {
    func didItemSelect(position: Int, tag: String) {
        selectedNationality = Constants.NATIONALITIES[position]
        nationalityLabel.text = selectedNationality
    }
}

