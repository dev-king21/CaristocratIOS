//
//  Enums.swift

import Foundation

enum AppStoryboard : String {
    
    //Add all the storyboard names you wanted to use in your project
    case Main, Login, Home, LuxuryMarket, Popups, Consultant
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

enum EventName {
    case didCountrySelected
    case didTapOnCollapseExpand
}

enum Response : Int{
    case success = 200
    case serverError = 500
    case undefined = 0
}

enum Params : String {
    case deviceToken = "device_token"
    case deviceType = "device_type"
    case phone = "phone"
}

enum UserDefaultsKeys : String {
    case deviceToken = "device_token"
}

enum FontsType: String {
    case Heading = "Ailerons-Regular" 
    case Light = "Poppins-Light"
    case Regular = "Poppins-Regular"
    case Medium = "Poppins-Medium"
    case SemiBold = "Poppins-SemiBold"
    case Bold = "Poppins"
}

enum InteractionType: Int {
    case View = 10
    case Like = 20
    case Favorite = 30
    case MainCat = 40
    case Phone = 45
    case Request = 50
}

enum DateFormats: String {
    case Date = "dd-MMM"
    case Time = "HH:mm"
    case DateTime = "dd-MMM hh:mm a"
}

enum Errors: String {
    case EmptyField = "Please enter "
    case InvalidData = "Please enter valid "
    case PasswordMismatch = "Password mismatch"
    case MinimumLength = "should be at 3 least characters long"
    case InvalidPhone = "Please enter valid Phone Number"
    case EnterReason = "Please enter Reason"
}

enum Messages: String {
    case PasswordChanged = "Password changed successfully"
    case ProfileUpdate = "Profile updated successfully"
    case ImplementLater = "Coming Soon"
    case CodeSent = "Verification code sent to your email"
    case CodeResent = "Verification code has been re-sent successfully"
    case RegionUpdated = "Region updated successfully"
    case SelectMake = "Please select Make"
    case SelectModel = "Please select Model"
    case SelectYear = "Please select Year"
    case SelectVersion = "Please select Version"
    case SelectKM = "Please enter KM"
    case SelectChassis = "Please enter Chassis"
    case SelectRegionalSpecs = "Please select Regional Specs"
    case SelectAccident = "Please select Accident"
    case SelectExterior = "Please select Exterior Color"
    case SelectInterior = "Please select Interior Color"
    case SelectMakeFirst = "Please select make first"
    case SelectModelFirst = "Please select model first"
    case EnterName = "Please enter Full Name"
    case EnterEmail = "Please enter Email"
    case EnterPhone = "Please enter Phone Number"
    case SelectRegion = "Please select region"
    case EnterValidEmail = "Please valid enter Email"
    case RequestSubmited = "Your Request submitted"
    case CarPhotoLimit = "Maximum car photos limit is 6"
    case ReportSubmitted = "Report Submitted"
    case SelectCarModel = "Please select Car Model"
    case SelectEngineType = "Please select Engine Type"
    case EnterTrim = "Please enter Trim"
    case EnterWarrantyRemaining = "Please enter Warranty Remaining"
    case EnterServiceRemaining = "Please enter Service Remaining"
    case UploadCarPhotos = "Please upload car photos"
    case FilterCleared = "Filter Cleared"
    case ProfileCompleted = "Profile is completed"
    case SelectTwoCar = "Please select atleast 2 Cars for comparison"
    case NoCarsFound = "There is no car to compare"
    case SelectBrand = "Please select Brand"
    case VehiclesNotFound = "Vehicles not found"
    case VersionsNotFound = "Versions not found"
}

enum SelectionType: String {
    case Make = "Make"
    case Model = "Model"
    case RegionalSpecs = "Regional Specification"
    case InteriorColors = "Interior Color"
    case ExteriorColors = "Exterior Color"
    case Accident = "Accident?"
    case Years = "Years"
    case Versions = "Versions"
    case EngineType = "Engine"
}

enum CarAttributeType: Int {
    case InteriorColor = 3
    case ExteriorColor = 4
    case WarrantyRemaining = 5;
    case ServiceContract = 6;
    case Accident = 23;
    case Trim = 24;
}

enum TradeEvaluateCarType: String {
    case evaluate = "20"
    case trade = "10"
}

enum Events : String {
    case onNewsUpdate = "onNewsUpdate"
    case onNewsSeen = "onNewsSeen"
    case onProfileUpdate = "onProfileUpdate"
}

enum CarImageType : String {
    case Front = "front"
    case Back = "back"
    case Right = "right"
    case Left = "left"
    case Interior = "interior"
    case Registration = "registration"
}

enum ContactType:Int{
    case Consultancy = 10
    case MyShopper = 20
    case VirtualBuy = 30
}

enum LoginWith: String {
    case Facebook = "facebook"
    case google = "google"
}

enum CategoryType: Int {
    case News = 10
    case Comparision = 20
    case LuxuryMarket = 30
    case Consultant = 40
}

enum Slugs: String {
    case THE_OUTLET_MALL = "the-outlet-mall";
    case APPROVED_PRE_OWNED = "approved-pre-owned";
    case CLASSIC_CARS = "classic-cars";
    case LUXURY_MARKET = "luxury-new-cars"
    case COMPARE = "compare"
    case EVALUATE_MY_CAR = "evaluate-my-car"
    case VIN_CHECK = "vin-check"
    case ASK_FOR_CONSULTANCY = "ask-for-consultancy"
    case REVIEWS = "reviews"
}

enum Gender: Int {
    case Male = 10
    case Female = 20
    case None = 0
}

enum VehicleSortModes: Int {
    case NewestToOldest = 10
    case OldestToNewest = 20
    case LowestPrice = 30
    case HighestPrice = 40
}

enum ReviewsSortModes: Int {
    case LatestReviews = 10
    case HighestRatings = 20
    case LowestRatings = 30
    case NoofReviews = 40
}

//Last requested service data
enum LastService {
    static var totalCount : Int = 0
}
