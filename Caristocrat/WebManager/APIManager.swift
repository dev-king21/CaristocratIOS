
import UIKit

typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void
typealias DefaultArrayResultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void

protocol APIErrorHandler {
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromERror(error:NSError)
}

class APIManager: APIManagerBase {
   
    static let sharedInstance = APIManager()
    
    func performSignUp<T : Codable>(params: Parameters,
        success:@escaping (T) -> Void,
        responseType:T.Type,
        failure:@escaping DefaultAPIFailureClosure,
        showLoader: Bool = true) {
        
        let route: URL = POSTURLforRoute(route: Route.Register.rawValue)!
        
        var parameters = params
        parameters.updateValue(Constants.PLATFORM, forKey: Params.deviceType.rawValue)
        parameters.updateValue(AppStateManager.sharedInstance.deviceToken, forKey: Params.deviceToken.rawValue)
       // parameters.updateValue("this_is_temporary", forKey: Params.deviceToken.rawValue)

        self.postRequestWith(route: route, parameters: parameters, success: success,responseType: responseType, failure: failure, errorPopup: true,showLoader: showLoader)
    }
    
    func performSignIn<T : Codable>(params: Parameters,
                                    success:@escaping (T) -> Void,
                                    responseType:T.Type,
                                    failure:@escaping DefaultAPIFailureClosure,
                                    showLoader: Bool = true) {
        
        let route: URL = POSTURLforRoute(route: Route.Login.rawValue)!
        
        var parameters = params
        parameters.updateValue(Constants.PLATFORM, forKey: Params.deviceType.rawValue)
        parameters.updateValue(AppStateManager.sharedInstance.deviceToken, forKey: Params.deviceToken.rawValue)
        //parameters.updateValue("this_is_temporary", forKey: Params.deviceToken.rawValue)
        
        self.postRequestWith(route: route, parameters: parameters, success: success,responseType: responseType, failure: failure, errorPopup: true,showLoader: showLoader)
    }
    
    func socialLogin(regionId: Int,
                    userSocialData: UserSocialData,
                                    success:@escaping (UserBaseModel) -> Void,
                                    failure:@escaping (Error) -> Void) {
        
//        let route: URL = POSTURLforRoute(route: Route.SocialLogin.rawValue)!
        
        var parameters: Parameters = [:]
        parameters.updateValue(userSocialData.name, forKey: "username")
        parameters.updateValue(userSocialData.email, forKey: "email")
//      parameters.updateValue(userSocialData.image, forKey: "image")
        parameters.updateValue(userSocialData.token ?? "" , forKey: "token")
        parameters.updateValue(userSocialData.userID , forKey: "client_id")
        parameters.updateValue(userSocialData.loginWith?.rawValue ?? "", forKey: "platform")
        parameters.updateValue(Constants.PLATFORM, forKey: Params.deviceType.rawValue)
        parameters.updateValue(AppStateManager.sharedInstance.deviceToken, forKey: Params.deviceToken.rawValue)


        requestPOSTWithSingleImage(Constants.BaseURL + Route.SocialLogin.rawValue, parameters: parameters, dataImage: ["key":"image", "value": userSocialData.userImage ?? UIImage()], headers: [:], success: success, responseType: UserBaseModel.self, failure: failure)
//        self.postRequestWith(route: route, parameters: parameters, success: success,responseType: responseType, failure: failure, errorPopup: true,showLoader: showLoader)
    }
    
    func updateProfile(params: Parameters,
                       images: [String : Any],
                       success:@escaping (UserBaseModel) -> Void,
                       failure:@escaping (Error) -> Void,
                       showLoader: Bool = true) {

        requestPOSTWithSingleImage(Constants.BaseURL + Route.UpdateProfile.rawValue, parameters: params, dataImage: images, headers: [:], success: success, responseType: UserBaseModel.self, failure: failure )
        
        
        //        self.postRequestWith(route: route, parameters: params, success: success,responseType: UserBaseModel.self, failure: failure, errorPopup: true,showLoader: showLoader)
    }
    
    func forgotPassword(parameters: Parameters,
                        onResponse:@escaping (Bool) -> Void) {
        
        let route: URL = GETURLfor(route: Route.ForgotPassword.rawValue)!
        
        self.getRequestWith(route: route, parameters: parameters, onResponse: onResponse)
    }
    
    func getCategories(showLoader:Bool = true,success:@escaping ([CategoryModel]) -> Void,
                       failure:@escaping DefaultAPIFailureClosure)  {
        
        let route: URL = GETURLfor(route: Route.GetCategories.rawValue)!
        
        self.getRequestWith(route: route, parameters: ["parent_id":0], success: success, responseType: [CategoryModel].self, failure: failure, errorPopup: true,showLoader:showLoader)
    }
    
    func getNews(categoryId: Int,
                 success:@escaping ([NewsModel]) -> Void,
                 showLoader: Bool = true,
                 failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.News.rawValue)!
        
        self.getRequestWith(route: route, parameters: ["category_id": categoryId], success: success, responseType: [NewsModel].self, failure: failure, errorPopup: true,showLoader: showLoader)
        
    }
    
    func getNewsWithPagination(categoryId: Int,limit:Int = 0,offset:Int = 0,
                 success:@escaping ([NewsModel]) -> Void,
                 showLoader: Bool = true,
                 failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.News.rawValue)!
        
        self.getRequestWithPagination(route: route, parameters: ["category_id": categoryId,"limit":limit,"offset":offset], success: success, responseType: [NewsModel].self, failure: failure, errorPopup: true,showLoader: showLoader)
        
    }
    
    func getComments(newsId: Int,
                     success:@escaping ([CommentsModel]) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.Comments.rawValue)!
        self.getRequestWith(route: route, parameters: ["news_id": newsId], success: success, responseType: [CommentsModel].self, failure: failure, errorPopup: true)
    }
    
    func postComment(newsId: Int,
                     commentText: String,
                     success:@escaping (CommentsModel) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let params: [String: Any] = ["parent_id": 0,
                      "news_id": newsId,
                      "comment_text": commentText]
        
        let route: URL = POSTURLforRoute(route: Route.Comments.rawValue)!
        self.postRequestWith(route: route, parameters: params, success: success, responseType: CommentsModel.self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    func putComment( id:Int,
                     parent_id:Int,
                     newsId: Int,
                     commentText: String,
                     success:@escaping (CommentsModel) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let params: [String: Any] = ["parent_id": parent_id,
                                     "news_id": newsId,
                                     "comment_text": commentText
                                     ]
        
        let route: URL = POSTURLforRoute(route: Route.updateComment.rawValue + "/\(id)")!
       // let route: URL = POSTURLforRoute(route: Route.updateComment.rawValue)!
        self.postRequestWith(route: route, parameters: params, success: success, responseType: CommentsModel.self, failure: failure, errorPopup: true, showLoader: true)
       //  self.putRequestWith(route: route, parameters: params, success: success, responseType: CommentsModel.self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    func deleteComment(id:Int,
                     success:@escaping (DefaultAPISuccessClosure),
                     failure:@escaping DefaultAPIFailureClosure) {
        
        let params: [String: Any] = [:]
        
        let route: URL = POSTURLforRoute(route: Route.deleteComment.rawValue + "/\(id)")!
        self.deleteRequestForDictWith(route: route, parameters: params, success: success, failure: failure, errorPopup: true)
    }
    
    func newsInteraction(newsId: Int,
                         interactionType: InteractionType,
                         success:@escaping (Bool) -> Void,
                         failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = POSTURLforRoute(route: Route.NewsInteractions.rawValue)!
        let params: [String : Any] = ["type": interactionType.rawValue,

                                      "news_id": newsId]
        self.postRequestWith(route: route, parameters: params, success: success,responseType:  Bool.self, failure: failure, errorPopup: true,showLoader: false)
    }
    
    func getNewsDetail(newsId: Int,
                       success:@escaping (NewsModel) -> Void,
                       failure:@escaping DefaultAPIFailureClosure,
                       showLoader: Bool = true) {
        
        var route: URL = GETURLfor(route: Route.NewsDetail.rawValue)!
        route.appendPathComponent(newsId.description)
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: NewsModel.self, failure: failure, errorPopup: true, showLoader: showLoader)
    }
    
    func refreshToken() {
//        let route: URL = POSTURLforRoute(route: Route.Refresh.rawValue)!
//        self.postRequestWith(route: route, parameters: [:], success: { (DefaultResponse) -> Void in
//
//        },responseType:  DefaultResponse.self, failure: { (NSError) -> Void in }, errorPopup: true,showLoader: false)
    }
    
    func changePassword(params: Parameters,
                     success:@escaping (DefaultResponse) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {
        
//        let params: [String: Any] = ["old_password": oldPassword,
//                                     "new_password": newPassword,
//                                     "password_confirmation": confirmPassword]
        
        let route: URL = POSTURLforRoute(route: Route.ChangePassword.rawValue)!
        self.postRequestWith(route: route, parameters: params, success: success, responseType: DefaultResponse.self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    func verifyCode(verificationCode: Int,
                    forVerification:Bool,
                    email: String?,
                    success:@escaping (UserBaseModel) -> Void,
                    failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = POSTURLforRoute(route: Route.VerifyResetCode.rawValue)!
        var params: [String:Any] = ["verification_code":verificationCode]
        if forVerification{
            params["email"] = email
        }
        self.postRequestWith(route: route, parameters: params, success: success,responseType:  UserBaseModel.self, failure: failure, errorPopup: true,showLoader: true)
    }
    
    func resetPassword(email: String,
                       verificationCode: Int,
                       params: Parameters,
                       success:@escaping (DefaultResponse) -> Void,
                       failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = POSTURLforRoute(route: Route.ResetPassword.rawValue)!
        
        var parameters = params
        parameters.updateValue(verificationCode, forKey: "verification_code")
        parameters.updateValue(email, forKey: "email")
       
        self.postRequestWith(route: route, parameters: parameters, success: success,responseType:  DefaultResponse.self, failure: failure, errorPopup: true,showLoader: true)
    }
    
    func logout(onResponse:@escaping (Bool) -> Void) {
        
        let route: URL = POSTURLforRoute(route: Route.Logout.rawValue)!
        
        self.postRequestWith(route: route, parameters: [:], onResponse: onResponse)
    }
    
    func getFavoriteNews(success:@escaping ([NewsFavoriteModel]) -> Void,
                         failure:@escaping DefaultAPIFailureClosure) {
       let route: URL = GETURLfor(route: Route.FavoriteNews.rawValue)!
        self.getRequestWith(route: route, parameters: ["category_id": 0], success: success, responseType: [NewsFavoriteModel].self, failure: failure, errorPopup: true)
    }
    
    func getNotifications(success:@escaping ([NotificationModel]) -> Void,
                         failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.Notifications.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [NotificationModel].self, failure: failure, errorPopup: true)
    }
    
    func updateNotificationSetting(enable: Bool,
                       success:@escaping (DefaultResponse) -> Void,
                       failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = POSTURLforRoute(route: Route.UpdateNotification.rawValue)!
        
        let isOn = enable ? 1:0
        
        let parameters = ["push_notification" : isOn]
        
        self.postRequestWith(route: route, parameters: parameters, success: success, responseType:  DefaultResponse.self, failure: failure, errorPopup: true,showLoader: true)
    }
    
    func getBanksRates(success:@escaping ([BankRateModel]) -> Void,
                         failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.BanksRates.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [BankRateModel].self, failure: failure, errorPopup: true)
    }
    
    func getSettings(success:@escaping ([SettingsModel]) -> Void,
                       failure:@escaping DefaultAPIFailureClosure) {
        let route: URL = GETURLfor(route: Route.Settings.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [SettingsModel].self, failure: failure, errorPopup: true)
    }
    
    func getPages(success:@escaping ([PagesModel]) -> Void,
                     failure:@escaping DefaultAPIFailureClosure) {

        let route: URL = GETURLfor(route: Route.pages.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [PagesModel].self, failure: failure, errorPopup: true)
    
    }
    
    func getTutorialData(success:@escaping ([TutorialData]) -> Void,
                  failure:@escaping DefaultAPIFailureClosure) {
        
        let route: URL = GETURLfor(route: Route.tutorial.rawValue)!
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [TutorialData].self, failure: failure, errorPopup: true)
        
    }
    
    func getDeepLinkType(Slug: String,
                       success:@escaping (DeepLinkTypeModel) -> Void,
                       failure:@escaping DefaultAPIFailureClosure,
                       showLoader: Bool = true) {
        
        var route: URL = GETURLfor(route: Route.DeepLinkType.rawValue)!
        route.appendPathComponent(Slug)
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: DeepLinkTypeModel.self, failure: failure, errorPopup: true, showLoader: showLoader)
    }
    
    
    //Reports
    func checkReportPayment(userId: String, reportId: String, success: @escaping ([ReportPaymentCheckModel]) -> Void,
                            failure:@escaping DefaultAPIFailureClosure, showLoader: Bool = false) {

        let route: URL = GETURLfor(route: Route.checkReportPayment.rawValue)!
        
        let params = [
            "user_id" : userId,
            "report_id" : reportId
        ]
        
        self.getRequestWith(route: route, parameters: params, success: success, responseType: [ReportPaymentCheckModel].self, failure: failure, errorPopup: true, showLoader: showLoader)
    }
    
    
    
    func subscribeForSingleReport(reportId: String, userId: String, toDate: String, txnId: String, success:@escaping (ReportPaymentModel) -> Void,
                                  failure:@escaping DefaultAPIFailureClosure, showLoader: Bool = true) {
        
        let params: [String: Any] = ["user_id": userId,
                                     "news_id": reportId,
                                     "to_date": toDate,
                                     "transaction_id": txnId]
        
        let route: URL = GETURLfor(route: Route.onereportPayment.rawValue, parameters: params)!

        self.getRequestWith(route: route, parameters: params, success: success, responseType: ReportPaymentModel.self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    
    
    func subscribeForMultipleReport(userId: String, toDate: String, txnId: String, success:@escaping (ReportPaymentModel) -> Void,
                                    failure:@escaping DefaultAPIFailureClosure, showLoader: Bool = true) {
        
        let params: [String: Any] = ["user_id": userId,
                                     "to_date": toDate,
                                     "transaction_id": txnId]
        
        let route: URL = GETURLfor(route: Route.allreportPayment.rawValue, parameters: params)!
        
        self.getRequestWith(route: route, parameters: params, success: success, responseType: ReportPaymentModel.self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    //Comparison
    func subscribeForComparision(userId: String, toDate: String, txnId: String, success:@escaping (ReportPaymentModel) -> Void,
                                  failure:@escaping DefaultAPIFailureClosure, showLoader: Bool = true) {
        
        let params: [String: Any] = ["user_id": userId,
                                     "to_date": toDate,
                                     "transaction_id": txnId]
        
        let route: URL = GETURLfor(route: Route.procomparisonsubs.rawValue, parameters: params)!
        
        self.getRequestWith(route: route, parameters: params, success: success, responseType: ReportPaymentModel.self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    func checkComparisionSubscription(userId: String, success:@escaping ([ComparisionPaymentCheckModel]) -> Void,
                                 failure:@escaping DefaultAPIFailureClosure, showLoader: Bool = true) {
        
        let routeString = Route.chechkprocomparisonsubs.rawValue + "/" + userId
        let route = GETURLfor(route: routeString)!
        
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [ComparisionPaymentCheckModel].self, failure: failure, errorPopup: true, showLoader: true)
    }
    
    //All Subscriptions
    func fetchAllSubscription(userId: String, success:@escaping ([AllSubscriptionsModel]) -> Void,
                                      failure:@escaping DefaultAPIFailureClosure, showLoader: Bool = true) {
        
        let routeString = Route.getSubscriptions.rawValue + "/" + userId
        let route = GETURLfor(route: routeString)!
        
        self.getRequestWith(route: route, parameters: [:], success: success, responseType: [AllSubscriptionsModel].self, failure: failure, errorPopup: true, showLoader: true)
    }
}



