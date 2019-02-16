/// This file is generated by Weaver 0.12.0
/// DO NOT EDIT!
import Foundation
import UIKit
// MARK: - ImageManager
protocol ImageManagerInputDependencyResolver {
    var urlSession: URLSessionProtocol { get }
}
protocol ImageManagerDependencyResolver {
    var urlSession: URLSessionProtocol { get }
}
final class ImageManagerDependencyContainer: ImageManagerDependencyResolver {
    let urlSession: URLSessionProtocol
    init(injecting dependencies: ImageManagerInputDependencyResolver) {
        urlSession = dependencies.urlSession
    }
}