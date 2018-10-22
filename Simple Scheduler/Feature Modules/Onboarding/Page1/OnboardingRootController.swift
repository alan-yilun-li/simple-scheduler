//
//  ViewController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class OnboardingRootController: UIViewController {
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
        static let continueArrowSpacing: CGFloat = 1.0
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    private lazy var simpleLabel = makeTitleComponent(StringStore.simple)
    private lazy var schedulerLabel = makeTitleComponent(StringStore.scheduler)
    
    private lazy var continueArrow: HitTestButton = {
        let button = HitTestButton(type: .system)
        button.setTitleColor(theme.colours.mainTextColor, for: .normal)
        button.titleLabel?.font = theme.fonts.mainTitle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(">", for: .normal)
        return button
    }()
    
    private lazy var nextVC = LandingViewController(dependencies, presenter: LandingPresenter(dependencies))
    
    init(_ dependencies: AYLDependencies) {
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
        
        guard let navigationVC = navigationController as? BlankNavigationController else {
            assertionFailure("Wrong class of nav controller")
            return
        }
        navigationVC.setupTopController(forPushing: nextVC)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateContinueHitTest(forSize: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateContinueHitTest(forSize: size)
    }
}

// MARK: - Actions
extension OnboardingRootController {
    
    @objc func continueButtonPressed() {
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - View Setup
private extension OnboardingRootController {
    
    func setupViews() {
//        setupDiagonalStyle()
        view.backgroundColor = theme.colours.mainColor
        
        view.addSubview(simpleLabel)
        view.addSubview(schedulerLabel)
        view.addSubview(continueArrow)
        
        continueArrow.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    }
//
//    func setupDiagonalStyle() {
//        let diagonalLayer = CAShapeLayer()
//        let path = UIBezierPath()
//        let frame = view.frame
//        path.move(to: CGPoint(x: frame.minX, y: frame.maxY)) // Bottom left corner
//        path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY * 3/4))
//        path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
//        path.close()
//
//        diagonalLayer.path = path.cgPath
//        diagonalLayer.fillColor = UIColor.black.cgColor // theme.colours.secondaryColor.cgColor
//        diagonalLayer.strokeColor = nil
//
//        view.layer.addSublayer(diagonalLayer)
//    }
//
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Title Constraints
            simpleLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            
            simpleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            schedulerLabel.leadingAnchor.constraint(equalTo: simpleLabel.leadingAnchor),
    
            simpleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            schedulerLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            
            schedulerLabel.topAnchor.constraint(
                equalTo: simpleLabel.bottomAnchor,
                constant: Constants.defaultSpacing / 2
            ),
            schedulerLabel.bottomAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -Constants.defaultSpacing
            ),
            
            // Continue Button Constraints
            continueArrow.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.defaultSpacing * 2
            ),
            continueArrow.topAnchor.constraint(
                greaterThanOrEqualTo: schedulerLabel.bottomAnchor,
                constant: Constants.defaultSpacing
            ),
            continueArrow.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ])
    }
    
    func updateContinueHitTest(forSize size: CGSize) {
        let origin = continueArrow.convert(CGPoint.zero, to: continueArrow.superview!)
        continueArrow.hitArea = CGRect(x: -origin.x, y: -origin.y, width: size.width, height: size.height)
    }
    
    func makeTitleComponent(_ text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = theme.fonts.mainTitle
        label.textColor = theme.colours.mainTextColor
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}
