//
//  LogInViewController.swift
//  RecipeHub
//
//  Created by Mac_Admin on 03/08/21.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var errorLabel = UILabel()
    var logInButton = AuthButton(backgroundColor: .black, title: "Log In")
    var orLabel = UILabel()
    var googleSignInButton = AuthButton(backgroundColor: .black, title: "Sign In using Google")
    var noAccountLabel = UILabel()
    var signUpLabel = UILabel()
    var signUpButtonTapped: (() -> Void)?
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Log In"

        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        configureGradientLayer()
        configureEmailTextField()
        configurePasswordTextField()
        configureErrorLabel()
        configureLogInButton()
        configureorLabel()
        configureGoogleSignInButton()
        configureNoAccountLabel()
        configureSignUpLabel()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "LogIn"
    }
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor,UIColor.orange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func configureEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emailTextField)

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        emailTextField.autocorrectionType = .no
        emailTextField.tintColor = .black
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            emailTextField.widthAnchor.constraint(equalToConstant: 280),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])

        emailTextField.layoutIfNeeded()
        Utilities.styleTextField(emailTextField)
    }
    
    func configurePasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(passwordTextField)

        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tintColor = .black
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])

        passwordTextField.layoutIfNeeded()
        Utilities.styleTextField(passwordTextField)
    }

    func configureErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(errorLabel)

        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0

        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            errorLabel.widthAnchor.constraint(equalToConstant: 280),
            errorLabel.heightAnchor.constraint(equalToConstant: 50),
            errorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    func configureLogInButton() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logInButton)

        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 30),
            logInButton.widthAnchor.constraint(equalToConstant: 280),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    func configureorLabel() {
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(orLabel)

        orLabel.text = "--------------- OR ----------------"

        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 30),
            orLabel.widthAnchor.constraint(equalToConstant: 280),
            orLabel.heightAnchor.constraint(equalToConstant: 50),
            orLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    func configureGoogleSignInButton() {
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(googleSignInButton)
        googleSignInButton.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            googleSignInButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 30),
            googleSignInButton.widthAnchor.constraint(equalToConstant: 280),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            googleSignInButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    @objc func googleSignInButtonTapped() {
        print("TAPPED")
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        print(clientID)
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {  user, error in
            guard error == nil else { return }
            guard let user = user else {
                return
            }
            print("Sucess \(user.authentication.clientID)")
            let homeScreen = MainTabViewController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                  fatalError("could not get scene delegate ")
                }
                sceneDelegate.window?.rootViewController = homeScreen
           
        }
    }
    
    func configureNoAccountLabel() {
        noAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(noAccountLabel)

        noAccountLabel.text = " Don't Have an account? "
        noAccountLabel.textAlignment = .left

        NSLayoutConstraint.activate([
            noAccountLabel.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 30),
            noAccountLabel.heightAnchor.constraint(equalToConstant: 50),
            noAccountLabel.leadingAnchor.constraint(equalTo: googleSignInButton.leadingAnchor),
            noAccountLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    func configureSignUpLabel() {
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(signUpLabel)

        signUpLabel.text = "Sign up"
        signUpLabel.textColor = .white
        signUpLabel.textAlignment = .left
        signUpLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        signUpLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signupButtonTapped))
        signUpLabel.addGestureRecognizer(gestureRecognizer)
        
        NSLayoutConstraint.activate([
            signUpLabel.centerYAnchor.constraint(equalTo: noAccountLabel.centerYAnchor),
            signUpLabel.leadingAnchor.constraint(equalTo: noAccountLabel.trailingAnchor),
        ])
    }
    
    
    
    
    @objc func signupButtonTapped() {
        signUpButtonTapped?()
    }
    
    @objc func logInButtonTapped() {
        if emailTextField.text?.isEmpty ?? false || passwordTextField.text?.isEmpty ?? false {
            errorLabel.text = "Please fill all the fields"
            errorLabel.alpha = 1
        }
        else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email , password: password ) { result, err in
                if err != nil {
                    self.errorLabel.text = "Invalid Username or password"
                    self.errorLabel.alpha = 1
                } else {
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

