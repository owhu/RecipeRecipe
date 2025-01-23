//
//  EmptyView.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 1/14/25.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack {
            Image("food-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .frame(width: 120, height: 90)
            Text("Recipe list is empty")
        }
    }
}

#Preview {
    EmptyView()
}
