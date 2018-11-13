//
//  ImageManager.swift
//  Sample
//
//  Created by Théophane Rupin on 9/24/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation
import UIKit

final class ImageManager {
    
    // weaver: urlSession <- URLSessionProtocol
    
    private let dependencies: ImageManagerDependencyResolver
    
    required init(injecting dependencies: ImageManagerDependencyResolver) {
        self.dependencies = dependencies
    }
    
    func getImage(with path: String, completion: @escaping (UIImage?) -> Void) {
        
        let completionOnMainThread = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w1280/\(path)") else {
            completion(nil)
            return
        }
        
        let task = dependencies.urlSession.requestData(with: url) { (data, response, error) in
            
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
            
            completionOnMainThread(UIImage(data: data))
        }
        
        task.resume()
    }
}
