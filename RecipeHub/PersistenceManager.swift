//
//  PersistenceManager.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 05/11/21.
//

import Foundation
enum PersistenceActionType {
    case add, remove
}


enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
        static let shopping = "shopping"
    }
    
    static func updateWith(favouriteId: Int,action: PersistenceActionType,completed: @escaping (RecipeError?) -> Void ) {
        retrieveFavouriteRecipesIds { result in
            switch result {
            case .success(let favouriteIds):
                var retrievedFavoriteIds = favouriteIds
                switch action{
                case .add:
                    guard !retrievedFavoriteIds.contains(favouriteId) else {
                        completed(.recipeFetchingError)
                        return
                    }
                    retrievedFavoriteIds.append(favouriteId)
                case .remove:
                    retrievedFavoriteIds.removeAll { $0 == favouriteId
                    }
                
                }
                saveFavouriteRecipeIds(favouriteRecipeIds: retrievedFavoriteIds)
            case .failure(let error):
                completed(error)
            }
        }
    }
  
    
    
    static func retrieveFavouriteRecipesIds(completed: @escaping (Result<[Int],RecipeError>)-> Void) {
        guard let favoritesRecipeIds = defaults.array(forKey: Keys.favorites) as? [Int] else{
            completed(.success([]))
            return
        }
        completed(.success(favoritesRecipeIds))
    }
    
    
    static func saveFavouriteRecipeIds(favouriteRecipeIds: [Int]) {
        defaults.set(favouriteRecipeIds,forKey: Keys.favorites)
        print(favouriteRecipeIds)
    }
    
    
    static func updateWith(ingredient: Ingredient,actionType: PersistenceActionType,completed: @escaping(RecipeError?)-> Void) {
        retrieveShoppingIngredients { result in
            switch result {
            case .success(let ingredients):
                var retrievedIngredients = ingredients
                switch  actionType {
                case .add:
                    guard  !retrievedIngredients.contains(ingredient) else {
                        completed(.ingredientSavingError)
                        return
                    }
                    retrievedIngredients.append(ingredient)
                case .remove:
                    retrievedIngredients.removeAll { $0.id == ingredient.id }
                }
               completed(saveIngredients(ingredients: retrievedIngredients))
            case .failure(_):
                completed(.ingredientSavingError)
            }
        }
    }
    
    
    
    static func retrieveShoppingIngredients(completed: @escaping(Result<[Ingredient],RecipeError>) -> Void) {
        
        guard let ingredientsData = defaults.object(forKey:Keys.shopping) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let ingredients = try decoder.decode([Ingredient].self, from: ingredientsData)
            completed(.success(ingredients))
            
        } catch {
            completed(.failure(.ingredientSavingError))
        }
    }
    
    static func saveIngredients(ingredients: [Ingredient]) -> RecipeError? {
        print(ingredients)
        do {
            let encoder = JSONEncoder()
            let encodedIngredients = try encoder.encode(ingredients)
            defaults.set(encodedIngredients,forKey: Keys.shopping)
            return nil
        } catch {
            return .ingredientSavingError
        }
    }
    
}
