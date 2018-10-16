//
//  URLSessionProtocol.swift
//  Sample
//
//  Created by Théophane Rupin on 10/16/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation

protocol URLSessionProtocol: AnyObject {
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
