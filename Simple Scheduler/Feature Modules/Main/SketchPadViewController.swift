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
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    var isSketching: Bool = false
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.small
        label.textColor = theme.colours.mainTextColor
        label.text = "🖍️ Sketch Pad"
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = theme.fonts.small
        textView.textColor = theme.colours.userEnteredText
        textView.tintColor = theme.colours.secondaryColor
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .vertical)
        return textView
    }()
    
    init(dependencies: AYLDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = theme.colours.mainColor
        view.layer.masksToBounds = false

        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        
        setupViews()
        setupConstraints()
    }
}

// MARK: - View Setup
private extension SketchPadViewController {
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(textView)
    }
    
    func setupConstraints() {
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.defaultSpacing)
        topConstraint.priority = .required

        let constraints = [
            topConstraint,
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.defaultSpacing / 2),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.defaultSpacing),
        ]
        constraints.forEach { $0.priority = .defaultLow }
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UITextView Delegate
extension SketchPadViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isSketching = true
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        isSketching = false
        return true 
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
}
