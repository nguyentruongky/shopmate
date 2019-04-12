//
//  UIMaker.swift
//  knCollection
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
class UIMaker {
    static func makeHorizontalLine(color: UIColor = UIColor(r: 238, g: 242, b: 246),
                                   height: CGFloat = 1) -> UIView {
        let view = makeView(background: color)
        view.height(height)
        return view
    }

    static func makeVerticalLine(color: UIColor = UIColor(r: 238, g: 242, b: 246),
                                 width: CGFloat = 1) -> UIView {
        let view = makeView(background: color)
        view.width(width)
        return view
    }

    static func makeLabel(text: String? = nil,
                          font: UIFont = .systemFont(ofSize: 15),
                          color: UIColor = .black,
                          numberOfLines: Int = 1,
                          alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        label.text = text
        label.numberOfLines = numberOfLines
        label.textAlignment = alignment
        return label
    }

    static func makeView(background: UIColor? = .clear) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = background
        return view
    }

    static func makeImageView(image: UIImage? = nil,
                              contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.clipsToBounds = true
        return iv
    }

    static func makeTextField(text: String? = nil,
                              placeholder: String? = nil,
                              font: UIFont = UIFont.main(),
                              color: UIColor = .black,
                              alignment: NSTextAlignment = .left) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = font
        tf.textColor = color
        tf.text = text
        tf.placeholder = placeholder
        tf.textAlignment = alignment
        tf.inputAccessoryView = makeKeyboardDoneView()
        return tf
    }

    static func makeButton(title: String? = nil,
                           titleColor: UIColor = .black,
                           font: UIFont? = nil,
                           background: UIColor = .clear,
                           cornerRadius: CGFloat = 0,
                           borderWidth: CGFloat = 0,
                           borderColor: UIColor = .clear) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)

        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleColor.withAlphaComponent(0.4), for: .disabled)
        button.setBackground(color: background, forState: .normal)
        button.setBackground(color: background.withAlphaComponent(0.5), forState: .disabled)

        button.titleLabel?.font = font
        button.setCorner(radius: cornerRadius)
        button.setBorder(width: borderWidth, color: borderColor)
        return button
    }

    static func makeStackView(axis: NSLayoutConstraint.Axis = .vertical,
                              distributon: UIStackView.Distribution = .equalSpacing,
                              alignment: UIStackView.Alignment = .center,
                              space: CGFloat = 16) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = distributon
        stackView.alignment = alignment
        stackView.spacing = space
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func makeButton(image: UIImage? = nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }

    static func makeMainButton(title: String,
                               bgColor: UIColor = UIColor.black,
                               titleColor: UIColor = UIColor.white,
                               font: UIFont = UIFont.main(.bold, size: 18)) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(UIColor.white.alpha(0.5), for: .disabled)
        button.setBackground(color: bgColor, forState: .normal)
        button.setBackground(color: bgColor.alpha(0.5), forState: .disabled)
        button.setCorner(radius: 7)

        button.height(56)
        return button
    }

    static func makeKeyboardDoneView(title: String = "Done", doneAction: Selector? = nil, font: UIFont = UIFont.systemFont(ofSize: 15)) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 35))
        let button = makeButton(title: title,
                                titleColor: UIColor(value: 3),
                                font: font)
        if let doneAction = doneAction {
            button.addTarget(self, action: doneAction, for: .touchUpInside)
        }
        else {
            button.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        }

        view.addSubview(button)
        button.right(toView: view, space: -30)
        button.centerY(toView: view)

        view.backgroundColor = UIColor(value: 235)
        return view
    }

    static func wrapToCell(_ view: UIView, space: UIEdgeInsets = .zero) -> knTableCell {
        let cell = knTableCell()
        cell.addSubviews(views: view)
        view.fill(toView: cell, space: space)
        return cell
    }

    static func makeEmptyCell(height: CGFloat = 16, color: UIColor = .lightGray) -> knTableCell {
        let cell = knTableCell()
        cell.height(height)
        cell.backgroundColor = color
        return cell
    }

    @objc private static func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

