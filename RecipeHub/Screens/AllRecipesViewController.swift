//
//  AllRecipesViewController.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 26/10/21.
//

import UIKit

class AllRecipesViewController: UIViewController {

    enum Section {
        case main
    }
    var recipeViewModels: [RecipeViewModel] = []
    var filteredRecipeModels: [RecipeViewModel] = []
    var offSet: Int = 0
    var hasMoreRecipes: Bool = true
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,RecipeViewModel>!
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getAllRecipes()
        configureDataSource()
        configureSearchController()
        print(offSet)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.allowsSelection = true
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseId)
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
    
    func getAllRecipes() {
        let loadingView = showLoadingView()
        NetworkManager.shared.getAllRecipes(offset: offSet) { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.sync {
                loadingView.removeFromSuperview()
            }
            switch result {
            case .success(let recipes):
                if recipes.count < 10 {
                    self.hasMoreRecipes = false
                }
                self.recipeViewModels += recipes.map({ RecipeViewModel(recipe: $0)
                })
                
                self.updateData(recipeViewModels: self.recipeViewModels)
                self.offSet += 10
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,RecipeViewModel>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, recipe in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseId, for: indexPath) as? RecipeCell
            cell?.setRecipe(recipeViewModel: recipe)
            return cell
        })
    }
   
    func updateData(recipeViewModels: [RecipeViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,RecipeViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(recipeViewModels)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search a Recipe"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }

}

extension AllRecipesViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenSize = scrollView.frame.height
        
        if offsetY > contentHeight - screenSize {
            guard  hasMoreRecipes && !isSearching else {
                return
            }
            getAllRecipes()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeDetailVC = RecipeDetailsViewController()
        recipeDetailVC.recipe = isSearching ? self.filteredRecipeModels[indexPath.row] :  self.recipeViewModels[indexPath.row]
        let navController = UINavigationController(rootViewController: recipeDetailVC)
        present(navController, animated: true)
    }
}
extension AllRecipesViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let title = searchBar.text, !title.isEmpty else {
            return
        }
        let loadingView = showLoadingView()
        isSearching = true
        print(title)
        NetworkManager.shared.getRecipeContainingTitle(title: title) { result in
            switch result {
            case .success(let filteredrecipes):
                DispatchQueue.main.sync {
                    loadingView.removeFromSuperview()
                    self.filteredRecipeModels = filteredrecipes.map({ RecipeViewModel(recipe: $0)
                    })
                    self.updateData(recipeViewModels: self.filteredRecipeModels)
                }


            case .failure(let error):
                print(error)

            }

        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        isSearching = false
        updateData(recipeViewModels: self.recipeViewModels)
    }
    
}
