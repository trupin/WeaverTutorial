//
//  URLSessionProtocol.swift
//  Sample
//
//  Created by Théophane Rupin on 10/16/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation

@objc protocol URLSessionProtocol: AnyObject {
    
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: completionHandler)
    }
}
