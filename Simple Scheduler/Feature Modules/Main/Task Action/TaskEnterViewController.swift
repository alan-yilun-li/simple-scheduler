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
//        static let firstTimeCongratulationString = "Task Entered! `Get Task` to retrieve it later"
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
        path.move(to: CGPoint(x: 0, y: checkBoxView.frame.height * 2 / 3))
        path.addLine(to: CGPoint(x: checkBoxView.frame.width / 3, y: checkBoxView.frame.height))
        path.addLine(to: CGPoint(x: checkBoxView.frame.width, y: 0))

        let layer = CAShapeLayer()
        layer.frame = checkBoxView.bounds
        layer.path = path.cgPath
        layer.strokeColor = theme.colours.secondaryColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 2.0
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
        return label
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let key = "strokeEnd"

        let pathAnimation = CABasicAnimation(keyPath:key)
        pathAnimation.duration = 1.0
        pathAnimation.fromValue = NSNumber(floatLiteral: 0)
        pathAnimation.toValue = NSNumber(floatLiteral: 1)

        checkBoxView.layer.addSublayer(checkboxPathLayer)
        checkboxPathLayer.strokeEnd = 1.0
        checkboxPathLayer.removeAllAnimations()
        checkboxPathLayer.add(pathAnimation, forKey: key)
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
}

// MARK: - View Setup
private extension TaskEnterViewController {

    func setupViews() {
        view.backgroundColor = theme.colours.mainGrey
        view.layer.cornerRadius = 20

        view.addSubview(descriptionLabel)
        view.addSubview(checkBoxView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkBoxView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.defaultSpacing / 2),
            checkBoxView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            checkBoxView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            checkBoxView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -Constants.defaultSpacing / 2),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
