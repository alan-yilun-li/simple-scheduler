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
    
    var colours: Colours { return Colours(self) }
    var fonts: Fonts { return Fonts(self) }
}

struct Colours {
    static let aylWhite = UIColor.white
    static let aylBlack = UIColor.black
    static let aylGrey = UIColor.darkGray
    
    let theme: AYLTheme
    
    fileprivate init(_ theme: AYLTheme) {
        self.theme = theme
    }
    
    var mainColor: UIColor {
        switch theme {
        case .standard: return Colours.aylWhite
        }
    }
    
    var mainTextColor: UIColor {
        switch theme {
        case .standard: return Colours.aylBlack
        }
    }
    
    var mainGrey: UIColor {
        return Colours.aylGrey
    }
    
    var secondaryColor: UIColor {
        switch theme {
        case .standard: return Colours.aylBlack
        }
    }
}

struct Fonts {
    
    private struct FontSize {
        static let big: CGFloat = 36
        static let standard: CGFloat = 24
        static let small: CGFloat = 17
    }
    
    private struct FontNames {
        static let standardFont = "Futura-Medium"
        static let italicizedStandardFontName = "Futura-MediumItalic"
    }
    
    let theme: AYLTheme
    
    fileprivate init(_ theme: AYLTheme) {
        self.theme = theme
    }
    
    var mainTitle: UIFont {
        switch theme {
        case .standard: return getDynamicFont(withName: FontNames.standardFont, size: FontSize.big)
        }
    }
    
    var standard: UIFont {
        switch theme {
        case .standard: return getDynamicFont(withName: FontNames.standardFont, size: FontSize.standard)
        }
    }
    
    var small: UIFont {
        switch theme {
        case .standard: return getDynamicFont(withName: FontNames.standardFont, size: FontSize.small)
        }
    }
    
    var smallItalicized: UIFont {
        switch theme {
        case .standard: return getDynamicFont(withName: FontNames.italicizedStandardFontName, size: FontSize.small)
        }
    }

    /// Returns font vended through UIFontMetrics.
    /// - Note: Requires the control to set adjustsFontForContentSizeCategory to enable dynamism
    private func getDynamicFont(withName name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            assertionFailure("\(name) font not loaded")
            return UIFontMetrics.default.scaledFont(
                for: UIFont.systemFont(ofSize: UIFont.labelFontSize))
        }
        return UIFontMetrics.default.scaledFont(for: font)
    }
}


