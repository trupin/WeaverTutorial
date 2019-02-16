/// This file is generated by Weaver 0.12.0
/// DO NOT EDIT!
// MARK: - WSReviewViewController
protocol WSReviewViewControllerInputDependencyResolver {
    var urlSession: URLSession { get }
}
@objc protocol WSReviewViewControllerDependencyResolver {
    var movieID: UInt { get }
    var reviewManager: ReviewManager { get }
}
final class WSReviewViewControllerDependencyContainer: NSObject, WSReviewViewControllerDependencyResolver {
    let movieID: UInt
    let urlSession: URLSession
    private var _reviewManager: ReviewManager?
    var reviewManager: ReviewManager {
        if let value = _reviewManager { return value }
        let dependencies = ReviewManagerDependencyContainer(injecting: self)
        let value = ReviewManager(injecting: dependencies)
        _reviewManager = value
        return value
    }
    init(injecting dependencies: WSReviewViewControllerInputDependencyResolver, movieID: UInt) {
        self.movieID = movieID
        urlSession = dependencies.urlSession
        super.init()
        _ = reviewManager
    }
}
extension WSReviewViewControllerDependencyContainer: ReviewManagerInputDependencyResolver {}
protocol WSReviewViewControllerObjCDependencyInjectable {}