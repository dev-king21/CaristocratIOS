import UIKit
import RESideMenu
//import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Firebase
import FirebaseAnalytics
import UserNotifications
import Alamofire
import SwiftyStoreKit

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
   
}


public func printForced(_ items: Any..., separator: String = " ", terminator: String = "\n") {
   
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("did finish launching")
        FirebaseApp.configure()
        register(application: application)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible();
//        self.refreshToken()
        Fabric.with([Crashlytics.self])
        //self.window?.rootViewController = SplashViewController.instantiate(fromAppStoryboard: .Home)
        UIApplication.shared.applicationIconBadgeNumber = 0

//        IQKeyboardManager.shared.enable = true
        var isUniversalLinkClick: Bool = false
//        if (launchOptions![UIApplicationLaunchOptionsKey.userActivityDictionary] != nil) {
//            let activityDictionary = launchOptions![UIApplicationLaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
//            let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity ?? NSUserActivity()
//            if activity != nil {
//             isUniversalLinkClick = true
//            }
//        }
        

        
        if let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] { //Universal link
            for key in activityDictionary.keys {
                if let userActivity = activityDictionary[key] as? NSUserActivity {
                    
                    if let url = userActivity.webpageURL {
                        AppStateManager.sharedInstance.urlData = ["type" : url.valueOf("type") ?? "","id" : url.valueOf("id") ?? ""]
                    }
                    isUniversalLinkClick = true
                    
                }
            }
        }
        
        if isUniversalLinkClick {
            // app opened via clicking a universal link.
            let _ = AppStateManager.sharedInstance.userData
            loadHomePage()
        } else {
            // set the initial viewcontroller
            self.window?.rootViewController = SplashViewController.instantiate(fromAppStoryboard: .Home)
        }

        //IAP
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = (urlComponents?.queryItems)! as [NSURLQueryItem]
        if (url.scheme == "myapp") {
            var vcTitle = ""
            if let _ = items.first, let propertyName = items.first?.name, let propertyValue = items.first?.value {
                vcTitle = url.query!//"propertyName"
            }
        }
        return false
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    
    
    // MARK: Shortcuts
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        //completionHandler(Deeplinker.handleShortcut(item: shortcutItem))
    }
    
    func setupUX(){
     //  AppStateManager.sharedInstance.isTutorialShown = false
        if AppStateManager.sharedInstance.isTutorialShown {

            if let _ = AppStateManager.sharedInstance.userData {
//                 if userData.user?.details?.is_verified?.value() ?? false {
                   loadHomePage()
//                 } else {
//                   self.presentVerificationController()
            } else {
                presentLoginViewController()
            }
//            self.window?.rootViewController = TutorialViewController.instantiate(fromAppStoryboard: .Login)
        } else {
            self.window?.rootViewController = TutorialViewController.instantiate(fromAppStoryboard: .Login)
        }

    }

    func presentLoginViewController() {
        if let _ = self.window {
            self.window?.rootViewController = AppStoryboard.Login.initialViewController()
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = AppStoryboard.Login.initialViewController()
            self.window?.makeKeyAndVisible();
        }
    }
    
    func presentSignUpViewController() {
        let navigationController = UINavigationController()
        let signInViewController = SignInViewController.instantiate(fromAppStoryboard: .Login)
        signInViewController.redirectToSignup = true
        navigationController.viewControllers = [signInViewController]
        self.window?.rootViewController = navigationController
    }
    
    func loadHomePage(){
//      let navigationController = UINavigationController()
//      let homeController = AppStoryboard.Home.initialViewController()
//      navigationController.viewControllers = [homeController!]
        self.window?.rootViewController = AppStoryboard.Home.initialViewController()
    }
    
    func presentVerificationController() {
        self.window?.rootViewController = PhoneVerificationVC.instantiate(fromAppStoryboard: .Login)
    }
    
    func refreshToken() {
        if let _ = AppStateManager.sharedInstance.userData?.user {
            APIManager.sharedInstance.refreshToken()
        }
    }
    
    // Configuraion of FCM
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox) /*KA*/
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.prod)
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func moveToCarDetail(carId: Int, type: String) {
        let myTradeInDetailController = MyTradeInDetailController.instantiate(fromAppStoryboard: .Login)
        myTradeInDetailController.refId = carId
        myTradeInDetailController.detailType = TradeEvaluateCarType(rawValue: type) ?? .trade
        if let navigationController = Utility().topViewController() as? UINavigationController {
           navigationController.pushViewController(myTradeInDetailController, animated: true)
        } else if let controller = Utility().topViewController() {
          controller.present(myTradeInDetailController, animated: true, completion: nil)
        } else {
            AppStateManager.sharedInstance.refId = carId
        }
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // For Deep Linking
        print("Continue User Activity called: ")
        
        if let vc = Utility().topViewController() as? SignInViewController {
            let _ = AppStateManager.sharedInstance.userData
            loadHomePage()
        }
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.getLinkType(slug: url.lastPathComponent)
            }
            
            
            
            
            
          /*  if let type = url.valueOf("type"), let id = url.valueOf("id") {
                
                if type == "10" {
                    
                    if let vc = Utility().topViewController() as? VehicleDetailController {
                        vc.navigationController?.popViewController(animated: false)
                        let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
                        vehicleController.carId = Int(id)
                        vehicleController.slug = "luxury-new-cars"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            Utility().topViewController()?.navigationController?.pushViewController(vehicleController, animated: false)
                        }
                        
                    }else{
                        let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
                        vehicleController.carId = Int(id)
                        vehicleController.slug = "luxury-new-cars"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            Utility().topViewController()?.navigationController?.pushViewController(vehicleController, animated: true)
                        }
                    }

                    
                } else {
                    if let vc = Utility().topViewController() as? FurtherDetailVC {
                        
                        vc.navigationController?.popViewController(animated: false)
                        let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
                        furtherDetailVC.newsId = Int(id) ?? -1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            Utility().topViewController()?.navigationController?.pushViewController(furtherDetailVC, animated: false)
                        }
                        
                    }else{
                        let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
                        furtherDetailVC.newsId = Int(id) ?? -1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            Utility().topViewController()?.navigationController?.pushViewController(furtherDetailVC, animated: true)
                        }
                    }
                    
                }
            }*/
            print(url.absoluteString)
            //handle url and open whatever page you want to open.
        }
        return true
    }
    
    func getLinkType(slug:String) {
        APIManager.sharedInstance.getDeepLinkType(Slug: slug, success: { (result) in
            
            if result.type == 10 {
                
                if let vc = Utility().topViewController() as? VehicleDetailController {
                    vc.navigationController?.popViewController(animated: false)
                    let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
                    vehicleController.carId = result.id ?? -1
                    vehicleController.slug = "luxury-new-cars"
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        Utility().topViewController()?.navigationController?.pushViewController(vehicleController, animated: false)
                    //}
                    
                }else{
                    let vehicleController = VehicleDetailController.instantiate(fromAppStoryboard: .LuxuryMarket)
                    vehicleController.carId = result.id ?? -1
                    vehicleController.slug = "luxury-new-cars"
                   // DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        Utility().topViewController()?.navigationController?.pushViewController(vehicleController, animated: true)
                    //}
                }
                
                
            } else {
                if let vc = Utility().topViewController() as? FurtherDetailVC {
                    
                    vc.navigationController?.popViewController(animated: false)
                    let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
                    furtherDetailVC.newsId = result.id ?? -1
                   // DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        Utility().topViewController()?.navigationController?.pushViewController(furtherDetailVC, animated: false)
                   // }
                    
                }else{
                    let furtherDetailVC = FurtherDetailVC.instantiate(fromAppStoryboard: .Home)
                    furtherDetailVC.newsId = result.id ?? -1
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        Utility().topViewController()?.navigationController?.pushViewController(furtherDetailVC, animated: true)
                    //}
                }
                
            }
            
        }, failure: { (error) in
            
        })
    }
   
}

extension AppDelegate {
    
    func register(application: UIApplication) {
        //        if AppStateManager.sharedInstance.deviceToken.isEmpty {
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        //        }
    }
}
 
 extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive UNUserNotificationCenterDelegate")
        print("Remote Message : \(response.description)")
        if let carId = response.notification.request.content.userInfo["ref"] as? NSString, let type = response.notification.request.content.userInfo["type"] as? String  {
            self.moveToCarDetail(carId: Int(carId.intValue), type: type)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
        print("willPresent")
    }
 }

 extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Device Token: \(fcmToken)")
        AppStateManager.sharedInstance.deviceToken = fcmToken
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Remote Message : \(remoteMessage.description)")
    }
 }
