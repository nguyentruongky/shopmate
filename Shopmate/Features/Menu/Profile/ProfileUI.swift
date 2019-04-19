//
//  ProfileUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension ProfileController {
    class UI: NSObject {
        let nameTextField = Common.makeTextField(placeholder: "Name",
                                                 icon: UIImage(named: "profile"))
        let phoneTextField = Common.makeTextField(placeholder: "Phone number",
                                                 icon: UIImage(named: "phone"))
        let emailTextField = Common.makeTextField(placeholder: "Email",
                                                   icon: UIImage(named: "email"))

        let saveButton = UIMaker.makeMainButton(title: "Save")

        func setupView() -> [knTableCell] {
            nameTextField.autocapitalizationType = .words
            nameTextField.returnKeyType = .next

            emailTextField.keyboardType = .emailAddress
            emailTextField.autocapitalizationType = .none
            emailTextField.returnKeyType = .done

            return [
                makeCell(tf: nameTextField),
                makeCell(tf: phoneTextField),
                makeCell(tf: emailTextField)
            ]
        }

        func makeCell(tf: UITextField) -> knTableCell {
            let cell = knTableCell()
            cell.addSubviews(views: tf)
            tf.fill(toView: cell, space: UIEdgeInsets(left: gap, bottom: 16, right: gap))
            tf.height(50)
            return cell
        }
    }
}
