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
        static let body: CGFloat = 16
    }
    
    var mainColor: UIColor {
        switch self {
        case .standard: return Colours.aylWhite
        }
    }
    
    var mainTextColor: UIColor {
        switch self {
        case .standard: return Colours.aylBlack
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .standard: return Colours.aylBlack
        }
    }
    
    var mainTitleFont: UIFont {
        switch self {
        case .standard: return Fonts.getDynamicFont(withName: Fonts.standardFontName, size: FontSize.big)
        }
    }
}


private struct Colours {
    static let aylWhite = UIColor.white
    static let aylBlack = UIColor.black
}

private struct Fonts {

    static let standardFontName = "Futura-Medium"

    /// Returns font vended through UIFontMetrics.
    /// - Note: Requires the control to set adjustsFontForContentSizeCategory to enable dynamism
    static func getDynamicFont(withName name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            assertionFailure("\(name) font not loaded")
            return UIFontMetrics.default.scaledFont(
                for: UIFont.systemFont(ofSize: UIFont.labelFontSize))
        }
        return UIFontMetrics.default.scaledFont(for: font)
    }
}


