//
//  RecipeViewModel.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 07/11/21.
//

import Foundation
struct RecipeViewModel: Hashable {
    
    var id:Int
    var title: String
    var readyInMinutes: Int
    var image: String?
    var servings: Int
    var vegetarian: Bool
    var cuisines: [String]
    var dishTypes: [String]
    var analyzedInstructions: [Instruction]
    
    
    var isRecipeFavourite: Bool {
        get {
            var isFavourite: Bool = false
            PersistenceManager.retrieveFavouriteRecipesIds { result in
                   switch result {
                   case .success(let favouritesId):
                       if favouritesId.contains(self.id) {
                          isFavourite = true
                       } else {
                          isFavourite = false
                       }
                   case .failure(let error):
                       print(error)
                   }
            }
            return isFavourite
        }
        set{
            print(newValue)
            if newValue {
                PersistenceManager.updateWith(favouriteId: self.id, action: .add) { error in
                    
                }
            } else {
                PersistenceManager.updateWith(favouriteId: self.id, action: .remove) { error in
                   
                }
            }
           
        }
       
    }
    
    var durationLabel: String
    var servingsLabel: String
    
    var ingredients: [Ingredient] {
        var ingredients: [Ingredient] = []
        for instructions in self.analyzedInstructions {
            for step in instructions.steps {
                for ingredient in step.ingredients {
                    if !ingredients.contains(ingredient) {
                       ingredients.append(ingredient)
                    }
                }
                
            }
        }
        return ingredients
    }
    
    var ingredientsViewModel:[IngredientViewModel] {
        return ingredients.map { IngredientViewModel(ingredient: $0) }
    }
    
    var equipments: [Equipment] {
        var equipments: [Equipment] = []
        for instructions in self.analyzedInstructions {
            for step in instructions.steps {
                for equipment in step.equipment {
                    if !equipments.contains(equipment) {
                        equipments.append(equipment)
                    }
                }
                
            }
        }
        return equipments
    }
    
    
    init(recipe: Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.readyInMinutes = recipe.readyInMinutes
        self.image = recipe.image
        self.vegetarian = recipe.vegetarian
        self.servings = recipe.servings
        self.cuisines = recipe.cuisines
        self.dishTypes = recipe.dishTypes
        self.analyzedInstructions = recipe.analyzedInstructions
        self.durationLabel = recipe.readyInMinutes.description + " minutes"
        self.servingsLabel =  recipe.servings.description + " servings"
    }
    
}
