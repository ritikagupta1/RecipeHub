//
//  Step.swift
//  RecipeHub
//
//  Created by Ritika Gupta on 31/10/21.
//

import Foundation
struct Step: Codable,Hashable {
    var number: Int
    var step: String
    var ingredients: [Ingredient]
    var equipment: [Equipment]
}
