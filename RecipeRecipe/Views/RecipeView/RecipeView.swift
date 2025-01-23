//
//  ContentView.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/17/24.
//

import SwiftUI

struct RecipeView: View {
    @StateObject var viewModel = RecipeViewModel()

    
    var body: some View {
        ZStack {
            NavigationView {
                if !viewModel.recipes.isEmpty {
                    List(viewModel.recipes, id: \.id) { recipe in
                        RecipeCell(recipe: recipe)
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Image(systemName: "fork.knife")
                                    .foregroundColor(.yellow)
                                Text("Recipes")
                                    .font(.headline)
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Refresh", systemImage: "arrow.clockwise") {
                                viewModel.getRecipes()
                                print("refreshed")
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            .task {
                viewModel.getRecipes()
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
    
}

#Preview {
    RecipeView()
}
