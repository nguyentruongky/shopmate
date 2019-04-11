//
//  knFont.swift
//  knCollection
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

extension UIFont {
    enum knWeight: String {
        case light = "Montserrat-Light"
        case medium = "Montserrat-Medium"
        case semibold = "Montserrat-SemiBold"
        case regular = "Montserrat-Regular"
        case bold = "Montserrat-ExtraBold"
    }

    static func main(_ weight: knWeight = .regular, size: CGFloat = 15) -> UIFont {
        return font(weight.rawValue, size: size)
    }
    
    static func font(_ name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else { return UIFont.boldSystemFont(ofSize: size) }
        return font
    }
}

