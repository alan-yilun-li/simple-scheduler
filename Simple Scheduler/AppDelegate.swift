
//  AppDelegate.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let dependencies = AYLDependencies()
        
        if UserDefaults.standard.userShouldOnboard {
            let rootViewController = OnboardingRootController(dependencies)
            let navController = BlankNavigationController(rootViewController: rootViewController)
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        } else {
            
        }
        return true
    }
}

