//
//  AddressUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension AddressController {
    class UI: NSObject {
        var updatePass: (() -> Void)?

        lazy var addressTextField = makeTextField(placeholder: "Your address")

        let saveButton = UIMaker.makeMainButton(title: "Save")

        func makeTextField(placeholder: String) -> UITextField {
            let tf = Common.makeTextField(placeholder: placeholder,
                                           icon: UIImage(named: ""))
            tf.returnKeyType = .done
            return tf
        }

        func setupView() -> [knTableCell] {
            addressTextField.returnKeyType = .next
            return [
                makeCell(tf: addressTextField)
            ]
        }

        func makeCell(tf: UITextField) -> knTableCell {
            let cell = knTableCell()
            cell.addSubviews(views: tf)
            tf.fill(toView: cell, space: UIEdgeInsets(top: gap, left: gap, bottom: 16, right: gap))
            tf.height(50)
            return cell
        }
    }
}
