//
//  IngredientViewModel.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 08/11/21.
//

import Foundation
struct IngredientViewModel: Hashable {
    
    var id: Int
    var name: String
    var image: String
    
    var isIngredientInShoppingList: Bool {
        var isIngredientInShoppingList: Bool = false
        PersistenceManager.retrieveShoppingIngredients {  result in
            switch result {
            case .success(let ingredients):
                if ingredients.contains(Ingredient(id: self.id, name: self.name, image: self.image)) {
                   isIngredientInShoppingList = true
                } else {
                   isIngredientInShoppingList = false
                }
            case .failure(let error):
                print(error)
            }
        }
        return isIngredientInShoppingList
    }
    
    init(ingredient: Ingredient) {
        self.id = ingredient.id
        self.name = ingredient.name
        self.image = ingredient.image
    }
    
}
