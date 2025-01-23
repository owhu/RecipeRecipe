//
//  RecipeRemoteImageView.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 1/13/25.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    func load(fromURL url: String) async {
        if let uiImage = await NetworkManager.shared.downloadImage(from: url) {
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}


struct RemoteImage: View {
    
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image("food-placeholder").resizable()
    }
}


struct RecipeRemoteImageView: View {
    
    @StateObject private var imageLoader = ImageLoader()
    var urlString: String
    
    var body: some View {
        RemoteImage(image: imageLoader.image)
            .task { await imageLoader.load(fromURL: urlString) }
    }
}


//#Preview {
//    RecipeRemoteImageView()
//}
