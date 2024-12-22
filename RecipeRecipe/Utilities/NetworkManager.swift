//
//  NetworkManager.swift
//  RecipeRecipe
//
//  Created by Oliver Hu on 12/17/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    func getAppetizers(completed: @escaping (Result<[Recipe], REError>) -> Void) {
        // check url works
        guard let url = URL(string: baseURL) else {
            completed(.failure(.invalidURL))
            return
        }
        // Create network call with URLRequest based on url
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
                        
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(RecipeResponse.self, from: data)
                completed(.success(decodedResponse.recipes))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
