//
//  AYLTheme.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

enum AYLTheme: Int {
    
    case standard
    
    struct FontSize {
        static let big: CGFloat = 24
        static let body: CGFloat
    }
    
    var mainColor: UIColor {
        switch self {
        case .standard: return Colours.aylWhite
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .standard: return Colours.aylBlack
        }
    }
    
    var mainFont: UIFont {
        switch self {
        case .standard: return Fonts.standard
        }
    }
}


private struct Colours {
    static let aylWhite = UIColor.white
    static let aylBlack = UIColor.black
}

private struct Fonts {

    static let standard: UIFont = getDynamicFont(withName: "Futura-Medium")

    /// Returns font vended through UIFontMetrics.
    /// - Note: Requires the control to set adjustsFontForContentSizeCategory to enable dynamism
    private func getDynamicFont(withName name: String) -> UIFont {
        guard let font = UIFont(name: name, size: UIFont.labelFontSize) else {
            assertionFailure("\(name) font not loaded")
            return UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: UIFont.labelFontSize))
        }
        return UIFontMetrics.default.scaledFont(for: font)
    }
}


