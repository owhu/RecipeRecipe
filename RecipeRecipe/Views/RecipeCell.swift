//
//  RecipeCell.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/17/24.
//

import SwiftUI

struct RecipeCell: View {
    
    let recipe: Recipe
    
    var body: some View {
        HStack {
            Rectangle()
            // AppetizerRemoteImage(urlString: appetizer.imageURL)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .frame(width: 120, height: 90)
                

            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(recipe.cuisine)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
            .padding(.leading)
        }
    }
}

#Preview {
    RecipeCell(recipe: MockData.sampleRecipe)
}
