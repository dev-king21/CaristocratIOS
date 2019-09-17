import UIKit
import RealmSwift
class AppStateManager: NSObject {
    
    static let sharedInstance = AppStateManager()
    var loggedInUser: User!
    var realm: Realm!
    
    let Network =  CEReachabilityManager.shared()
    var categoryFilterSelected: Any?
    
    override init() {
        super.init()
        
        if(!(realm != nil)){
//            realm = try! Realm()
        }
        
//        loggedInUser = realm.objects(User.self).first
        if (loggedInUser == nil) {
            
        } else {
            print("\(loggedInUser.Token)")
        }
        
    }
    var refId: Int?
    var accessToken: String {
        get{
            return UserDefaults.standard.string(forKey: Constants.ACCESS_TOKEN) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.ACCESS_TOKEN)
        }
    }
    
    var isRememberCountry: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.REMEMBER_COUNTRY)
        } set {
             UserDefaults.standard.set(newValue, forKey: Constants.REMEMBER_COUNTRY)
        }
    }
    
    var deviceToken: String {
        get{
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.deviceToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.deviceToken.rawValue)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return self.userData?.user != nil
    }
  
    var isUserLogIn: Bool {
        get{
            return UserDefaults.standard.bool(forKey: Constants.USER_LOGGED_IN)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.USER_LOGGED_IN)
        }
    }
    
    var isTutorialShown: Bool {
        get{
            return UserDefaults.standard.bool(forKey: Constants.IS_TUTORIAL_SHOWN)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.IS_TUTORIAL_SHOWN)
        }
    }
    
    var userData: UserBaseModel? {
        get{
            return Utility.getObject(key: Constants.USER_DATA_KEY, object: UserBaseModel.self)
        }
        set {
            Utility.saveObject(key: Constants.USER_DATA_KEY, object: newValue)
        }
    }
    
    var subCategoryOrder: Dictionary<String,Any> {
        get {
            if let dict = UserDefaults.standard.dictionary(forKey: Constants.SUBCATEGORY_ORDER) {
                return dict
            }
            return [:]
        } set (val){
            UserDefaults.standard.set(val, forKey: Constants.SUBCATEGORY_ORDER)

        }
    }
    
    var categoryOrder: Dictionary<String, Any> {
        get {
            if let dict = UserDefaults.standard.dictionary(forKey: Constants.CATEGORY_ORDER) {
                return dict
            }
            return [:]
        } set (val){
            UserDefaults.standard.set(val, forKey: Constants.CATEGORY_ORDER)
            
        }
    }
    
    var urlData: [String:String]?
    
    var filterOptions: FilterModel?
    var notificationCarType: String?

    func isGuestUser() -> Bool {
        var guest = false
        if(self.loggedInUser) != nil{
            if(self.loggedInUser.Id == 0){
                guest = true
            }else{
                guest = false
            }
        }

        return guest
    }
    
    
    func clearFilter(withCountry: Bool) {
        if withCountry {
            filterOptions = FilterModel()
        } else {
            let selectedCountries = filterOptions?.selectedCountries
            filterOptions = FilterModel()
            filterOptions?.selectedCountries = selectedCountries ?? [:]
        }
        
    }
    
    func markUserLogout(){
        if( Utility.checkLogout())
        {
//            Utility.markUserInactive()
            try!  self.realm.write(){
                
                self.realm.delete(self.loggedInUser)
                self.realm.deleteAll()
                self.loggedInUser = nil
            }
            //self.changeRootViewController()
        }
    }
    
    
    func changeRootViewController(){
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // appDelegate.changeRootViewController()
    }
    
    
    func proceedToAppFromSplash(){
        
        if(self.isUserLoggedIn()){
            self.changeRootViewController()
        }else{
            
        }
    }
    
    func getImageForCategory(categoryIcon: String) -> [Any] {
        switch (categoryIcon) {
        case "x-dining":
            return [#imageLiteral(resourceName: "icon_food"), #imageLiteral(resourceName: "icon_food_white"), Constants.cc_food]
        case "x-lipstick":
            return [#imageLiteral(resourceName: "icon_beauty"), #imageLiteral(resourceName: "icon_beauty_white"), Constants.cc_beauty]
        case "x-cloth":
            return [#imageLiteral(resourceName: "icon_fashion"), #imageLiteral(resourceName: "icon_fashion_white"), Constants.cc_fashion]
        case "x-basket":
            return [#imageLiteral(resourceName: "icon_grocery"), #imageLiteral(resourceName: "icon_grocery_white"), Constants.cc_grocery]
        case "x-computer":
            return [#imageLiteral(resourceName: "icon_electronics"), #imageLiteral(resourceName: "icon_electronics_white"), Constants.cc_electronic]
        case "x-horse":
            return [#imageLiteral(resourceName: "icon_kids"), #imageLiteral(resourceName: "icon_kids_white"), Constants.cc_kids]
        case "x-mobile":
            return [#imageLiteral(resourceName: "icon_mobile"), #imageLiteral(resourceName: "icon_mobile_white"), Constants.cc_mobile]
        case "x-bed":
            return [#imageLiteral(resourceName: "icon_home"), #imageLiteral(resourceName: "icon_home_white"), Constants.cc_home]
        case "x-exercise":
            return [#imageLiteral(resourceName: "icon_health"), #imageLiteral(resourceName: "icon_health_white"), Constants.cc_health]
        case "x-mask":
            return [#imageLiteral(resourceName: "icon_arts"), #imageLiteral(resourceName: "icon_arts_white"), Constants.cc_art]
        case "x-bag":
            return [#imageLiteral(resourceName: "icon_travel"), #imageLiteral(resourceName: "icon_travel_white"), Constants.cc_travel]
        case "x-cone":
            return [#imageLiteral(resourceName: "icon_event"), #imageLiteral(resourceName: "icon_event_white"), Constants.cc_events]
        case "x-books":
            return [#imageLiteral(resourceName: "icon_education"), #imageLiteral(resourceName: "icon_education_white"), Constants.cc_education]
        case "x-car":
            return [#imageLiteral(resourceName: "transport"), #imageLiteral(resourceName: "transport_white"), Constants.cc_transport]
        case "x-creditCard":
            return [#imageLiteral(resourceName: "icon_services"), #imageLiteral(resourceName: "icon_services_white"), Constants.cc_service]
        case "x-rectangle":
            return []
        default:
            break

        }
        
        return [];
        
    }
    
    var tempDeviceToken = ""
    func clearData() {
        if tempDeviceToken.isEmpty {
            tempDeviceToken = deviceToken
        }
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.deviceToken = self.tempDeviceToken
        }
        isTutorialShown = true
        
    }
   
    
}
