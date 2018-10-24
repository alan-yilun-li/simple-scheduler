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
        
        static let dismissDetailString = "tap anywhere outside to dismiss"
        static let writingDetailString = "this is your space to write"
        
        static let fileName = "sketch-pad.txt"
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

    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.smallItalicized
        label.textColor = theme.colours.mainGrey.withAlphaComponent(0.8)
        label.text = Constants.writingDetailString
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private var showDescriptionLabel: Bool {
        get { return !descriptionLabelHeightConstraint.isActive }
        set { descriptionLabelHeightConstraint.isActive = !newValue }
    }
    private lazy var descriptionLabelHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = theme.fonts.small
        textView.textColor = theme.colours.userEnteredText
        textView.tintColor = theme.colours.secondaryColor
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .vertical)
        textView.text = readFromFile()
        return textView
    }()
    
    init(dependencies: AYLDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        writeToFile(textView.text)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        showDescriptionLabel = textView.text.isEmpty
        
        view.backgroundColor = theme.colours.mainColor
        view.layer.masksToBounds = false

        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillClose), name: UIApplication.willTerminateNotification, object: nil)
        
        setupViews()
        setupConstraints()
    }
    
    @objc func descriptionLabelTapped() {
        textView.becomeFirstResponder()
    }
    
    @objc func appWillClose() {
        writeToFile(textView.text)
    }
}

// MARK: - View Setup
private extension SketchPadViewController {
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(descriptionLabel)
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
            textView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -Constants.defaultSpacing / 4),

            descriptionLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.defaultSpacing / 4)
        ]
        constraints.forEach { $0.priority = .defaultLow }
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UITextView Delegate
extension SketchPadViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isSketching = true
        UIView.animate(withDuration: 0.3) {
            self.showDescriptionLabel = true
            self.view.layoutIfNeeded()
        }
        self.descriptionLabel.text = Constants.dismissDetailString
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        isSketching = false
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = nil
            self.descriptionLabel.text = Constants.writingDetailString
        } else {
            UIView.animate(withDuration: 0.3) {
                self.showDescriptionLabel = false
                self.view.layoutIfNeeded()
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
}

// MARK: - File Writing
extension SketchPadViewController {
    
    private func writeToFile(_ text: String) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = directory.appendingPathComponent(Constants.fileName)
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf32)
        } catch {
            print("failed to write")
        }
    }
    
    private func readFromFile() -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileURL = directory.appendingPathComponent(Constants.fileName)
        return try? String(contentsOf: fileURL, encoding: .utf32)
    }
}
