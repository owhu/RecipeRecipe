//
//  ContentView.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/17/24.
//

import SwiftUI

struct RecipeView: View {
    @StateObject var viewModel = RecipeViewModel()
    @State private var isLoading = false

    
    var body: some View {
        ZStack {
            NavigationView {
                if !viewModel.recipes.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.recipes, id: \.id) { recipe in
                                RecipeCell(recipe: recipe)
                            }
                        }
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
                            Button {
                                Task {
                                    isLoading = true
                                    try await Task.sleep(for: .seconds(1))
                                    viewModel.getRecipes()
                                    isLoading = false
                                }
                            } label: {
                                Label("Refresh", systemImage: "arrow.clockwise")
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
            .overlay {
                if isLoading {
                    LoadingView()
                }
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
