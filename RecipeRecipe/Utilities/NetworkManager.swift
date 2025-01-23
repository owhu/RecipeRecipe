//
//  NetworkManager.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/17/24.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    internal let cache = NSCache<NSString, UIImage>()
    
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    var session: URLSession = .shared

    
    func getRecipes() async throws -> [Recipe] {
        // check url works
        guard let url = URL(string: baseURL) else {
            throw REError.invalidURL
        }
        // Create network call with URLRequest based on url
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(RecipeResponse.self, from: data).recipes
        } catch {
            throw REError.invalidData
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        // Check the cache first
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Validate the URL
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            // Perform the data download
            let (data, _) = try await session.data(from: url)
            
            // Convert the data to an image
            if let image = UIImage(data: data) {
                // Cache the image
                cache.setObject(image, forKey: cacheKey)
                return image
            }
        } catch {
            print("Failed to download image: \(error.localizedDescription)")
        }
        
        return nil
    }
}
