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
    
    // weaver: urlSession = URLSession
    // weaver: urlSession.scope = .container
    // weaver: urlSession.customRef = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        window?.rootViewController = UINavigationController(rootViewController: dependencies.homeViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegateDependencyResolver {
    
    func urlSessionCustomRef() -> URLSession {
        return URLSession(configuration: .default)
    }
}
