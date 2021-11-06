//
//  Recipe.swift
//  RecipeHub
//
//  Created by Mac_Admin on 15/08/21.
//

import Foundation
struct Recipe: Codable,Hashable {
    var uuid = UUID()
    var id:Int
    var title: String
    var readyInMinutes: Int
    var image: String?
    var servings: Int
    var vegetarian: Bool
    var cuisines: [String]
    var dishTypes: [String]
    var analyzedInstructions: [Instruction]
    
    private enum CodingKeys : String, CodingKey { case id,title,readyInMinutes,image,vegetarian,cuisines,dishTypes,servings,analyzedInstructions}
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
