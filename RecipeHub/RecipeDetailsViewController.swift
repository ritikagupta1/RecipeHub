//
//  RecipeDetailsViewController.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 31/10/21.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    var recipe: Recipe!
    let scrollView = UIScrollView()
    let contentView = UIView()
    var isFavourite: Bool = false
    var delegate: FavouriteRecipeChanged?
    
    ///Outlets
    var recipeImageView = RecipeImageView(frame: .zero)
    var timeImageView = UIImageView()
    var durationLabel = UILabel()
    var vegeterianImageView = UIImageView()
    var bookmarkButton = UIButton()
    var servingsImageView = UIImageView()
    var servings = UILabel()
    let verticalStack = UIStackView()
    
    var ingredients: [Ingredient] = []
    var equipments: [Equipment] = []
    var shoppingList: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = recipe.title
        setupScrollView()
        checkIfRecipeisfavourite()
        findShoppingIngredients()
        configure()
        set(recipe: self.recipe)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func findShoppingIngredients() {
        PersistenceManager.retrieveShoppingIngredients(completed: { result in
            switch result {
            case .success(let shoppingList):
                self.shoppingList = shoppingList
            case .failure(let error):
                print(error)
            }
        })
    }
   
    func checkIfRecipeisfavourite() {
     PersistenceManager.retrieveFavouriteRecipesIds { result in
            switch result {
            case .success(let favouritesId):
                if favouritesId.contains(self.recipe.id) {
                    self.isFavourite = true
                } else {
                    self.isFavourite = false
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    func setupScrollView(){
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        }
    
    func set(recipe: Recipe) {
        guard let image = recipe.image else {
            print("HAAAAN")
            return
        }
        recipeImageView.downloadImage(from: image)
        durationLabel.text = recipe.readyInMinutes.description + " minutes"
        servings.text = recipe.servings.description + " servings"
    }
    
    func configure() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(timeImageView)
        contentView.addSubview(durationLabel)
        contentView.addSubview(vegeterianImageView)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(servingsImageView)
        contentView.addSubview(servings)
        contentView.addSubview(verticalStack)
      
        
        
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.image = UIImage(systemName: "clock.fill")
        timeImageView.tintColor = .darkGray
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
        
        vegeterianImageView.translatesAutoresizingMaskIntoConstraints = false
        vegeterianImageView.image = UIImage(systemName: "leaf.fill")
        vegeterianImageView.tintColor = .systemGreen
        
        
       
        
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        if isFavourite {
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        bookmarkButton.tintColor = .black
        bookmarkButton.addTarget(self, action: #selector(bookMarkButtonTapped), for: .touchUpInside)
        servingsImageView.translatesAutoresizingMaskIntoConstraints = false
        servingsImageView.image = UIImage(systemName: "person.2.fill")
        servingsImageView.tintColor = .darkGray
        
        servings.translatesAutoresizingMaskIntoConstraints = false
        servings.font = UIFont(name: "Montserrat-Medium", size: 16)
        
        
        verticalStack.axis = .vertical
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.spacing = 20
        
       
        
        
        let dishTypeStackView = UIStackView()
        dishTypeStackView.axis = .horizontal
        dishTypeStackView.alignment = .top
        dishTypeStackView.distribution = .fillEqually
        
        let dishTypeLabel = UILabel()
        dishTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        dishTypeLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        dishTypeLabel.text = "DishType:"
        
        let dishesStack = UIStackView()
        dishesStack.axis = .vertical
        
        for dishType in recipe.dishTypes {
            let dishLabel = UILabel()
            dishLabel.font = UIFont(name: "Montserrat-medium", size: 16)
            dishLabel.text = dishType
            dishesStack.addArrangedSubview(dishLabel)
        }
        
        dishTypeStackView.addArrangedSubview(dishTypeLabel)
        dishTypeStackView.addArrangedSubview(dishesStack)
        
        
        
        if !recipe.dishTypes.isEmpty {
            verticalStack.addArrangedSubview(dishTypeStackView)
        }
        
        let cuisineTypeStackView = UIStackView()
        cuisineTypeStackView.axis = .horizontal
        cuisineTypeStackView.alignment = .top
        cuisineTypeStackView.distribution = .fillEqually
        
        let cuisineTypeLabel = UILabel()
        cuisineTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        cuisineTypeLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        cuisineTypeLabel.text = "Cuisine:"
        
        let cuisinesStack = UIStackView()
        cuisinesStack.axis = .vertical
        
        for cuisine in recipe.cuisines {
            let cuisineLabel = UILabel()
            cuisineLabel.font = UIFont(name: "Montserrat-medium", size: 16)
            cuisineLabel.text = cuisine
            cuisinesStack.addArrangedSubview(cuisineLabel)
        }
        
        cuisineTypeStackView.addArrangedSubview(cuisineTypeLabel)
        cuisineTypeStackView.addArrangedSubview(cuisinesStack)
        
        
        
        if !recipe.cuisines.isEmpty {
            verticalStack.addArrangedSubview(cuisineTypeStackView)
        }
        
        for instructions in recipe.analyzedInstructions {
            for step in instructions.steps {
                for ingredient in step.ingredients {
                    if !self.ingredients.contains(ingredient) {
                        self.ingredients.append(ingredient)
                    }
                }
                
            }
        }
        
        let totalIngredientStackView =  UIStackView()
        totalIngredientStackView.axis = .vertical
        totalIngredientStackView.spacing = 15
        totalIngredientStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let ingredientStackLabel = UILabel()
        ingredientStackLabel.text = "Ingredients:"
        ingredientStackLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        ingredientStackLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let ingredientListStackView = UIStackView()
        ingredientListStackView.axis = .vertical
        ingredientListStackView.spacing = 15
        ingredientListStackView.translatesAutoresizingMaskIntoConstraints = false
        
      
        
        for ingredient in self.ingredients {
            let ingredientView = UIStackView()
            ingredientView.axis = .horizontal
            ingredientView.alignment = .center
            ingredientView.spacing = 20
            
            let checkBoxButton = IngredientButton(ingredient: ingredient)
            print("*******************")
            print(self.shoppingList)
            print("*******************")
            if shoppingList.contains(ingredient) {
                checkBoxButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                checkBoxButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            }
            
            checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
            checkBoxButton.tintColor = .black
            checkBoxButton.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
            
            
            let ingredientImageView = RecipeImageView(frame: .zero)
            let downloadUrl = "https://spoonacular.com/cdn/ingredients_100x100/" + ingredient.image
            ingredientImageView.downloadImage(from: downloadUrl)
            ingredientImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let ingredientName = UILabel()
            ingredientName.text = ingredient.name
            ingredientName.translatesAutoresizingMaskIntoConstraints = false
            ingredientName.font =  UIFont(name: "Montserrat-Medium", size: 16)
            ingredientName.numberOfLines = 0

            NSLayoutConstraint.activate([
                checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
                checkBoxButton.heightAnchor.constraint(equalToConstant: 20),
                ingredientImageView.heightAnchor.constraint(equalToConstant: 100),
                ingredientImageView.widthAnchor.constraint(equalToConstant: 100),
                ingredientName.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            ingredientView.addArrangedSubview(checkBoxButton)
            ingredientView.addArrangedSubview(ingredientImageView)
            ingredientView.addArrangedSubview(ingredientName)
            
            ingredientListStackView.addArrangedSubview(ingredientView)
        
        }
        
        if !ingredients.isEmpty{
            totalIngredientStackView.addArrangedSubview(ingredientStackLabel)
            totalIngredientStackView.addArrangedSubview(ingredientListStackView)
            verticalStack.addArrangedSubview(totalIngredientStackView)
        }
        
        
        for instructions in recipe.analyzedInstructions {
            for step in instructions.steps {
                for equipment in step.equipment {
                    if !self.equipments.contains(equipment) {
                        self.equipments.append(equipment)
                    }
                }
                
            }
        }
        
        let totalEquipmentStackView = UIStackView()
        totalEquipmentStackView.axis = .vertical
        totalEquipmentStackView.spacing = 15
        totalEquipmentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let equipmentStackLabel = UILabel()
        equipmentStackLabel.text = "Equipments:"
        equipmentStackLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        equipmentStackLabel.translatesAutoresizingMaskIntoConstraints = false
        
        for equipment in self.equipments {
            let equipmentView = UIStackView()
            equipmentView.axis = .horizontal
            equipmentView.alignment = .center
            equipmentView.spacing = 20
            
            let equipmentImageView = RecipeImageView(frame: .zero)
            let downloadUrl = "https://spoonacular.com/cdn/equipment_100x100/" + equipment.image
            equipmentImageView.downloadImage(from: downloadUrl)
            equipmentImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let equipmentName = UILabel()
            equipmentName.text = equipment.name
            equipmentName.translatesAutoresizingMaskIntoConstraints = false
            equipmentName.font =  UIFont(name: "Montserrat-Medium", size: 16)
            equipmentName.numberOfLines = 0

            NSLayoutConstraint.activate([
                equipmentImageView.heightAnchor.constraint(equalToConstant: 100),
                equipmentImageView.widthAnchor.constraint(equalToConstant: 100),
                equipmentName.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            equipmentView.addArrangedSubview(equipmentImageView)
            equipmentView.addArrangedSubview(equipmentName)
            totalEquipmentStackView.addArrangedSubview(equipmentView)
        }
        
        if !self.equipments.isEmpty {
            verticalStack.addArrangedSubview(equipmentStackLabel)
            verticalStack.addArrangedSubview(totalEquipmentStackView)
        }
        
        
        let totalInstructionsStackView = UIStackView()
        totalInstructionsStackView.axis = .vertical
        totalInstructionsStackView.spacing = 10
        
        let instructionStackLabel = UILabel()
        instructionStackLabel.text = "Instructions:"
        instructionStackLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        instructionStackLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let InstructionsStackView = UIStackView()
        InstructionsStackView.axis = .vertical
        InstructionsStackView.spacing = 10
        if  !recipe.analyzedInstructions.isEmpty &&  !recipe.analyzedInstructions[0].steps.isEmpty{
            let steps: [Step] = recipe.analyzedInstructions[0].steps.sorted(by: { $0.number < $1.number
            })
            
            for step in steps {
                let instructionLabel = UILabel()
                instructionLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
                instructionLabel.translatesAutoresizingMaskIntoConstraints = false
                instructionLabel.text = step.number.description + ". " + step.step
                instructionLabel.numberOfLines = 0
                
                InstructionsStackView.addArrangedSubview(instructionLabel)
            }
            totalInstructionsStackView.addArrangedSubview(instructionStackLabel)
            totalInstructionsStackView.addArrangedSubview(InstructionsStackView)
            
          
                verticalStack.addArrangedSubview(totalInstructionsStackView)
            
        }
        
        
        NSLayoutConstraint.activate([
            
            recipeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 10),
            recipeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:  20),
            recipeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -20),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor,multiplier: 0.7),
        
          
            timeImageView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10),
            timeImageView.widthAnchor.constraint(equalToConstant: 20),
            timeImageView.heightAnchor.constraint(equalToConstant: 25),
            timeImageView.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor),
            
            
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 20),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 20),
            bookmarkButton.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor,constant: 10),
            
            vegeterianImageView.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -50),
            vegeterianImageView.widthAnchor.constraint(equalToConstant: 30),
            vegeterianImageView.heightAnchor.constraint(equalToConstant: 20),
            vegeterianImageView.topAnchor.constraint(equalTo: bookmarkButton.topAnchor),
            
            durationLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 8),
            durationLabel.trailingAnchor.constraint(equalTo: vegeterianImageView.leadingAnchor, constant: -10),
            durationLabel.heightAnchor.constraint(equalToConstant: 20),
            durationLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor),
            
            servingsImageView.topAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: 10),
            servingsImageView.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor),
            servingsImageView.heightAnchor.constraint(equalToConstant: 20),
            servingsImageView.widthAnchor.constraint(equalToConstant: 30),
            
            servings.leadingAnchor.constraint(equalTo: servingsImageView.trailingAnchor, constant: 5),
            servings.topAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: 10),
            servings.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            servings.heightAnchor.constraint(equalToConstant: 20),
            
            
          
            verticalStack.topAnchor.constraint(equalTo: servings.bottomAnchor,constant: 20),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
            
        ])
        
       
        
    }
    
    @objc func checkBoxButtonTapped(sender: IngredientButton) {
        print(sender.ingredient)
        if shoppingList.contains(sender.ingredient) {
            PersistenceManager.updateWith(ingredient: sender.ingredient, actionType: .remove) { error in
                print(error)
            }
            sender.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        }else {
            PersistenceManager.updateWith(ingredient: sender.ingredient, actionType: .add) { error in
                print(error)
            }
            sender.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.favouritesChanged()
    }
    
    @objc func bookMarkButtonTapped(sender: UIButton) {
        isFavourite.toggle()
        print(isFavourite)
        if isFavourite {
            
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            PersistenceManager.updateWith(favouriteId: recipe.id, action: .add) { error in
                print(error)
            }
        }

        else {
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            PersistenceManager.updateWith(favouriteId: recipe.id, action: .remove) { error in
                print(error)
            }
        }
    }
    
}
