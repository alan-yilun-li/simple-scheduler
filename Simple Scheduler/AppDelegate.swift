
//  AppDelegate.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let dependencies = AYLDependencies()
        dependencies.theme = dependencies.defaults.selectedTheme
        
        setupContainer { container in
            dependencies.persistentContainer = container
            
        }
        
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
    
    
    func setupContainer(completion: @escaping (NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "TaskPlanning")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Failed to load store: \(error!)")
            }
            DispatchQueue.main.async { completion(container) }
        }
    }
}

