//
//  TaskEnterViewController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 10/25/18.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class TaskEnterViewController: UIViewController {

    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
        static let congratulationStrings = ["Nice! You entered a task!",
                                            "Woohoo! Get your task back later",
                                            "Another one in the bucket",
                                            "Another plan, another fan",
                                            "And another one! You got this!"]
    }

    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }

    private lazy var checkBoxView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var checkboxPathLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: checkBoxView.frame.height * 1/2))
        path.addLine(to: CGPoint(x: checkBoxView.frame.width * 1/2, y: checkBoxView.frame.height))
        path.addLine(to: CGPoint(x: checkBoxView.frame.width, y: 2/3))

        let layer = CAShapeLayer()
        layer.frame = checkBoxView.bounds
        layer.path = path.cgPath
        layer.strokeColor = theme.colours.mainTextColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 10.0
        layer.lineJoin = .bevel

        return layer
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.congratulationStrings.randomElement()!
        label.font = theme.fonts.small
        label.textColor = theme.colours.mainTextColor
        label.textAlignment = .center
        label.layer.opacity = 0
        label.numberOfLines = 0
        return label
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let key = "strokeEnd"

        let pathAnimation = CABasicAnimation(keyPath:key)
        pathAnimation.duration = 0.2
        pathAnimation.fromValue = NSNumber(floatLiteral: 0)
        pathAnimation.toValue = NSNumber(floatLiteral: 1)

        checkBoxView.layer.addSublayer(checkboxPathLayer)
        checkboxPathLayer.strokeEnd = 1.0
        checkboxPathLayer.removeAllAnimations()
        checkboxPathLayer.add(pathAnimation, forKey: key)
        
        UIView.animate(withDuration: 0.2) {
            self.descriptionLabel.layer.opacity = 1.0
        }
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

        setupViews()
        setupConstraints()
    }
    
    @objc func viewWasPressed() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - View Setup
private extension TaskEnterViewController {

    func setupViews() {
        view.backgroundColor = .clear
        view.layer.cornerRadius = 30
        view.backgroundColor = theme.colours.mainColor
//        view.clipsToBounds = true
//
//        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
//        blurEffectView.frame = self.view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        view.addSubview(blurEffectView)
        view.addSubview(descriptionLabel)
        view.addSubview(checkBoxView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewWasPressed)))
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkBoxView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkBoxView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkBoxView.widthAnchor.constraint(equalTo: view.widthAnchor).withMultiplier(0.5),
            checkBoxView.heightAnchor.constraint(equalTo: view.heightAnchor).withMultiplier(0.5),
            checkBoxView.bottomAnchor.constraint(lessThanOrEqualTo: descriptionLabel.topAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultSpacing)
        ])
    }
}
