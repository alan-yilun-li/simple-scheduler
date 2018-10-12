//
//  TestViewContorller.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let textView = UITextView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UIButton(type: .system)
        label.setTitle("back", for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .purple
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.widthAnchor.constraint(equalToConstant: 300),
            textView.heightAnchor.constraint(equalToConstant: 80),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        label.addTarget(self, action: #selector(pop), for: .touchUpInside)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false

        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        
    }
    
    @objc func pop() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
