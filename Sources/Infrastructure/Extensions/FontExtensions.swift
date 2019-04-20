//
//  FontExtensions.swift
//  Movies
//
//  Created by Javier Dominguez on 20/04/2019.
//  Copyright © 2019 Javier Dominguez. All rights reserved.
//

import UIKit

typealias Font = UIFont

extension UIFont {
    
    // MARK: - Private
    //Font Sizes
    internal struct Size {
        
        static let tiny: CGFloat = 10.0
        static let verySmall: CGFloat = 14.0
        static let small: CGFloat = 16.0
        static let medium: CGFloat = 20.0
        static let big: CGFloat = 22.0
        static let giant: CGFloat = 25.0
    }
    
    //Font Names
    internal struct Name {
        
        static let MoviesFontLight = "OpenSans-Light"
        static let MoviesFont = "OpenSans"
        static let MoviesFontBold = "OpenSans-Bold"
    }
    
    internal static func makeFontWithName(_ name: String, size: CGFloat) -> UIFont {
        
        guard let customFont =  UIFont(name: name, size: size) else {
            
            return UIFont.systemFont(ofSize: size)
        }
        
        return customFont
    }
    
    // MARK: - Public
    
    enum System {
        
        static let tiny = UIFont.systemFont(ofSize: CGFloat(Size.tiny))
        static let small = UIFont.systemFont(ofSize: CGFloat(Size.small))
        static let medium = UIFont.systemFont(ofSize: CGFloat(Size.medium))
        static let big = UIFont.systemFont(ofSize: CGFloat(Size.big))
        static let giant = UIFont.systemFont(ofSize: CGFloat(Size.giant))
    }
    
    enum SystemBold {
        
        static let tiny = UIFont.boldSystemFont(ofSize: CGFloat(Size.tiny))
        static let small = UIFont.boldSystemFont(ofSize: CGFloat(Size.small))
        static let medium = UIFont.boldSystemFont(ofSize: CGFloat(Size.medium))
        static let big = UIFont.boldSystemFont(ofSize: CGFloat(Size.big))
        static let giant = UIFont.boldSystemFont(ofSize: CGFloat(Size.giant))
    }
    
    enum Movies {
        
        static let tiny = Font.makeFontWithName(Name.MoviesFont, size: Size.tiny)
        static let verySmall = Font.makeFontWithName(Name.MoviesFont, size: Size.verySmall)
        static let small = Font.makeFontWithName(Name.MoviesFont, size: Size.small)
        static let medium = Font.makeFontWithName(Name.MoviesFont, size: Size.medium)
        static let big = Font.makeFontWithName(Name.MoviesFont, size: Size.big)
        static let giant = Font.makeFontWithName(Name.MoviesFont, size: Size.giant)
    }
    
    enum MoviesLight {
        
        static let tiny = Font.makeFontWithName(Name.MoviesFontLight, size: Size.tiny)
        static let verySmall = Font.makeFontWithName(Name.MoviesFontLight, size: Size.verySmall)
        static let small = Font.makeFontWithName(Name.MoviesFontLight, size: Size.small)
        static let medium = Font.makeFontWithName(Name.MoviesFontLight, size: Size.medium)
        static let big = Font.makeFontWithName(Name.MoviesFontLight, size: Size.big)
        static let giant = Font.makeFontWithName(Name.MoviesFontLight, size: Size.giant)
    }
    
    enum MoviesBold {
        
        static let tiny = Font.makeFontWithName(Name.MoviesFontBold, size: Size.tiny)
        static let verySmall = Font.makeFontWithName(Name.MoviesFontBold, size: Size.verySmall)
        static let small = Font.makeFontWithName(Name.MoviesFontBold, size: Size.small)
        static let medium = Font.makeFontWithName(Name.MoviesFontBold, size: Size.medium)
        static let big = Font.makeFontWithName(Name.MoviesFontBold, size: Size.big)
        static let giant = Font.makeFontWithName(Name.MoviesFontBold, size: Size.giant)
    }
    
    static func MoviesFontWithSize(size: Double) -> UIFont {
        
        guard let font = UIFont(name: Name.MoviesFont, size: CGFloat(size)) else {
            
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
        
        return font
    }
    
    static func MoviesFontLightWithSize(size: Double) -> UIFont {
        
        guard let font = UIFont(name: Name.MoviesFontLight, size: CGFloat(size)) else {
            
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
        
        return font
    }
    
    static func MoviesFontBoldWithSize(size: Double) -> UIFont {
        
        guard let font = UIFont(name: Name.MoviesFontBold, size: CGFloat(size)) else {
            
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
        
        return font
    }
}
