//
//  IngredientCell.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 06/11/21.
//

import UIKit

class IngredientCell: UITableViewCell {

    var ingredientName = UILabel()
    var ingredientImage = RecipeImageView(frame: .zero)
    static let reuseId = "IngredientCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with ingredient: Ingredient) {
        ingredientName.text = ingredient.name
        let downloadUrl = "https://spoonacular.com/cdn/ingredients_100x100/" + ingredient.image
        ingredientImage.downloadImage(from: downloadUrl)
    }
    
    func configure() {
        ingredientImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ingredientImage)
        
        ingredientName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ingredientName)
        ingredientName.font = UIFont(name: "Montserrat-Medium", size: 16)
        
        NSLayoutConstraint.activate([
            ingredientImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            ingredientImage.widthAnchor.constraint(equalToConstant: 100),
            ingredientImage.heightAnchor.constraint(equalToConstant: 100),
            ingredientImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            ingredientName.leadingAnchor.constraint(equalTo: ingredientImage.trailingAnchor, constant: 10),
            ingredientName.centerYAnchor.constraint(equalTo: ingredientImage.centerYAnchor),
            ingredientName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ingredientName.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

}
