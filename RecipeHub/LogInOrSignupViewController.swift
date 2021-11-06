//
//  LogInOrSignupViewController.swift
//  RecipeHub
//
//  Created by Mac_Admin on 14/08/21.
//

import UIKit

class LogInOrSignupViewController: UIViewController {
    
    var isLoginControler: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isLoginControler! {
            renderLogInViewController()
        } else {
            renderSignUpViewController()
        }
    }

    func renderSignUpViewController() {
        title = "Create an account"

        let signInVC = SignUpViewController()
        add(signInVC)

        signInVC.logInButtonTapped = {
            signInVC.remove()
            self.renderLogInViewController()
        }
    }
    
    func renderLogInViewController() {
        title = "Log In"

        let loginVC = SignInViewController()
        add(loginVC)

        loginVC.signUpButtonTapped = {
            loginVC.remove()
            self.renderSignUpViewController()
        }
    }
}
