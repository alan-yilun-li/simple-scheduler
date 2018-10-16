//
//  TestViewContorller.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
        
        static let buttonBorderWidth: CGFloat = 3.0
        static let buttonLineHeightPercentage: CGFloat = 2.0
        static let buttonWidthProportion: CGFloat = 0.75
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.defaults.selectedTheme
    }
    
    // TODO ayl: remove test label
    let label = UIButton(type: .system)
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.standard
        label.textColor = theme.colours.mainTextColor
        label.text = "Time Cost"
        label.numberOfLines = 2
        
        return label
    }()

    
    private lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker(frame: .zero)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.datePickerMode = .countDownTimer
        timePicker.minuteInterval = 5
        
        return timePicker
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(StringStore.enterTask, for: .normal)
        button.setTitleColor(theme.colours.mainTextColor, for: .normal)
        button.titleLabel?.font = theme.fonts.standard
        
        button.backgroundColor = theme.colours.mainColor
        guard let lineHeight = button.titleLabel?.font.lineHeight else {
            assertionFailure("titlelabel of button doesn't exist")
            return button
        }
        let buttonHeight = lineHeight * Constants.buttonLineHeightPercentage
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        button.layer.cornerRadius = buttonHeight / 2
        button.layer.borderWidth = Constants.buttonBorderWidth
        
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        return button
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
        
        setupViews()
        setupConstraints()
    }
    
    @objc func pop() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - View Setup
private extension TestViewController {
    
    func setupViews() {
        
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true

        label.setTitle("back", for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.addSubview(acceptButton)
        view.addSubview(timePicker)
        view.addSubview(timeLabel)
        
        label.addTarget(self, action: #selector(pop), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            timeLabel.centerYAnchor.constraint(equalTo: timePicker.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            timeLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 2/5),
            timeLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1/3),
            
            timePicker.heightAnchor.constraint(equalTo: view.heightAnchor).withMultiplier(1/3),
            timePicker.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: Constants.defaultSpacing),
            timePicker.widthAnchor.constraint(equalTo: view.widthAnchor).withMultiplier(3/5),
            timePicker.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            timePicker.bottomAnchor.constraint(equalTo: acceptButton.topAnchor, constant: -Constants.defaultSpacing),
            
            acceptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -Constants.defaultSpacing),
            acceptButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acceptButton.widthAnchor.constraint(equalTo: view.widthAnchor).withMultiplier(Constants.buttonWidthProportion)
        ])
    }
}
