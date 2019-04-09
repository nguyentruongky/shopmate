//
//  knUISearchBar.swift
//  knCollection
//
//  Created by Ky Nguyen on 2/27/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
extension UISearchBar {
    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func setTextFieldBackground(_ color: UIColor) {
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setTextColor(_ color: UIColor) {
        let textField = value(forKey: "searchField") as? UITextField
        textField?.textColor = color
    }
}
