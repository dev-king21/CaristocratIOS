import UIKit
import Realm
import RealmSwift

class RealmString: Object {
    @objc dynamic var stringValue = ""
}



import UIKit
import Realm
import RealmSwift


class User: Object {
    
    
    @objc dynamic var Id = 0
    
    @objc dynamic var FirstName : String?
   
    @objc dynamic var LastName : String?
   
    @objc dynamic var FullName : String?
    
    @objc dynamic var ProfilePictureUrl : String?
    {
        didSet
        {
            if ProfilePictureUrl != nil && !(ProfilePictureUrl?.contains("http"))!
            {
                ProfilePictureUrl = Constants.BaseURL + ProfilePictureUrl!
            }
        }
    }
   
    @objc dynamic var Email : String?
    
    @objc dynamic var Address : String? = ""
    
    @objc dynamic var EmailConfirmed = false
    
    @objc dynamic var Phone : String?
    
    @objc dynamic var PhoneConfirmed = false
    
    var Status : Int?
    
    @objc dynamic var ZipCode : String?
   
    var UserAddresses = List<UserAddresses>()
    
    @objc dynamic var IsNotificationsOn = false
    
    @objc dynamic var DateofBirth : String?
    
    @objc dynamic var SignInType = -1
    
    @objc dynamic var UserName : String?
    
    @objc dynamic var Token : token? = token()
    
    var PaymentCards = List<PaymentCardBindingModel>()
    
    @objc dynamic var BasketSettings : basketSettings? = basketSettings()
    
    @objc dynamic var IsDeleted = false
    
    @objc dynamic var IsOnline = false
    
    
    
    
    
    override class func ignoredProperties() -> [String] {
        return ["images", "Services", "Categories"]
    }
    
    
    override static func primaryKey() -> String? {
        return "Id"
    }
    
    
    func checkifValid() -> Bool{
        let status = false
        
        return status
        
    }
    
}

class basketSettings : Object
{
    
    @objc dynamic var Help : String? = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
   
    @objc dynamic var AboutUs : String? = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    
    @objc dynamic var DeliveryFee  = 0.0
    
    
    @objc dynamic var MinimumOrderPrice  = 0.0
    
    
    @objc dynamic var Currency : String? = ""
        {
        didSet
        {
            if Currency != nil
            {
                Constants.CURRENCY_STRING = Currency!
            }
        }
    }
    
    @objc dynamic var StandardWorkingHours : String? = ""
}


class token : Object
{
    
    @objc dynamic var access_token : String? = ""
    
    @objc dynamic var token_type : String? = ""
    
    @objc dynamic var expires_in : String? = ""
    
    @objc dynamic var refresh_token : String? = ""
}
class UserAddresses : Object
{
    
    @objc dynamic var Id = -1
    
    @objc dynamic var User_ID = -1
    
    @objc dynamic var Country : String? = ""
    
    @objc dynamic var City : String? = ""
    
    @objc dynamic var StreetName : String? = ""
    
    @objc dynamic var Floor : String? = ""
    
    @objc dynamic var Apartment : String? = ""
    
    @objc dynamic var NearestLandmark : String? = ""
    
    @objc dynamic var `Type` = -1
    
    @objc dynamic var IsDeleted = false
    
    @objc dynamic var IsPrimary = false
   
    @objc dynamic var BuildingName : String? = ""
    
    
}

