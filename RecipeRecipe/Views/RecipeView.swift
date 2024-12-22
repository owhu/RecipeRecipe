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
                List(viewModel.recipes, id: \.id) { recipe in
                    RecipeCell(recipe: recipe)
                }
//                .navigationTitle("🥘 Recipes")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image(systemName: "fork.knife")
                                .foregroundColor(.yellow)
                            Text("Recipes")
                                .font(.headline)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.getRecipes()
            }
        }
    }
    
}

#Preview {
    RecipeView()
}
