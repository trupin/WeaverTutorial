//
//  ReviewManager.swift
//  Sample
//
//  Created by Théophane Rupin on 9/24/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation

@objc final class ReviewManager: NSObject {
    
    private let dependencies: ReviewManagerDependencyResolver
    
    // weaver: urlSession <- URLSession
    
    required init(injecting dependencies: ReviewManagerDependencyResolver) {
        self.dependencies = dependencies
        super.init()
    }
    
    @objc func getReviews(for movieID: UInt, completion: @escaping (ReviewPage?) -> Void) {
        
        let completionOnMainThread = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/reviews?api_key=1a6eb1225335bbb37278527537d28a5d") else {
            completion(nil)
            return
        }
        
        let task = dependencies.urlSession.dataTask(with: url) { (data, response, error) in
            
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
                let model = try JSONDecoder().decode(Page<Review.Properties>.self, from: data)
                let compatModel = ReviewPage(model)
                completionOnMainThread(compatModel)
            } catch {
                completionOnMainThread(nil)
            }
        }
        
        task.resume()
    }
}
