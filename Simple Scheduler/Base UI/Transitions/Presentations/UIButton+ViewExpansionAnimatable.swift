//
//  UIButton+ViewExpansionAnimatable.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-10.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

extension UIButton: ViewExpansionAnimatable {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let button = UIButton(type: .system)
        button.frame = frame
        button.setTitle(currentTitle, for: .normal)
        button.layer.cornerRadius = layer.cornerRadius
        button.backgroundColor = backgroundColor
        button.layer.borderColor = layer.borderColor
        button.setTitleColor(titleColor(for: .normal), for: .normal)
        button.titleLabel?.font = titleLabel?.font
        return button
    }
}
