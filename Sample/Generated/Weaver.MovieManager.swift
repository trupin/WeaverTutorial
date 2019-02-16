/// This file is generated by Weaver 0.12.0
/// DO NOT EDIT!
import Foundation
// MARK: - MovieManager
protocol MovieManagerInputDependencyResolver {
    var urlSession: URLSessionProtocol { get }
}
protocol MovieManagerDependencyResolver {
    var urlSession: URLSessionProtocol { get }
}
final class MovieManagerDependencyContainer: MovieManagerDependencyResolver {
    let urlSession: URLSessionProtocol
    init(injecting dependencies: MovieManagerInputDependencyResolver) {
        urlSession = dependencies.urlSession
    }
}