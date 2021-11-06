//
//  MainTabViewController.swift
//  RecipeHub
//
//  Created by Mac_Admin on 05/08/21.
//

import UIKit

class MainTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        self.navigationItem.largeTitleDisplayMode = .never
        UITabBar.appearance().tintColor = .systemOrange
        self.viewControllers = [createAllRecipesNavigationController(),createSearchRecipesNavigationController(),createFavouriteRecipeNavigationController(),createIngredientShoppingNavigationController()]
    }
    
    func createAllRecipesNavigationController() -> UINavigationController {
        let allRecipesVC = AllRecipesViewController()
        allRecipesVC.title = "Recipes"
        allRecipesVC.tabBarItem = UITabBarItem(title: "Recipes", image: UIImage(systemName:"book.closed.fill" ), tag: 1)
        return UINavigationController(rootViewController: allRecipesVC)
    }
    
    func createSearchRecipesNavigationController() -> UINavigationController {
        let searchRecipesVC = SearchRecipesViewController()
        searchRecipesVC.title = "Search Recipes"
        searchRecipesVC.tabBarItem = UITabBarItem(title: "Recipes", image: UIImage(systemName:"magnifyingglass.circle" ), tag: 2)
        return UINavigationController(rootViewController: searchRecipesVC)
    }
    
    func createFavouriteRecipeNavigationController() -> UINavigationController {
        let favouriteRecipeVC = FavouriteRecipeViewController()
        favouriteRecipeVC.title = "Favourite recipes"
        favouriteRecipeVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName:"bookmark.fill" ), tag: 3)
        return UINavigationController(rootViewController: favouriteRecipeVC)
    }
    
    func createIngredientShoppingNavigationController() -> UINavigationController {
        let shoppingVC = IngredientViewController()
        shoppingVC.title = "Shopping List"
        shoppingVC.tabBarItem = UITabBarItem(title: "Shopping List", image: UIImage(systemName:"bag.fill" ), tag: 4)
        return UINavigationController(rootViewController: shoppingVC)
    }
    
    
}
