// Code is commented because the facebook and google pods are not installed

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class Social: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {

    static let shared = Social()
    private override init() {}

    private var googleCompletion: ((_ status: Bool, _ message: String, _ data: UserSocialData?) -> Void)?
    private var presentedController: UIViewController?

    func loginWithFacebook(_ fromController: UIViewController, completion: @escaping (_ data: UserSocialData?) -> Void, downloadImage: Bool = false) {
        
        let login = LoginManager()
        login.logIn(permissions: ["public_profile", "email"], from: fromController) { (result, error) in
            if error != nil {
                print("Process error")
            } else if result?.isCancelled ?? false {
                print("Cancelled")
            } else {
                if let token = result?.token {
                    self.getFacebookProfile(token: token, completion: completion, downloadImage: downloadImage)
                }
            }
        }
    }

    func loginWithGoogle(_ fromController: UIViewController, completion: @escaping (_ status: Bool, _ message: String, _ data: UserSocialData?) -> Void, downloadImage: Bool = false) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().clientID = AppConfig.shared.googleClientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        presentedController = fromController
        googleCompletion = completion
        GIDSignIn.sharedInstance().signIn()
    }


    private func getFacebookProfile(token: AccessToken, completion: @escaping (_ data: UserSocialData?) -> Void, downloadImage: Bool = false) {
        
        GraphRequest(graphPath: "/me", parameters: ["fields": "email, name"]).start { (connection, result, error) in
            
            if error != nil {
                NSLog(error.debugDescription)
                return
            }
            
            if let result = result as? [String:String] {
                let userSocialData = UserSocialData.init(fbData: result, loginwith: LoginWith.Facebook, token: token.tokenString)
                if downloadImage {
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                    imageView.kf.setImage(with: URL(string: userSocialData.image), placeholder: #imageLiteral(resourceName: "image_placeholder"), options: nil, progressBlock: { (progress, val) in
                    }, completionHandler: { (image, error, type, url) in
                        userSocialData.userImage = image
                        completion(userSocialData)
                    })
                } else {
                    completion(userSocialData)
                }
            }
            
        }
    }


    // MARK: - Google Sign In Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {

            let userSocialData = UserSocialData()
            userSocialData.name = user.profile.name
            userSocialData.email = user.profile.email
            userSocialData.loginWith = .google
            userSocialData.token = user.authentication.accessToken
            userSocialData.userID = user.userID  //user.authentication.clientID
            
            let dimension = round(100 * UIScreen.main.scale)
            let pic = user.profile.imageURL(withDimension: UInt(dimension))
            userSocialData.image = pic?.absoluteString ?? ""
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            imageView.kf.setImage(with: URL(string: userSocialData.image), placeholder: #imageLiteral(resourceName: "image_placeholder"), options: nil, progressBlock: { (progress, val) in
            }, completionHandler: { (image, error, type, url) in
                userSocialData.userImage = image
                self.googleCompletion?(true, "", userSocialData)
            })
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.googleCompletion?(true, error.localizedDescription, nil)
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        presentedController?.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }

}

class UserSocialData {
    var name = ""
    var email = ""
    var image = ""
    var userID = ""
    var loginWith: LoginWith?
    var token: String?
    var userImage: UIImage?

    init() {}
    init(fbData: [String: Any], loginwith: LoginWith, token: String) {
        self.name = fbData["name"] as? String != nil ? fbData["name"] as! String : ""
        self.email = fbData["email"] as? String != nil ? fbData["email"] as! String : ""
        self.userID = fbData["id"] as? String != nil ? fbData["id"] as! String : ""
        self.image = "http://graph.facebook.com/\(userID)/picture?type=large"
        self.loginWith = loginwith
        self.token = token
    }
    
}

