    //
//  TradeCarController.swift
 import UIKit
import SwiftyJSON

enum TradeCarType{
    case addNewCar
    case editAddedCar
    case AddAndTrade
}
struct CarPhotosWithIDs {
    var photo = UIImage()
    var id = 0
    var type = ""
}

protocol CarPhotoCellDelegate {
    func didTapOnClose(position: Int)
}

class TradeCarController: BaseViewController {
    
    @IBOutlet weak var tradeInCarImage: UIImageView!
    @IBOutlet weak var tradeInCarName: UILabel!
    @IBOutlet weak var tradeInCarModel: UILabel!
    @IBOutlet weak var tradeInCarYear: UILabel!
    @IBOutlet weak var tradeInCarPrice: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var countryCode: NKVPhonePickerTextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var kmField: UITextField!
    @IBOutlet weak var chesisField: UITextField!
    @IBOutlet weak var makeView: UIView!
    @IBOutlet weak var modelView: UIView!
    @IBOutlet weak var YearsView: UIView!
    @IBOutlet weak var regionsSpecificView: UIView!
    @IBOutlet weak var accidentView: UIView!
    @IBOutlet weak var exteriorView: UIView!
    @IBOutlet weak var interiorView: UIView!
    @IBOutlet weak var engineTypeView: UIView!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var regionSpecificLabel: UILabel!
    @IBOutlet weak var accidentLabel: UILabel!
    @IBOutlet weak var exteriorLabel: UILabel!
    @IBOutlet weak var interiorLabel: UILabel!
    @IBOutlet weak var engineTypeLabel: UILabel!
    @IBOutlet weak var trimField: UITextField!
    @IBOutlet weak var warrantyRemainingField: UITextField!
    @IBOutlet weak var serviceRemainingField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var versionField: UITextField!
//  @IBOutlet weak var photosCollectionView: UICollectionView!
//  @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var aboutYourselfTextview: CustomUITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerCarDetailView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var vehicleDetailContainerView: NSLayoutConstraint!
    @IBOutlet weak var btnAddCar: UIButton!
    
    @IBOutlet weak var imgCar1: UIImageView!
    @IBOutlet weak var imgCar2: UIImageView!
    @IBOutlet weak var imgCar3: UIImageView!
    @IBOutlet weak var imgCar4: UIImageView!
    @IBOutlet weak var imgCar5: UIImageView!
    @IBOutlet weak var imgCar6: UIImageView!
    
    @IBOutlet weak var btnDeleteImage1: UIButton!
    @IBOutlet weak var btnDeleteImage2: UIButton!
    @IBOutlet weak var btnDeleteImage3: UIButton!
    @IBOutlet weak var btnDeleteImage4: UIButton!
    @IBOutlet weak var btnDeleteImage5: UIButton!
    @IBOutlet weak var btnDeleteImage6: UIButton!
    @IBOutlet weak var btnCheck: UIButton!

    var imageType = ""
    
    
    let AddPhotoCellIdentifier = "AddPhotoCell"

    var brands: [Brand] = []
    var selectedbrand: Brand?
    var carModels: [CarModel] = []
    var selectedCarModel: CarModel?
    var selectedYear: String?
    var regionalSpecs: [Regional_specs] = []
    var selectedRegionalSpecs: Regional_specs?
    var interiorColors : [AttributeOptions] = []
    var selectedInteriorColor : AttributeOptions?
    var selectedExteriorColor : AttributeOptions?
    var selectedEngineType : AttributeOptions?
    var exteriorColors : [AttributeOptions] = []
    var engineType : [AttributeOptions] = []
    var accidentModel : [AttributeOptions] = []//= ["Yes", "No"]
    var versionsModel : [VersionModel] = []//= ["Yes", "No"]
    var selectedAccident: AttributeOptions?
    var carPhotos: [CarPhotosWithIDs] = []
    var years: [String] = []
    var cells: [CellWithoutHeight] = [
        ("AddPhotoCell",1),
        (CarPhotosCell.identifier,-1)]
    var selectedVehicleDetail: VehicleBase?
    var tradeCarType = TradeCarType.addNewCar
    var deleted_images = [String]()
    var forEvaluation = false
    var delegate: AddAndTradeCarProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        self.customizeApperance()
        self.getAllData()
        self.setTradeInCarData()
        
        emailField.keyboardType = .emailAddress
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onBtnUploadImage(_ sender: UIButton) {
        switch sender.tag{
        case 1://Front Image
            self.imageType = CarImageType.Front.rawValue
            break
        case 2://Back Image
            self.imageType = CarImageType.Back.rawValue
            break
        case 3://Right Image
            self.imageType = CarImageType.Right.rawValue
            break
        case 4://Left Image
            self.imageType = CarImageType.Left.rawValue
            break
        case 5://Interior Image
            self.imageType = CarImageType.Interior.rawValue
            break
        case 6://Registration Card Image
            self.imageType = CarImageType.Registration.rawValue
            break
        default:
            break
        }
        
        self.openImagePickerForSelectedImage()
    }
    
    @IBAction func onBtnDeleteImage(_ sender: UIButton) {
        switch sender.tag{
        case 1://FrontImage
            self.imageType = CarImageType.Front.rawValue
            break
        case 2://BackImage
            self.imageType = CarImageType.Back.rawValue
            break
        case 3://RightImage
            self.imageType = CarImageType.Right.rawValue
            break
        case 4://LeftImage
            self.imageType = CarImageType.Left.rawValue
            break
        case 5://InteriorImage
            self.imageType = CarImageType.Interior.rawValue
            break
        case 6://Registration Card Image
            self.imageType = CarImageType.Registration.rawValue
            break
        default:
            break
        }
        self.deleteCarImages()
    }
    
    func customizeApperance() {
        self.setGestures()
        self.setupField()
        //self.prepareCollectionView()
    }
    
    func setData(){
        let user = AppStateManager.sharedInstance.userData?.user
        self.nameField.text = user?.name ?? ""
        self.emailField.text = user?.email ?? ""
        self.phoneNumber.text = user?.details?.phone ?? ""
    }
    
    func setTradeInCarData(){
        switch self.tradeCarType{
        case .addNewCar:
            self.title = "ADD CAR"
        case .editAddedCar:
            self.title = "EDIT CAR"
        case .AddAndTrade:
            self.title = forEvaluation ? "SELL YOUR CAR" : "TRADE IN YOUR CAR"
        }
        if let data = self.selectedVehicleDetail{
            if let image_url = data.media?.first?.file_url {
                self.tradeInCarImage.kf.setImage(with: URL(string: image_url), placeholder: #imageLiteral(resourceName: "image_placeholder"))
            } else {
                self.tradeInCarImage.image = UIImage(named: "image_placeholder")
            }
            switch self.tradeCarType{
            case .addNewCar,.AddAndTrade:
             //   self.title = "Add CAR"
                self.tradeInCarName.text = data.name
                self.tradeInCarModel.text = data.car_model?.name
                self.tradeInCarYear.text = "\(data.year ?? 0)"
                self.tradeInCarPrice.text = "\(data.currency ?? "AED") "  + Utility.commaSeparatedNumber(number:"\(data.amount ?? 0)")
            case .editAddedCar:
            //    self.title = "EDIT CAR"
                self.nameField.text = data.name ?? ""
                self.emailField.text = data.email ?? ""
       
                self.phoneNumber.text = "\(data.phone ?? 0)"
                self.countryCode.country = Country.country(for: NKVSource.init(phoneExtension: data.country_code ?? "AE"))
                self.versionField.text = data.version_app ?? ""
                self.tradeInCarName.text = data.car_model?.name
                self.tradeInCarModel.text = data.car_model?.brand?.name
                self.tradeInCarYear.text = "\(data.year ?? 0)"
                self.tradeInCarPrice.isHidden = true
                self.btnAddCar.setTitle("EDIT CAR", for: .normal)

                self.chesisField.text = data.chassis ?? ""
                self.kmField.text = "\(data.kilometer ?? 0)"
                self.yearLabel.text = "Year : " + "\(data.year ?? 0)"
                selectedYear = "\(data.year ?? 0)"
                
                self.aboutYourselfTextview.text = data.notes ?? ""
                
                if !(data.notes ?? "").isEmpty && (self.aboutYourselfTextview.text ?? "") != Constants.AdditionalNotes{
                    self.aboutYourselfTextview.textColor = Constants.PLACEHOLDER_COLOR.hexStringToUIColor()
                }
                else{
                    self.aboutYourselfTextview.textColor = .lightGray
                }
                
                if let selected_car_model = data.car_model{
                    self.selectedCarModel = selected_car_model
                    self.modelLabel.text = "Model : " + (self.selectedCarModel?.name ?? "")
                    self.selectedbrand = selected_car_model.brand
                    self.makeLabel.text = "Make : " + (self.selectedCarModel?.brand?.name ?? "")
                }
                
                if let selected_regional_specs = data.regional_specs{
                    self.selectedRegionalSpecs = selected_regional_specs
                    self.regionSpecificLabel.text = "Regional specs : " + (self.selectedRegionalSpecs?.name ?? "")
                }
                
                var arrAttributeOptions = [AttributeOptions]()
                if let myCarAttribute = data.my_car_attributes{
                    for attribute in myCarAttribute {
                        if (attribute.attr_id ?? 0) == CarAttributeType.InteriorColor.rawValue || (attribute.attr_id ?? 0) == CarAttributeType.ExteriorColor.rawValue || (attribute.attr_id ?? 0) == CarAttributeType.Accident.rawValue{
                            let attributeOption = AttributeOptions(id: Int(attribute.value ?? "0") ?? 0, name: attribute.attr_option ?? "")
                            arrAttributeOptions.append(attributeOption)
                        }
                        else{
                            let attributeOption = AttributeOptions(id: attribute.attr_id ?? 0, name: attribute.value ?? "")
                            arrAttributeOptions.append(attributeOption)
                        }
                    }
                }
                
                if let myCarAttribute = data.my_car_attributes{
                    for (index,attribute) in myCarAttribute.enumerated(){
                        let key = attribute.attr_id ?? 0
                        switch key{
                        case CarAttributeType.InteriorColor.rawValue:
                            self.selectedInteriorColor = arrAttributeOptions[index]
                            self.interiorLabel.text = "Interior Color : " + (attribute.attr_option ?? "")
                        case CarAttributeType.ExteriorColor.rawValue:
                            self.selectedExteriorColor = arrAttributeOptions[index]
                            self.exteriorLabel.text = "Exterior Color : " + (attribute.attr_option ?? "")
                        case CarAttributeType.Accident.rawValue:
                            self.selectedAccident = arrAttributeOptions[index]
                            self.accidentLabel.text = "Accident : " + (attribute.attr_option ?? "")
                        case CarAttributeType.Trim.rawValue:
                            self.trimField.text = attribute.value
                        case CarAttributeType.WarrantyRemaining.rawValue:
                            self.warrantyRemainingField.text = attribute.value
                        case CarAttributeType.ServiceContract.rawValue:
                            self.serviceRemainingField.text = attribute.value
                        default:
                            break
                        }
                    }
                }
                if let selected_engine_type = data.engine_type{
                    self.selectedEngineType = selected_engine_type
                    self.engineTypeLabel.text = "Engine Type : " + (selected_engine_type.name ?? "")
                }
                self.setDownloadedCarImages()
            case .AddAndTrade:
                break
            }
        }
        else{
            self.containerCarDetailView.isHidden = true
            self.vehicleDetailContainerView.constant = 0
            self.containerViewHeight.constant = self.containerView.frame.size.height - 120.0
        }
    }
    
    func setDownloadedCarImages(){
        guard let data = self.selectedVehicleDetail else {return}
        Utility.startProgressLoading()
        
        DispatchQueue.global(qos: .background).async {
            if let images = data.media{
                for (index,image) in images.enumerated() {
                    if let imgURL = URL(string: image.file_url ?? ""){
                        let data = try? Data(contentsOf: imgURL)
                        
                        if let imageData = data {
                            let img = UIImage(data: imageData)
                            let obj = CarPhotosWithIDs(photo: img ?? #imageLiteral(resourceName: "car_prof_bg"), id: image.id ?? 0, type: image.title ?? "")
                            self.carPhotos.append(obj)
                        }
                    }
                    if index == images.count - 1{
                        DispatchQueue.main.async() {
                            print(self.carPhotos)
                            self.setCarImages()
                            Utility.stopProgressLoading()
                       }
                    }
                }
            }
        }
    }
    
    func setCarImages() {
        print(self.carPhotos)
        for image in self.carPhotos{
            switch image.type{
            case CarImageType.Front.rawValue:
                self.imgCar1.image = image.photo
                self.btnDeleteImage1.isHidden = false
                break
            case CarImageType.Back.rawValue:
                self.imgCar2.image = image.photo
                self.btnDeleteImage2.isHidden = false
                break
            case CarImageType.Right.rawValue:
                self.imgCar3.image = image.photo
                self.btnDeleteImage3.isHidden = false
                break
            case CarImageType.Left.rawValue:
                self.imgCar4.image = image.photo
                self.btnDeleteImage4.isHidden = false
                break
            case CarImageType.Interior.rawValue:
                self.imgCar5.image = image.photo
                self.btnDeleteImage5.isHidden = false
                break
            case CarImageType.Registration.rawValue:
                self.imgCar6.image = image.photo
                self.btnDeleteImage6.isHidden = false
                break
            default:
                break
            }
        }
    }
    
    func deleteCarImages() {
        for (index,image) in self.carPhotos.enumerated(){
            if self.imageType == image.type{
                switch self.imageType{
                case CarImageType.Front.rawValue:
                    self.imgCar1.image = #imageLiteral(resourceName: "camerabox")
                    self.btnDeleteImage1.isHidden = true
                    break
                case CarImageType.Back.rawValue:
                    self.imgCar2.image = #imageLiteral(resourceName: "camerabox")
                    self.btnDeleteImage2.isHidden = true
                    break
                case CarImageType.Right.rawValue:
                    self.imgCar3.image = #imageLiteral(resourceName: "camerabox")
                    self.btnDeleteImage3.isHidden = true
                    break
                case CarImageType.Left.rawValue:
                    self.imgCar4.image = #imageLiteral(resourceName: "camerabox")
                    self.btnDeleteImage4.isHidden = true
                    break
                case CarImageType.Interior.rawValue:
                    self.imgCar5.image = #imageLiteral(resourceName: "camerabox")
                    self.btnDeleteImage5.isHidden = true
                    break
                case CarImageType.Registration.rawValue:
                    self.imgCar6.image = #imageLiteral(resourceName: "camerabox")
                    self.btnDeleteImage6.isHidden = true
                    break
                default:
                    break
                }
                self.carPhotos.remove(at: index)
                if image.id != 0{
                    self.deleted_images.append("\(image.id)")
                }
                break
            }
        }
    }
    
    func openImagePickerForSelectedImage(){
        if carPhotos.count >= 6 {
            Utility.showErrorWith(message: Messages.CarPhotoLimit.rawValue)
        } else {
            ImagePickerHelper.sharedInstance.showPicker(delegate: self)
        }
    }
    
    func setupField() {
        self.countryCode.delegate = self
        self.countryCode.phonePickerDelegate = self
        let currentLocale = NSLocale.current as NSLocale
        let code = currentLocale.object(forKey: .countryCode) as? String
       // self.countryCode.country = Country.country(for: NKVSource(countryCode: code ?? ""))
        self.countryCode.country = Country.country(for: NKVSource(countryCode: "AE"))
        
        if let userData = AppStateManager.sharedInstance.userData?.user {
            if !(userData.details?.phone?.isEmpty ?? true) {
                self.countryCode.country = Country.country(for: NKVSource.init(phoneExtension: userData.details?.country_code ?? "AE"))
            }
        }
    }
  
    func registerCells() {

    }
    
    func setGestures() {
        makeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.makeViewTapped(sender:))))
        modelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.modelViewTapped(sender:))))
        YearsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.YearsViewTapped(sender:))))
        regionsSpecificView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.regionsSpecificViewTapped(sender:))))
        accidentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.accidentViewTapped(sender:))))
        interiorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.interiorViewTapped(sender:))))
        exteriorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.exteriorViewTapped(sender:))))
        engineTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.engineTypeViewTapped(sender:))))
    }
    
    func getAllData() {
        self.getMake(show: false)
        self.getRegionalSpecs()
        self.getInteriorColors()
        self.getExteriorColors()
        self.getEngineTypes()
        self.getAccidentAttributes()
    }

    func getMake(show: Bool = false) {
        APIManager.sharedInstance.getBrands(for_comparision: 0, success: { (result) in
            self.brands = result
            if show {
                Utility().showSelectionPopup(title: SelectionType.Make.rawValue ,items: self.brands.map{$0.name ?? ""}, delegate: self)
            }
        }) { (error) in
            
        }
    }
    
    func showMakePopup() {
        view.endEditing(true)
        if self.brands.count < 1 {
            getMake(show: true)
        } else {
            Utility().showSelectionPopup(title: SelectionType.Make.rawValue ,items: self.brands.map{$0.name ?? ""}, delegate: self)
        }
    }
    
    func getModels(show: Bool = false) {
        if let brand = selectedbrand, let brandId = brand.id {
            APIManager.sharedInstance.getCarModels(brandId: brandId, categoryId: 0, for_comparision: 0,success: { (result) in
                self.carModels = result
                if show {
                    Utility().showSelectionPopup(title: SelectionType.Model.rawValue ,items: self.carModels.map{$0.name ?? ""}, delegate: self)
                }
            }) { (error) in
                
            }
        } else {
            Utility.showAlert(title: "Error", message: Messages.SelectMakeFirst.rawValue)
        }
        
    }
    
    func showModelPopup() {
        view.endEditing(true)
        getModels(show: true)
    }
   
    func getRegionalSpecs(show: Bool = false) {
        APIManager.sharedInstance.getRegionalSpecs(success: { (result) in
            self.regionalSpecs = result
            if show {
                Utility().showSelectionPopup(title: SelectionType.RegionalSpecs.rawValue ,items: self.regionalSpecs.map{$0.name ?? ""}, delegate: self)
            }
        }) { (error) in
            
        }
    }
    
    func showReionalSpecsPopup() {
        view.endEditing(true)
        if self.regionalSpecs.count < 1 {
            getRegionalSpecs(show: true)
        } else {
            Utility().showSelectionPopup(title: SelectionType.RegionalSpecs.rawValue ,items: self.regionalSpecs.map{$0.name ?? ""}, delegate: self)
        }
    }
    
    func getInteriorColors(show: Bool = false) {
        APIManager.sharedInstance.getInteriorColors(success: { (result) in
            if let optionaArray = result.option_array {
                self.interiorColors = optionaArray
            }
            if show {
                Utility().showSelectionPopup(title: SelectionType.InteriorColors.rawValue ,items: self.interiorColors.map{$0.name ?? ""}, delegate: self)
            }
        }) { (error) in
            
        }
    }
    
    func showInteriorColorsPopup() {
        view.endEditing(true)
        if self.interiorColors.count < 1 {
            getInteriorColors(show: true)
        } else {
            Utility().showSelectionPopup(title: SelectionType.InteriorColors.rawValue ,items: self.interiorColors.map{$0.name ?? ""}, delegate: self)
        }
    }
    
    func getExteriorColors(show: Bool = false) {
        APIManager.sharedInstance.getExteriorColors(success: { (result) in
            if let optionaArray = result.option_array {
                self.exteriorColors = optionaArray
            }
            if show {
                Utility().showSelectionPopup(title: SelectionType.ExteriorColors.rawValue ,items: self.exteriorColors.map{$0.name ?? ""}, delegate: self)
            }
        }) { (error) in
            
        }
    }
    
    func showExteriorColorsPopup() {
        view.endEditing(true)
        if self.exteriorColors.count < 1 {
            getExteriorColors(show: true)
        } else {
            Utility().showSelectionPopup(title: SelectionType.ExteriorColors.rawValue ,items: self.exteriorColors.map{$0.name ?? ""}, delegate: self)
        }
    }
    
    func getEngineTypes(show: Bool = false) {
        APIManager.sharedInstance.getEngineTypes(success: { (result) in
            if let optionaArray = result {
                self.engineType = optionaArray
            }
            if show {
                Utility().showSelectionPopup(title: SelectionType.EngineType.rawValue ,items: self.engineType.map{$0.name ?? ""}, delegate: self)
            }
        }) { (error) in
            
        }
    }
    
    func showEngineTypePopup() {
        view.endEditing(true)
        if self.engineType.count < 1 {
            getEngineTypes(show: true)
        } else {
            Utility().showSelectionPopup(title: SelectionType.EngineType.rawValue ,items: self.engineType.map{$0.name ?? ""}, delegate: self)
        }
    }
    
    func getAccidentAttributes(show: Bool = false) {
        APIManager.sharedInstance.getAccident(success: { (result) in
            if let optionaArray = result.option_array {
                self.accidentModel = optionaArray
            }
            if show {
                Utility().showSelectionPopup(title: SelectionType.ExteriorColors.rawValue ,items: self.accidentModel.map{$0.name ?? ""}, delegate: self)
            }
        }) { (error) in
            
        }
    }
    
    func showVersionsPopup() {
        if let selectedModel = self.selectedCarModel {
            APIManager.sharedInstance.getCarVersion(model_id: selectedModel.id.unWrap, success: { (result) in
                if result.count > 0 {
                    self.versionsModel = result
                    Utility().showSelectionPopup(title: SelectionType.Versions.rawValue ,items: self.versionsModel.map{$0.name ?? ""}, delegate: self)
                } else {
                    Utility.showErrorWith(message: Messages.VersionsNotFound.rawValue)
                }
            }) { (error) in
                
            }
        } else {
            Utility.showAlert(title: "Error", message: Messages.SelectModelFirst.rawValue)
        }
    }
    
    func showAccidentPopup() {
        view.endEditing(true)
        if self.accidentModel.count < 1 {
            getAccidentAttributes(show: true)
        } else {
            Utility().showSelectionPopup(title: SelectionType.Accident.rawValue ,items: self.accidentModel.map{$0.name ?? ""}, delegate: self)
        }
    }
    
    func showYearPopup() {
        if self.years.count < 1 {
            var lastYear = (Calendar.current.component(.year, from: Date()) + 1)
            for _ in 0..<75 {
                lastYear -= 1
                self.years.append(lastYear.description)
            }
        }
       
       
        view.endEditing(true)
        Utility().showSelectionPopup(title: SelectionType.Years.rawValue ,items: self.years, delegate: self)
    }
    
    func validateForm() -> Bool {
        if !ValidationsUtility.isNotEmpty(string: nameField.text ?? "") {
            Utility.showAlert(title: "Error", message: Messages.EnterName.rawValue)
            return false
        } else if !ValidationsUtility.isNotEmpty(string: emailField.text ?? "") {
            Utility.showAlert(title: "Error", message: Messages.EnterEmail.rawValue)
            return false
        } else if !ValidationsUtility.isValidEmail(email: emailField.text ?? "")  {
                Utility.showAlert(title: "Error", message: Messages.EnterValidEmail.rawValue)
                return false
        }
        else if !ValidationsUtility.isNotEmpty(string: phoneNumber.text ?? "")  {
            Utility.showAlert(title: "Error", message: Messages.EnterPhone.rawValue)
            return false
        }
        else if !ValidationsUtility.isValidPhone(phone: phoneNumber.text ?? "") {
            Utility.showAlert(title: "Error", message: Errors.InvalidPhone.rawValue)
            return false
        }
        else if self.selectedbrand == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectMake.rawValue)
            return false
        } else if self.selectedCarModel  == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectModel.rawValue)
            return false
        } else if self.selectedYear == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectYear.rawValue)
            return false
        } else if !ValidationsUtility.isNotEmpty(string: kmField.text ?? "") {
            Utility.showAlert(title: "Error", message: Messages.SelectKM.rawValue)
            return false
        }else if !ValidationsUtility.isNotEmpty(string: chesisField.text ?? "") {
            Utility.showAlert(title: "Error", message: Messages.SelectChassis.rawValue)
            return false
        }else if self.selectedRegionalSpecs == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectRegionalSpecs.rawValue)
            return false
        } else if self.selectedAccident == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectAccident.rawValue)
            return false
        } else if self.selectedExteriorColor == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectExterior.rawValue)
            return false
        } else if self.selectedInteriorColor == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectInterior.rawValue)
            return false
        }
        else if self.selectedEngineType == nil {
            Utility.showAlert(title: "Error", message: Messages.SelectEngineType.rawValue)
            return false
        }
//        else if (self.trimField.text ?? "").isEmpty {
//            Utility.showAlert(title: "Error", message: Messages.EnterTrim.rawValue)
//            return false
//        }
        else if (self.warrantyRemainingField.text ?? "").isEmpty {
            Utility.showAlert(title: "Error", message: Messages.EnterWarrantyRemaining.rawValue)
            return false
        }
        else if (self.serviceRemainingField.text ?? "").isEmpty {
            Utility.showAlert(title: "Error", message: Messages.EnterServiceRemaining.rawValue)
            return false
        }
        else if self.carPhotos.isEmpty {
            Utility.showAlert(title: "Error", message: Messages.UploadCarPhotos.rawValue)
            return false
        } else if !self.btnCheck.isSelected {
            Utility.showAlert(title: "Error", message: "You must read and agree with the terms of use.")
            return false
        }
        
        return true
    }
    
    func submitData() {
        view.endEditing(true)
        
       if !AppStateManager.sharedInstance.isUserLoggedIn(){
            AlertViewController.showAlert(title: "Require Signin", description: "You need to sign in to your account to see the list of your cars and get them evaluated. Do you want to signin?") {
                let signinController = SignInViewController.instantiate(fromAppStoryboard: .Login)
                signinController.isGuest = true
                self.present(UINavigationController(rootViewController: signinController), animated: true, completion: nil)
            }
       }else{
        
        let dict = [
            [CarAttributeType.InteriorColor.rawValue.description : selectedInteriorColor?.id?.description ?? ""],
            [CarAttributeType.ExteriorColor.rawValue.description : selectedExteriorColor?.id?.description ?? ""]
            ,
            [CarAttributeType.Trim.rawValue.description : self.trimField.text ?? ""],
            [CarAttributeType.WarrantyRemaining.rawValue.description : self.warrantyRemainingField.text ?? ""],
            [CarAttributeType.ServiceContract.rawValue.description : self.serviceRemainingField.text ?? ""],
            [CarAttributeType.Accident.rawValue.description : self.selectedAccident?.id ?? 0]]
        
        let obj = JSON(dict)
        
        print(obj)
        
        var params: Parameters = [
            "name":nameField.text ?? "",
            "email":emailField.text ?? "",
            "country_code":countryCode.code ?? "",
            "phone":phoneNumber.text ?? "",
            "chassis":chesisField.text ?? "",
            "kilometer":kmField.text ?? "",
            "version_app": self.versionField.text ?? "",
            "model_id": selectedCarModel?.id?.description ?? "",
            "year":selectedYear ?? "",
            "regional_specification_id":selectedRegionalSpecs?.id?.description ?? "",
            "car_attributes": obj.description,
            "notes":aboutYourselfTextview.text ?? "",
            "engine_type_id":self.selectedEngineType?.id ?? 0
        ]
        
        var image: [[String: Any]] = []
        
        print(params)
        for item in self.carPhotos {
            if item.id == 0 {
                image.append(["key":"media[\(item.type)]","value":item.photo])
            }
        }
        
        if self.tradeCarType == .editAddedCar{
            
            params["id"] = self.selectedVehicleDetail?.id ?? 0
            params["_method"] = "PUT"
            params["deleted_images"] = self.deleted_images.joined(separator: ",")
            
            APIManager.sharedInstance.editCarInTrade(params: params, images: image,  success: { (result) in
                print("Success",result)
                //          self.clearFields()
                self.showThanksPopup()
            }, failure: { (error) in
                print("failure")
            })
        }
        else{
            APIManager.sharedInstance.addCarInTrade(params: params, images: image,  success: { (result) in
                print("Success",result)
                if self.tradeCarType == .AddAndTrade{
                    print(result)
                    self.delegate?.tradeAddedCarWith(addedCar:result, fromAddCar: true)
                }
                else{
                    self.selectedVehicleDetail = result
                    self.showThanksPopup()
                }
            }, failure: { (error) in
                print("failure")
            })
        }
        }

      
    }
    
    func showThanksPopup() {
        if self.tradeCarType == TradeCarType.addNewCar{
//            AlertViewController.showAlert(title: Constants.NEW_CAR, description: Constants.EVALUATE_NOW, rightButtonText: Constants.YES, leftButtonText: Constants.LATER, delegate: self)
            Utility().showCustomPopup(titile: "SUCCESS", descTitle: "", desc: "You added your car successfully!", btnOkTitle: "OK", delegate: self)
            return
        }
        Utility().showCustomPopup(titile: "EDIT CAR", descTitle: Constants.THANK_YOU, desc: "You edited your car successfully", btnOkTitle: "OK", delegate: self)
    }
    
    func clearFields() {
        nameField.text = ""
        emailField.text = ""
        phoneNumber.text = ""
        kmField.text = ""
        chesisField.text = ""
        aboutYourselfTextview.text = ""
        selectedbrand = nil
        selectedCarModel = nil
        selectedAccident = nil
        selectedRegionalSpecs = nil
        selectedInteriorColor = nil
        selectedExteriorColor = nil
        selectedEngineType = nil
        selectedYear = nil
        self.makeLabel.text = "Make"
        self.modelLabel.text = "Model"
        self.regionSpecificLabel.text = "Regional specs"
        self.accidentLabel.text = "Accident?"
        self.interiorLabel.text = "Exterior Color"
        self.exteriorLabel.text = "Interior Color"
        self.carPhotos.removeAll()
        //self.photosCollectionView.reloadData()
        
    }
    
//    func updateImageCount() {
//        photoCount.text = String(format: "\(Constants.UPLOAD_UPTO)\(self.carPhotos.count > 1 ? "s" : "")", self.carPhotos.count)
//    }
    
    @IBAction func tappedOnSubmit(sender: AnyObject) {
        if self.validateForm() {
            self.submitData()
        }
    }
    
    @IBAction func tappedOnCheck(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func makeViewTapped(sender: AnyObject) {
        self.showMakePopup()
    }
    
    @objc func modelViewTapped(sender: AnyObject) {
        self.showModelPopup()
    }
    
    @objc func YearsViewTapped(sender: AnyObject) {
        self.showYearPopup()
    }
    
    @objc func regionsSpecificViewTapped(sender: AnyObject) {
        self.showReionalSpecsPopup()
    }
    
    @objc func accidentViewTapped(sender: AnyObject) {
        self.showAccidentPopup()
    }
    
    @objc func exteriorViewTapped(sender: AnyObject) {
        self.showExteriorColorsPopup()
    }
    
    @objc func engineTypeViewTapped(sender: AnyObject) {
        self.showEngineTypePopup()
    }
    
    @objc func interiorViewTapped(sender: AnyObject) {
        self.showInteriorColorsPopup()
    }
    
    @IBAction func tappedOnVersion() {
        self.showVersionsPopup()
    }

    @IBAction func tappedOnTermsAndCondiftions() {
      
        APIManager.sharedInstance.getPages(success: { (result) in
            for item in result {
                if item.title == "Terms and conditions" {
                    let fullScreenTextController = FullScreenTextController.instantiate(fromAppStoryboard: .Popups)
                    fullScreenTextController.content = item.content ?? ""
                    self.navigationController?.pushViewController(fullScreenTextController, animated: true)
                    break
                }
            }
            
        }) { (error) in
            
        }
    }
}
//
//extension TradeCarController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = photosCollectionView?.dequeueReusableCell(withReuseIdentifier: cells[indexPath.section].identifier, for: indexPath)
//
//        if let photoCell = cell as? CarPhotosCell {
//            photoCell.delegate = self
//            photoCell.position = indexPath.row
//            photoCell.setData(image: carPhotos[indexPath.row].photo)
//        }
//
//        return cell!
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if cells[section].count == -1 {
//            if cells[section].identifier == CarPhotosCell.identifier {
//                return carPhotos.count
//            }
//        } else {
//            return cells[section].count
//        }
//
//        return 0
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return cells.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 70 , height: 70)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if cells[indexPath.section].identifier == self.AddPhotoCellIdentifier {
//            if carPhotos.count >= 5 {
//                Utility.showErrorWith(message: Messages.CarPhotoLimit.rawValue)
//            } else {
//                ImagePickerHelper.sharedInstance.showPicker(delegate: self)
//            }
//
//        } else {
//
//        }
//    }
//
//}

extension TradeCarController: ItemSelectionDelegate {
    func didItemSelect(position: Int, tag: String) {
        switch tag {
            case SelectionType.Make.rawValue:
                 selectedbrand = brands[position]
                 makeLabel.text = "Make : " + (selectedbrand?.name ?? "")
                 selectedCarModel = nil
                 modelLabel.text = "Model"
                 selectedYear = nil
                 yearLabel.text = "Year"
            break
            case SelectionType.Model.rawValue:
                selectedCarModel = carModels[position]
                modelLabel.text = "Model : " + (selectedCarModel?.name ?? "")
                
                selectedYear = nil
                yearLabel.text = "Year"
            break
            case SelectionType.RegionalSpecs.rawValue:
                selectedRegionalSpecs = regionalSpecs[position]
                regionSpecificLabel.text = "Regional specs : " + (selectedRegionalSpecs?.name ?? "")
                break
            case SelectionType.InteriorColors.rawValue:
                selectedInteriorColor = interiorColors[position]
                interiorLabel.text = "Interior Color : " + (selectedInteriorColor?.name ?? "")
                break
            case SelectionType.ExteriorColors.rawValue:
                selectedExteriorColor = exteriorColors[position]
                exteriorLabel.text = "Exterior Color : " + (selectedExteriorColor?.name ?? "")
                break
        case SelectionType.EngineType.rawValue:
            selectedEngineType = engineType[position]
            engineTypeLabel.text = "Engine Type : " + (selectedEngineType?.name ?? "")
            break
        case SelectionType.Accident.rawValue:
            selectedAccident = accidentModel[position]
            accidentLabel.text = "Accident : " + (selectedAccident?.name ?? "")
            break
        case SelectionType.Years.rawValue:
            selectedYear = years[position]
            yearLabel.text = "Year : " + (selectedYear ?? "")
            break
        case SelectionType.Versions.rawValue:
            break
        default:
            break
        }
    }
}

extension TradeCarController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCode {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // User pressed the delete-key to remove a character, this is always valid, return true to allow change
        if textField == kmField{
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == maxLength{
                return false
            }
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                return true
            case ".":
                let array = Array(textField.text ?? "")
                var decimalCount = 0
                for character in array {
                    if character == "." {
                        decimalCount += 1
                    }
                }
                if decimalCount == 1 {
                    return false
                } else {
                    return true
                }
            default:
                let array = Array(string)
                if array.count == 0 {
                    return true
                }
                return false
            }
        }
        else if textField == chesisField{
            let maxLength = 18
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == maxLength{
                return false
            }
            else{
                return true
            }
        }
        else if textField == serviceRemainingField || textField == warrantyRemainingField {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == maxLength{
                return false
            }
            else{
                return true
            }
        }
        return true
    }
}

extension TradeCarController: ImagePickerDelegate {
    func didImageSelected(image: UIImage) {
        let obj = CarPhotosWithIDs(photo: image, id: 0,type:self.imageType)
        for (index,item) in self.carPhotos.enumerated(){
            if item.type == self.imageType{
                self.carPhotos.remove(at: index)
                break
            }
        }
        self.carPhotos.append(obj)
        self.setCarImages()
    }

    func didCancel() {
        self.imageType = ""
    }
}

//extension TradeCarController: CarPhotoCellDelegate {
//    func didTapOnClose(position: Int) {
//        let id = self.carPhotos[position].id
//        if id != 0 {
//            self.deleted_images.append("\(id)")
//        }
//        self.carPhotos.remove(at: position)
//        self.photosCollectionView.reloadData()
//        self.updateImageCount()
//    }
//}

extension TradeCarController: PopupDelgates {
    func didTapOnClose() {
        AlertViewController.showAlert(title: Constants.NEW_CAR, description: Constants.EVALUATE_NOW, rightButtonText: Constants.YES, leftButtonText: Constants.LATER, delegate: self)
       // self.navigationController?.popViewController(animated: true)
    }
}

extension TradeCarController: AlertViewDelegates {
        func didTapOnRightButton() {
            let customer_car_id = selectedVehicleDetail?.id ?? 0
            var notes = ""
            if (self.aboutYourselfTextview.text ?? "") != Constants.AdditionalNotes{
                notes = self.aboutYourselfTextview.text ?? ""
            }
            let type = TradeEvaluateCarType.evaluate.rawValue
            let params:[String:Any] = ["customer_car_id":customer_car_id,"type":type,"notes":notes]
            print(params)
            APIManager.sharedInstance.postTradeInCar(params: params, success: { (response) in
                print(response)
                self.navigationController?.popViewController(animated: true)
                if let message = response["message"] as? String{
                    Utility.showSuccessWith(message: message)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        func didTapOnLeftButton() {
            self.navigationController?.popViewController(animated: true)
        }
    }
