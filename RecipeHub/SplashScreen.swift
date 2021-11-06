//
//  ViewController.swift
//  RecipeHub
//
//  Created by Mac_Admin on 02/08/21.
//

import UIKit
import AVKit

class SplashScreen: UIViewController {
    
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let signInButton = AuthButton(backgroundColor: .black , title: "Sign Up")
    let logInButton = AuthButton(backgroundColor: .black , title: "Log In")
    
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var videoPlayerlayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleLabel()
        configureLogInButton()
        configureSignInButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        //navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    func setUpVideo() {
        let path = Bundle.main.path(forResource: "recipehubvideo", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        
        let asset: AVAsset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        
        // Create a new player looper with the queue player and template item
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        videoPlayerlayer = AVPlayerLayer(player: queuePlayer)
        videoPlayerlayer?.frame = CGRect(x: -self.view.frame.size.width * 0.4 , y: -40, width: self.view.frame.size.width * 3.5 , height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerlayer, at: 0)
        // add and play it
        queuePlayer.playImmediately(atRate: 0.2)
    }
    
    func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Cochin-Italic", size: 60)
        titleLabel.text = "Recipe Hub"
        titleLabel.textColor = .white
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    
    func configureLogoImageView() {
        self.view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "recipehubLogo")
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        logoImageView.layer.cornerRadius = 90
        logoImageView.clipsToBounds = true
    }
    
    func configureLogInButton() {
        self.view.addSubview(logInButton)
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.widthAnchor.constraint(equalToConstant: 280),
            logInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configureSignInButton() {
        self.view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalToConstant: 280),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    @objc func signInButtonTapped() {
        let logInOrSignUpViewController = LogInOrSignupViewController()
        logInOrSignUpViewController.isLoginControler = false
        self.navigationController?.pushViewController(logInOrSignUpViewController, animated: true)
    }
    
    @objc func logInButtonTapped() {
        let logInOrSignUpViewController = LogInOrSignupViewController()
        logInOrSignUpViewController.isLoginControler = true
        self.navigationController?.pushViewController(logInOrSignUpViewController, animated: true)
    }
    
}

