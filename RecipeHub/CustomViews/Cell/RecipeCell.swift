//
//  RecipeCell.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 26/10/21.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    static var reuseId: String = "RecipeCell"
    
    var recipeImageview = RecipeImageView(frame: .zero)
    var recipeName = UILabel()
    var timeImageView = UIImageView()
    var durationLabel = UILabel()
    var vegeterianImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRecipe(recipe: Recipe) {
        guard let image = recipe.image else {
            print("HAAAAN")
            return
        }
        recipeImageview.downloadImage(from: image)
        recipeName.text = recipe.title
        durationLabel.text = recipe.readyInMinutes.description + " minutes"
        if recipe.vegetarian{
            vegeterianImageView.isHidden = false
        } else {
            vegeterianImageView.isHidden = true
        }
    }
    
    func configure() {
        self.addSubview(recipeImageview)
        self.addSubview(recipeName)
        recipeName.translatesAutoresizingMaskIntoConstraints = false
        recipeName.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        recipeName.numberOfLines = 0
        self.addSubview(timeImageView)
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.image = UIImage(systemName: "clock.fill")
        timeImageView.tintColor = .systemGray4
        self.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.addSubview(vegeterianImageView)
        vegeterianImageView.translatesAutoresizingMaskIntoConstraints = false
        vegeterianImageView.image = UIImage(systemName: "leaf.fill")
        vegeterianImageView.tintColor = .systemGreen
        
        NSLayoutConstraint.activate([
            recipeImageview.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 10),
            recipeImageview.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            recipeImageview.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            recipeImageview.heightAnchor.constraint(equalTo: recipeImageview.widthAnchor,multiplier: 0.7),
            
            recipeName.topAnchor.constraint(equalTo: recipeImageview.bottomAnchor, constant: 10),
            recipeName.leadingAnchor.constraint(equalTo: recipeImageview.leadingAnchor),
            recipeName.trailingAnchor.constraint(equalTo: recipeImageview.trailingAnchor),
            recipeName.heightAnchor.constraint(equalToConstant: 50),
            
            timeImageView.topAnchor.constraint(equalTo: recipeName.bottomAnchor, constant: 6),
            timeImageView.leadingAnchor.constraint(equalTo: recipeImageview.leadingAnchor),
            timeImageView.heightAnchor.constraint(equalToConstant: 20),
            timeImageView.widthAnchor.constraint(equalToConstant: 20),
            
            vegeterianImageView.topAnchor.constraint(equalTo: timeImageView.topAnchor),
            vegeterianImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            vegeterianImageView.heightAnchor.constraint(equalToConstant: 20),
            vegeterianImageView.widthAnchor.constraint(equalToConstant: 30),
            
            durationLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 4),
            durationLabel.trailingAnchor.constraint(equalTo: vegeterianImageView.leadingAnchor, constant: -10),
            durationLabel.heightAnchor.constraint(equalToConstant: 20),
            durationLabel.topAnchor.constraint(equalTo: timeImageView.topAnchor)
        ])
        
    }
    
    
}
