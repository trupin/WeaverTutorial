//
//  ImageManagerDependencyResolverSpy.swift
//  SampleTests
//
//  Created by Théophane Rupin on 10/16/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation
import XCTest

@testable import Sample

final class ImageManagerDependencyResolverSpy: ImageManagerDependencyResolver {
    
    // MARK: - Spies
    
    var urlSessionSpy = URLSessionSpy()

    // MARK: - Implementation

    var urlSession: URLSessionProtocol {
        return urlSessionSpy
    }
}
