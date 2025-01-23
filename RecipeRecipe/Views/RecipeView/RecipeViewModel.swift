//
//  RecipeViewModel.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/18/24.
//

import Foundation

@MainActor final class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var alertItem: AlertItem?
    
    func getRecipes() {
        Task {
            do {
                recipes = try await NetworkManager.shared.getRecipes()
            } catch {
                if let reError = error as? REError {
                    switch reError {
                    case .invalidURL:
                        alertItem = AlertContext.invalidURL
                    case .unableToComplete:
                        alertItem = AlertContext.unableToComplete
                    case .invalidResponse:
                        alertItem = AlertContext.invalidResponse
                    case .invalidData:
                        alertItem = AlertContext.invalidData
                    }
                } else {
                    alertItem = AlertContext.generalError
                }
            }
        }
    }
}
