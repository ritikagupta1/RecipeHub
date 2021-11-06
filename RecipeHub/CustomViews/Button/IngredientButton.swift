//
//  IngredientButton.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 05/11/21.
//

import UIKit
class IngredientButton: UIButton {
    var ingredient: Ingredient!
    
    init(ingredient: Ingredient) {
        super.init(frame: .zero)
        self.ingredient = ingredient
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
