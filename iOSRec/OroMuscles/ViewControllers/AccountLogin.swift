//
//  AccountLogin.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/18/23.
//

import UIKit
import Auth0
import JWTDecode

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


class AccountLogin: UIViewController {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SessionInfo = OroMuscles.SessionInfo()
        LoginBTN((Any).self)
    }
    
    
    @IBAction func LoginBTN(_ sender: Any) {
        Task { @MainActor in
                await LogUserIn()
           }
    }
    
    func LogUserIn() async {
        Auth0
            .webAuth()
            .audience("https://oro-muscles-webportal.ew.r.appspot.com")
            .scope("openid profile email read:current_user read:athlete")
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                    //save the user Information
                    guard let jwt = try? decode(jwt: credentials.idToken),
                          let emailaddress = jwt["email"].string,
                          let name = jwt["name"].string ,
                          let sub = jwt["sub"].string else { return }
                    self.SessionInfo?.currentUser.UserEmail = emailaddress
                    self.SessionInfo?.currentUser.UserName = name
                    self.SessionInfo?.currentUser.UserID = sub
                    self.SessionInfo?.currentUser.UserAuthorization = credentials.tokenType
                    self.SessionInfo?.currentUser.UserToken = credentials.accessToken
                    self.SessionInfo?.getUserData()
                    //Segue into the app
                    self.NavigationSelector = "QuickStart"
                    self.performSegue(withIdentifier: "PN", sender: self)
                    
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
    
    
    ////////////////////////////////////////////////////
    //////Segue
    ////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PN" {
            let CVC = segue.destination as! ProjectNavigationController
            CVC.SessionInfo = (self.SessionInfo)!
            CVC.NavigationSelector = self.NavigationSelector
        }
    }
}
