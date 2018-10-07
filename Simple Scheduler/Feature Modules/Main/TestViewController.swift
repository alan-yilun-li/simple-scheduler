//
//  TestViewContorller.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UIButton(type: .system)
        label.setTitle("back", for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        label.addTarget(self, action: #selector(pop), for: .touchUpInside)
        view.backgroundColor = .white
    }
    
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
}
