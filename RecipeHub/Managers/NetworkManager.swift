//
//  NetworkManager.swift
//  RecipeHub
//
//  Created by Mac_Admin on 05/08/21.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    private let apikey = "90c75f55f32f4359a9616888ae48584e"
    private let baseURL = "https://api.spoonacular.com/"
    private init() { }
    
    func createSpoonacularUser(email: String,completed: @escaping(Result<[String:String],LoginError>)-> Void) {
        
        let urlString = baseURL + "users/connect?apiKey=\(apikey)"
        guard let url = URL(string: urlString) else {
            completed(.failure(.LoginNotPossible))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let user = User(email: email)
        urlRequest.httpBody = try? JSONEncoder().encode(user)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200, let jsondata = data else {
                completed(.failure(.invalidUserNamePassword))
                return
            }
            do {
                // get username and hash
                var finalResult :[String: String] = [:]
                let responseJSON = try JSONSerialization.jsonObject(with: jsondata, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    finalResult["hash"] = responseJSON["hash"] as? String
                    finalResult["username"] = responseJSON["username"] as? String
                }
                
                completed(.success(finalResult))
            } catch {
                completed(.failure(.LoginNotPossible))
            }
            
        }
        
        dataTask.resume()
    }
    

    func getAllRecipes(offset: Int, completed: @escaping(Result<[Recipe],RecipeError>) -> Void) {
            let endPoint = baseURL + "/recipes/complexSearch?addRecipeInformation=true&offset=\(offset)&number=10&apiKey=\(apikey)&instructionsRequired=true"
            
            guard let url = URL(string: endPoint) else {
                completed(.failure(.recipeFetchingError))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    completed(.failure(.recipeFetchingError) )
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.recipeFetchingError))
                    return
                }
                guard let data = data else {
                    completed(.failure(.recipeFetchingError))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let allRecipes = try decoder.decode(AllRecipes.self, from: data)
                    let recipes = allRecipes.results
                    completed(.success(recipes))
                } catch {
                    print("Here \(error)")
                    completed(.failure(.recipeFetchingError))
                }
            }
           
            task.resume()
    }
    
    func getRecipeContainingTitle(title: String,completed:@escaping(Result<[Recipe],RecipeError>) -> Void){
        let endPoint = baseURL +
            "/recipes/complexSearch?addRecipeInformation=true&number=100&apiKey=\(apikey)&instructionsRequired=true&titleMatch=\(title)"
            
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.recipeFetchingError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.recipeFetchingError) )
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.recipeFetchingError))
                return
            }
            guard let data = data else {
                completed(.failure(.recipeFetchingError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let allRecipes = try decoder.decode(AllRecipes.self, from: data)
                let recipes = allRecipes.results
                completed(.success(recipes))
            } catch {
                print("Here \(error)")
                completed(.failure(.recipeFetchingError))
            }
        }
       
        task.resume()
    }
    
    
    
    func getRecipeIdsFromIngredients(ingredientList: [String],completed:@escaping (Result<[Int],RecipeError>)-> Void) {
        
        let ingredientList = ingredientList.joined(separator: ",")
        let endpoint = baseURL + "recipes/findByIngredients?ingredients=\(ingredientList)&number=100&limitLicense=true&ranking=1&apiKey=\(apikey)"
        
        guard  let url = URL(string: endpoint) else {
            completed(.failure(.recipeFetchingError))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.recipeFetchingError) )
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.recipeFetchingError))
                return
            }
            guard let data = data else {
                completed(.failure(.recipeFetchingError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let allRecipesByID = try decoder.decode([RecipeById].self, from: data)
                var recipeId: [Int] = []
                for recipe in allRecipesByID {
                    recipeId.append(recipe.id)
                }
                completed(.success(recipeId))
            } catch {
                print("Here \(error)")
                completed(.failure(.recipeFetchingError))
            }
        }
       
        task.resume()
    }
    
    func getRecipeInformationById(ids: [Int],offset: Int,completed: @escaping(Result<[Recipe],RecipeError>)-> Void) {
        
        let stringIds: [String] = ids.map { String($0) }
        let recipeIds = stringIds.joined(separator: ",")
        
        let endpoint = baseURL + "/recipes/informationBulk?ids=\(recipeIds)&includeNutrition=false&apiKey=\(apikey)&offSet=\(offset)&number=10&instructionsRequired=true&addRecipeInformation=true"
        
        guard  let url = URL(string: endpoint) else {
            completed(.failure(.recipeFetchingError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.recipeFetchingError) )
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.recipeFetchingError))
                return
            }
            guard let data = data else {
                completed(.failure(.recipeFetchingError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recipes = try decoder.decode([Recipe].self, from: data)
                completed(.success(recipes))
            } catch {
                print("Here \(error)")
                completed(.failure(.recipeFetchingError))
            }
        }
        
        task.resume()
    }
}

enum LoginError: String, Error {
    case LoginNotPossible = "Login was not possible because of some error"
    case invalidUserNamePassword = "Inavlid Username or passsword"
}
enum RecipeError: String, Error {
    case recipeFetchingError = "Error fetching Recipes"
    case recipeFavouritingError = "Error saving Recipe to favourites"
    case ingredientSavingError = "Error saving Ingredient"
}
