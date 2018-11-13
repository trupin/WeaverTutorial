//
//  MovieManager.swift
//  Sample
//
//  Created by Théophane Rupin on 9/23/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation

final class MovieManager {
    
    private let dependencies: MovieManagerDependencyResolver
    
    // weaver: urlSession <- URLSessionProtocol
    
    init(injecting dependencies: MovieManagerDependencyResolver) {
        self.dependencies = dependencies
    }
    
    func getDiscoverMovies(_ completion: @escaping (Page<Movie>?) -> Void) {
        
        let completionOnMainThread = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=1a6eb1225335bbb37278527537d28a5d") else {
            completion(nil)
            return
        }
        
        let task = self.dependencies.urlSession.requestData(with: url) { (data, response, error) in
            
            if error != nil {
                completionOnMainThread(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionOnMainThread(nil)
                return
            }
            
            guard response.statusCode == 200 || response.statusCode == 304 else {
                completionOnMainThread(nil)
                return
            }
            
            guard let data = data else {
                completionOnMainThread(nil)
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Page<Movie>.self, from: data)
                completionOnMainThread(model)
            } catch {
                completionOnMainThread(nil)
            }
        }
        
        task.resume()
    }
}
