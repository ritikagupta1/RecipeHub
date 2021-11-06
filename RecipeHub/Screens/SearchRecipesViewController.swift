//
//  SearchRecipesViewController.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 26/10/21.
//

import UIKit
import TagListView

class SearchRecipesViewController: UIViewController,TagListViewDelegate {
    enum Section {
        case main
    }
    var searchTextField: UITextField!
    let tagListView = TagListView()
    let addButton = UIButton()
    let tagStack = UIStackView()
    var ingredientList:[String] = []
    var collectionview: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,Recipe>!
    let collectionstack = UIStackView()
    var recipes: [Recipe] = []
    var recipeIds:[Int] = []
    var offSet: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchRecipes))
        navigationItem.rightBarButtonItem?.tintColor = .systemOrange
        tagListView.delegate = self
        configureTextField()
        configureAddButton()
        configureTagField()
        configureCollectionView()
        configureDataSource()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(offSet)
    }
    
    @objc func searchRecipes() {
        self.recipes = []
        self.recipeIds = []
        self.offSet = 0
        guard !ingredientList.isEmpty else {
            self.updateData()
            return
        }
        findRecipeIds(ingredientList: ingredientList)
    }
    
    func findRecipeIds(ingredientList: [String]) {
        self.showLoadingView()
        NetworkManager.shared.getRecipeIdsFromIngredients(ingredientList: ingredientList) { result in
            switch result {
            case .success(let ids):
                if ids.isEmpty {
                    print("Empty")
                    DispatchQueue.main.sync {
                        self.dismissLoadingView()
                        self.showAlertonMainThread(alertTitle: "No Recipes Found", message: "Please try another combination of Ingredients", buttonTitle: "Okay")
                        self.updateData()
                    }
                    
                    return
                }
                self.recipeIds = ids
                print(self.recipeIds)
                print(self.recipeIds.count)
                self.getRecipeInformationFromIds()
            case .failure:
                print("Failed")
                
            }
        }
    }
    
    func getRecipeInformationFromIds() {
        let recipeIds = Array(self.recipeIds[offSet ..<  min(offSet+10,recipeIds.count)])
        print(recipeIds)
        
        NetworkManager.shared.getRecipeInformationById(ids: recipeIds, offset: self.offSet) { result in
            switch result {
            case .success(let recipes):
                DispatchQueue.main.sync {
                    self.dismissLoadingView()
                }
                self.recipes += recipes
                print(recipes)
                self.updateData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func configureTextField() {
        searchTextField = UITextField()
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.layer.cornerRadius = 10
        searchTextField.textAlignment = .center
        searchTextField.font = UIFont(name: "Montserrat-Medium", size: 16)
        searchTextField.placeholder = "Enter Ingredients 🥗"
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    func configureAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .systemOrange
        addButton.setTitle("Add", for: .normal)
        addButton.tintColor = .white
        addButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureTagField() {
      
        tagStack.axis = .vertical
        tagListView.textFont = UIFont.systemFont(ofSize: 16)
        tagListView.alignment = .leading // possible values are [.leading, .trailing, .left, .center, .right]
        tagListView.backgroundColor = .systemBackground
        tagListView.cornerRadius = 12
        tagListView.paddingY = 6
        tagListView.paddingX = 20
        tagListView.textColor = .white
        tagListView.borderColor = .black
        tagListView.tagBackgroundColor = .orange
        tagListView.borderWidth = 1
        tagListView.enableRemoveButton = true
        tagListView.removeButtonIconSize = 7
        tagListView.removeIconLineWidth = 2
        tagListView.removeIconLineColor = .black
        tagStack.addArrangedSubview(tagListView)
        view.addSubview(tagStack)
        tagStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagStack.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            tagStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            tagStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        ingredientList.removeAll { $0 == title }
        sender.removeTagView(tagView)
    }
    
    @objc func addIngredient() {
        guard let ingredient = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !ingredient.isEmpty,!ingredientList.contains(ingredient) else {
            return
        }
        tagListView.addTag(ingredient)
        ingredientList.append(ingredient)
        searchTextField.text = ""
    }
    
    func configureCollectionView() {
        collectionstack.axis = .vertical
        collectionstack.translatesAutoresizingMaskIntoConstraints = false
        collectionstack.backgroundColor = .systemBackground
       
        view.addSubview(collectionstack)
        NSLayoutConstraint.activate([
            collectionstack.topAnchor.constraint(equalTo:tagStack.bottomAnchor,constant: 20),
            collectionstack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionstack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionstack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        print(collectionstack.bounds)
        collectionstack.layoutIfNeeded()
        collectionview = UICollectionView(frame: collectionstack.bounds, collectionViewLayout: createCollectionViewFlowLayout())
        collectionstack.distribution = .fill
        collectionview.allowsSelection = true
        collectionview.backgroundColor = .systemBackground
        collectionview.delegate = self
        collectionview.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseId)
        collectionstack.addArrangedSubview(collectionview)
    }
    
    func createCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let width = collectionstack.bounds.width
        let padding: CGFloat = 0
        let availableWidth = width - 2 * padding
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: availableWidth, height: availableWidth)
        return flowLayout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Recipe>(collectionView: self.collectionview, cellProvider: { collectionView, indexPath, recipe in
            let cell = self.collectionview.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseId, for: indexPath) as? RecipeCell
            cell?.setRecipe(recipe: recipe)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Recipe>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.recipes)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
}

extension SearchRecipesViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenSize = scrollView.frame.height
        
        if offsetY > contentHeight - screenSize {
            offSet += 10
            if offSet >= recipeIds.count {
                return
            }
            showLoadingView()
            getRecipeInformationFromIds()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeDetailVC = RecipeDetailsViewController()
        recipeDetailVC.recipe = self.recipes[indexPath.row]
        let navController = UINavigationController(rootViewController: recipeDetailVC)
        present(navController, animated: true)
    }
}

