//
//  IngredientViewController.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 05/11/21.
//

import UIKit

class IngredientViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
   

    var tableView: UITableView!
    var ingredientList: [IngredientViewModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureViewController()
        configureTableView()
        getIngredients()
    }
    
    func getIngredients() {
        PersistenceManager.retrieveShoppingIngredients {  result in
            switch result {
            case .success(let ingredients):
                self.ingredientList = ingredients.map({ IngredientViewModel(ingredient: $0)
                })
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.rowHeight = 120
        tableView.backgroundColor = .systemBackground
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseId) as? IngredientCell else {
            return UITableViewCell()
        }
        cell.setup(with: ingredientList[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let ingredientModel = ingredientList[indexPath.row]
        let ingredient = Ingredient(id: ingredientModel.id, name: ingredientModel.name, image: ingredientModel.image)
        ingredientList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(ingredient: ingredient, actionType: .remove) { error in
            print(error)
        }
     
    }
}
