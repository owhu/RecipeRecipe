//
//  Recipe.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/17/24.
//

import Foundation


struct Recipe: Identifiable, Decodable {
    let id: String
    let name: String
    let cuisine: String
    let photo_url_small: String
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photo_url_small
    }
}

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}

struct MockData {
    
    static let recipes = [sampleRecipe, sampleRecipe, sampleRecipe]
    
    static let sampleRecipe = Recipe(id: "0000002",
                                           name: "Blackened Shrimp",
                                           cuisine: "Asian Cuisine",
                                           photo_url_small: "https://seanallen-course-backend.herokuapp.com/images/appetizers/blackened-shrimp.jpg")
}
