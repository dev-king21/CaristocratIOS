
import UIKit
import RealmSwift
import Realm
class CreditCardModel: Object {
    @objc dynamic var DateTime : String? = ""
    @objc dynamic var CCV : String? = ""
    @objc dynamic var NameOnCard : String? = ""
    @objc dynamic var CardType = -1
    @objc dynamic var User_ID = -1

}


class PaymentCardBindingModel: Object {
    @objc dynamic var Id = -1
    @objc dynamic var IsEdit = false
    
    @objc dynamic var CardNumber : String? = ""
    @objc dynamic var IsDeleted = false

    @objc dynamic var ExpiryDate : String? = ""
    @objc dynamic var CCV  : String? = ""
    @objc dynamic var NameOnCard : String? = ""
    @objc dynamic var CardType = -1
    @objc dynamic var UserId = false
    
}
