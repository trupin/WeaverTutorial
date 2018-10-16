//
//  AppDelegate.swift
//  Sample
//
//  Created by Théophane Rupin on 9/23/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let dependencies: AppDelegateDependencyResolver = AppDelegateDependencyContainer()
    
    // weaver: homeViewController = HomeViewController <- UIViewController
    
    // weaver: urlSession = URLSession <- URLSessionProtocol
    // weaver: urlSession.scope = .container
    // weaver: urlSession.customRef = true
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        window = UIWindow()
        
        window?.rootViewController = UINavigationController(rootViewController: dependencies.homeViewController)
        window?.makeKeyAndVisible()
    }
}

extension AppDelegateDependencyResolver {
    
    func urlSessionCustomRef() -> URLSessionProtocol {
        return URLSession(configuration: .default)
    }
}
