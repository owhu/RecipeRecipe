//
//  RecipeViewModel.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/18/24.
//

import Foundation

final class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func getRecipes() {
        NetworkManager.shared.getAppetizers { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self.recipes = recipes
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}
