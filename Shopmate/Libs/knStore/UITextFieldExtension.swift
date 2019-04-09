//
//  UITextField.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/27/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension UITextField {
    enum ViewType {
        case left, right
    }
    
    @discardableResult
    func setView(_ view: ViewType, space: CGFloat) -> UIView {
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: 1))
        setView(view, with: spaceView)
        return spaceView
    }
    
    func setView(_ type: ViewType, with view: UIView) {
        if type == ViewType.left {
            leftView = view
            leftViewMode = .always
        } else if type == .right {
            rightView = view
            rightViewMode = .always
        }
    }
    
    @discardableResult
    func setView(_ view: ViewType, title: String) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        button.setTitle(title, for: UIControl.State())
        button.sizeToFit()
        setView(view, with: button)
        return button
    }
    
    @discardableResult
    func setView(_ view: ViewType, image: UIImage?) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        button.setImage(image, for: UIControl.State())
        button.imageView!.contentMode = UIView.ContentMode.scaleAspectFit
        setView(view, with: button)
        return button
    }
    
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = placeholder else { return }
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: attributes)
    }
    
    func toggleSecure() {
        isSecureTextEntry = !isSecureTextEntry
    }
    
    func selectAllText() {
        selectedTextRange = textRange(from: beginningOfDocument, to: endOfDocument)
    }
}
