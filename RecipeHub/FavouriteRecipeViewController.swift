//
//  FavouriteRecipeViewController.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 04/11/21.
//

import UIKit

class FavouriteRecipeViewController: UIViewController {
    enum Section {
        case main
    }
    var favouriteRecipes: [Recipe] = []
    var favouriteRecipeIds: [Int] = []
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section,Recipe>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureViewController()
        configureCollectionView()
        configureCollectionViewDatasource()
        getFavouriteRecipeIds()
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("1")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseId)
    }
    
    
    func getFavouriteRecipeIds() {
        PersistenceManager.retrieveFavouriteRecipesIds { result in
            switch result {
            case .success(let favouriteIds):
                self.favouriteRecipeIds = favouriteIds
                if !self.favouriteRecipeIds.isEmpty {
                    self.getRecipeInformationFromIds()
                }
            case .failure(let error):
                print(error)
                break
                
            }
        }
    }
    
    func getRecipeInformationFromIds() {
        print("HERE1")
        //self.showLoadingView()
        NetworkManager.shared.getRecipeInformationById(ids: favouriteRecipeIds, offset: 0) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let recipes):
                //self.dismissLoadingView()
                self.favouriteRecipes = recipes
                self.updateData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
   
    func createCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let availableWidth = width - 2 * padding
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: availableWidth, height: availableWidth)
        return flowLayout
    }
    
    func configureCollectionViewDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section,Recipe>(collectionView: collectionView, cellProvider: { collectionview, indexPath, recipe in
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseId, for: indexPath) as? RecipeCell
            cell?.setRecipe(recipe: recipe)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Recipe>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(self.favouriteRecipes)
        DispatchQueue.main.async {
            self.datasource.apply(snapshot,animatingDifferences: true)
        }
    }

}

extension FavouriteRecipeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeDetailVC = RecipeDetailsViewController()
        recipeDetailVC.recipe = self.favouriteRecipes[indexPath.row]
        recipeDetailVC.delegate = self
        let navController = UINavigationController(rootViewController: recipeDetailVC)
        present(navController, animated: true)
    }
}

extension FavouriteRecipeViewController:FavouriteRecipeChanged  {
    func favouritesChanged() {
        self.getFavouriteRecipeIds()
    }
}

protocol FavouriteRecipeChanged {
    func favouritesChanged()
}
