//
//  URLSessionSpy.swift
//  SampleTests
//
//  Created by Théophane Rupin on 10/16/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation
import XCTest

@testable import Sample

final class URLSessionSpy: URLSessionProtocol {

    // MARK: - Records
    
    private(set) var urlRecords = [URL]()
    
    // MARK: - Stubs
    
    var resultStubs = [URL: (data: Data?, response: URLResponse?, error: Error?)]()
    
    // MARK: - Implementation

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        urlRecords.append(url)
        guard let result = resultStubs[url] else {
            XCTFail("Expected a result stub for url: '\(url.absoluteString)'")
            return URLSessionDataTask()
        }
        completionHandler(result.data, result.response, result.error)
        return URLSessionDataTask()
    }
}
