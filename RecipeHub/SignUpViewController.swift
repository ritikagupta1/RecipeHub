//
//  SignUpViewController.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 09/10/21.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var confirmPasswordTextField = UITextField()
    var errorLabel = UILabel()
    var signInButton = AuthButton(backgroundColor: .black, title: "Sign In")
    var existingUserLabel = UILabel()
    var logInLabel = UILabel()
    var logInButtonTapped: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create an account"
        
        configureGradientLayer()
        configureEmailTextField()
        configurePasswordTextField()
        configureConfirmPasswordTextField()
        configureErrorLabel()
        configureSignInButton()
        configureExistingUserlabel()
        configureLogInLabel()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLayoutSubviews() {
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(confirmPasswordTextField)
    }
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor,UIColor.orange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradient)
    }
    
    func configureEmailTextField() {
        self.view.addSubview(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.tintColor = .black
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            emailTextField.widthAnchor.constraint(equalToConstant: 280),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configurePasswordTextField() {
        self.view.addSubview(passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.tintColor = .black
        passwordTextField.isSecureTextEntry = true
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configureConfirmPasswordTextField() {
        self.view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.tintColor = .black
        confirmPasswordTextField.isSecureTextEntry = true
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 280),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configureErrorLabel() {
        self.view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            errorLabel.widthAnchor.constraint(equalToConstant: 280),
            errorLabel.heightAnchor.constraint(equalToConstant: 70),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configureSignInButton() {
        self.view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            signInButton.widthAnchor.constraint(equalToConstant: 280),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configureExistingUserlabel() {
        self.view.addSubview(existingUserLabel)
        existingUserLabel.translatesAutoresizingMaskIntoConstraints = false
        existingUserLabel.text = "Already have an account? "
        NSLayoutConstraint.activate([
            existingUserLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30),
            existingUserLabel.heightAnchor.constraint(equalToConstant: 50),
            existingUserLabel.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
        ])
    }
    
    func configureLogInLabel() {
        self.view.addSubview(logInLabel)
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        logInLabel.text = "Log in here"
        logInLabel.textColor = .white
        logInLabel.textAlignment = .left
        logInLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        logInLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginButtonTapped))
        logInLabel.addGestureRecognizer(gestureRecognizer)
        
        NSLayoutConstraint.activate([
            logInLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30),
            logInLabel.widthAnchor.constraint(equalToConstant: 150),
            logInLabel.heightAnchor.constraint(equalToConstant: 50),
            logInLabel.leadingAnchor.constraint(equalTo: existingUserLabel.trailingAnchor),
        ])
    }
    
    @objc func loginButtonTapped() {
        logInButtonTapped?()
    }
    
    @objc func signInButtonTapped() {
        // verify if the email and password are correct and password and confirm password match
        // empty check
        if emailTextField.text?.isEmpty ?? false || passwordTextField.text?.isEmpty ?? false || confirmPasswordTextField.text?.isEmpty ?? false{
            // one or more fields is empty
            errorLabel.text = "Please fill in all the fields"
            errorLabel.alpha = 1
        } else if !Utilities.isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") {
            // invalid email
            errorLabel.text = "Invalid Email.Please enter a proper email"
            errorLabel.alpha = 1
        } else if !Utilities.isPasswordValid(passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") {
            // invalid password
            errorLabel.text = "Please make sure your password is atleast 8 characters,contains a special character and a number."
            errorLabel.alpha = 1
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            // password and confirm password donot match
            errorLabel.text = "Password and Confirm Password donot match"
            errorLabel.alpha = 1
        } else {
            // create user in firebase
            Auth.auth().createUser(withEmail: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { [self] result, error in
                if error != nil {
                    // There was an error creating the user
                    self.errorLabel.text = "Error creating user"
                    self.errorLabel.alpha = 1
                } else {
                    // sucessful creation of user
                    /* Steps: 1. Call the connect user API to create an user in spoonacular end and receive the "username" and "hash".
                     2.Save the "username" and "hash" in firebase data store so that I can use it other API calls" */
                    let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    NetworkManager.shared.createSpoonacularUser(email: email) { result in
                        switch result {
                        case .failure(_):
                            errorLabel.text = "Error Creating user"
                            errorLabel.alpha = 1
                        case .success(let user):
                            let defaults = UserDefaults.standard
                            defaults.setValue(user, forKey: "userDetails" )
                        }
                    }
                    let homeScreen = MainTabViewController()
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                          fatalError("could not get scene delegate ")
                        }
                        sceneDelegate.window?.rootViewController = homeScreen
                        
                }
            }
        }
    }
    
}
