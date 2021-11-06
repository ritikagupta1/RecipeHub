//
//  RecipeAlertViewController.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 04/11/21.
//

import UIKit

class RecipeAlertViewController: UIViewController {

    let container = UIView()
    let titleLabel = UILabel()
    let msgLabel = UILabel()
    let actionButton = UIButton()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var padding: CGFloat = 20
    
    init(alertTitle: String,message: String,buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configure()
        configureTitleLabel()
        configureActionButtton()
        configureMessageLabel()
    }

    func configure() {
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        container.layer.cornerRadius = 14
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.black.cgColor
        container.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 280),
            container.heightAnchor.constraint(equalToConstant: 220 )
        ])
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = .label
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = alertTitle ?? "Something went wrong"
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButtton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.backgroundColor = .systemOrange
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        container.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureMessageLabel() {
        msgLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
        msgLabel.textAlignment = .center
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.text = message ?? "Unable to process request"
        msgLabel.numberOfLines = 4
        container.addSubview(msgLabel)
        NSLayoutConstraint.activate([
            msgLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            msgLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            msgLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            msgLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
