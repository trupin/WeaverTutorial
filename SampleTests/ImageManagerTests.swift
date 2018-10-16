//
//  ImageManagerTests.swift
//  SampleTests
//
//  Created by Théophane Rupin on 10/16/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation
import XCTest
import UIKit

@testable import Sample

final class ImageManagerTests: XCTestCase {

    private var spies: ImageManagerDependencyResolverSpy!
    
    private var imageManager: ImageManager!
    
    override func setUp() {
        super.setUp()
        
        spies = ImageManagerDependencyResolverSpy()
        imageManager = ImageManager(injecting: spies)
    }
    
    override func tearDown() {
        defer { super.tearDown() }
        
        spies = nil
        imageManager = nil
    }
    
    // MARK: - getImage(with:completion:)
    
    func test_getImage_should_request_an_image_and_complete_with_an_image() {
        
        let expectedImageData = UIImage(data:
            UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { rendererContext in
                rendererContext.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            }.pngData()!
        )?.pngData()!
        
        let url = URL(string: "https://image.tmdb.org/t/p/w1280/fake_path")!
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        spies.urlSessionSpy.resultStubs = [
           url: (expectedImageData, response, nil)
        ]
        
        let expectation = self.expectation(description: "image")
        
        imageManager.getImage(with: "fake_path") { image in
            XCTAssertEqual(self.spies.urlSessionSpy.urlRecords.count, 1)
            XCTAssertEqual(self.spies.urlSessionSpy.urlRecords.first?.absoluteString, "https://image.tmdb.org/t/p/w1280/fake_path")
            XCTAssertNotNil(image?.pngData())
            XCTAssertEqual(image?.pngData(), expectedImageData)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
    
    func test_getImage_should_request_an_image_and_complete_with_nil_when_a_server_error_occurs() {
        
        let url = URL(string: "https://image.tmdb.org/t/p/w1280/fake_path")!
        
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        spies.urlSessionSpy.resultStubs = [
            url: (nil, response, nil)
        ]
        
        let expectation = self.expectation(description: "no_image")
        
        imageManager.getImage(with: "fake_path") { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
