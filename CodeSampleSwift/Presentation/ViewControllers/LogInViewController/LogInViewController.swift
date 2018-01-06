//
//  LogInViewController.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore

class LogInViewController: BaseViewController {
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Actions
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        authWithFacebook()
    }
}

//MARK: Private
extension LogInViewController {
    fileprivate func showRecomendationsViewController() {
        let vc = StoryboardHelper.main.storyboard.instantiateViewController(withIdentifier: "RecNavigationViewController")
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: API part
extension LogInViewController {
    fileprivate func authWithFacebook() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil) {
                if let permission = result?.grantedPermissions, permission.contains("email") {
                    let loginRequest = LoginRequest(facebookID: result?.token.userID, facebookToken: result?.token.tokenString)
                    self.login(request: loginRequest)
                }
            } else {
                let alert = AlertMessage(title: "Oops!", message: error?.localizedDescription)
                AlertHelper.showMessage(message: alert, controller: self)
            }
        }
    }
    
    fileprivate func login(request: LoginRequest) {
        UserService.loginUser(requestModel: request, success: {
            self.showRecomendationsViewController()
        }) { (error) in
            AlertHelper.showMessage(message: error, controller: self)
        }
    }
}
