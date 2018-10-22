//
//  SketchPadViewController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-21.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class SketchPadViewController: UIViewController {
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
        
        static let buttonBorderWidth: CGFloat = 3.5
        static let buttonLineHeightPercentage: CGFloat = 2.0
        static let buttonWidthProportion: CGFloat = 0.75
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    init(dependencies: AYLDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple 
    }
}
