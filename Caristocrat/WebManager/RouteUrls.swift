enum Route: String {
    
    case Register = "register"
    case Login = "login"
    case ForgotPassword = "forget-password"
    case GetCategories = "categories"
    //case News = "news"
    case News = "newsV2"
    
    case Comments = "comments"
    case NewsInteractions = "newsInteractions"
    case NewsDetail = "news/"
    
    case NewsDetailBySlug = "showNewsBySlug/"
    
    case DeepLinkType = "getType/"
    
    case Refresh = "refresh"
    case ChangePassword = "change-password"
    case VerifyResetCode = "verify-reset-code"
    case ResetPassword = "reset-password"
    case Logout = "logout"
    case UpdateProfile = "update-profile"
    case FavoriteNews = "favorite-news"
    case SocialLogin = "social-login"
    case Countries = "regions"
    case ReviewFields = "reviewAspects"
    case Reviews = "reviews"
    case SaveRegions = "users-regions"
    case GetVehicles = "makeBids"
    
    case GetVehiclesV2 = "makeBidsV2"
    
    case GetVehiclesBySlug = "showBySlug"
    
    case GetBrands = "carBrands"
    case GetEngineTypes = "engineTypes"
    case GetCarModels = "carModels"
    case GetRegionalSpecs = "regionalSpecifications"
    case GetCarAttribute = "carAttributes"
    case MyCars = "myCars"
    case ContactUs = "contactus"
    case ReportListing = "reportRequests"
    case GetBodyStyles = "carTypes"
    case CarInteractions = "carInteractions"
    case Notifications = "notifications"
    case UpdateNotification = "update-push-notification"
    case BanksRates = "banksRates"
    case TradeInCars = "tradeInCars"
    case Settings = "settings"
    case carVersion = "carVersions"
    case pages = "pages"
    case tutorial = "walkThroughs"
    
    case deleteComment = "deletecomment"
    case updateComment = "updatecomment"

    case checkReportPayment = "checkreportPayment"
    case onereportPayment = "onereportPayment"
    case allreportPayment = "allreportPayment"

    case getProComparisonAmount = "getProComparisonAmount"
    case chechkprocomparisonsubs = "checkprocomparisonsubsAnd"
    case procomparisonsubs = "procomparisonsubs"

    case getSubscriptions = "getSubscriptionsDotNet"

    func url() -> String {
      return Constants.BaseURL + self.rawValue
    }
}
