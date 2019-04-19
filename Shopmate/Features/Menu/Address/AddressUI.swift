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
        lazy var addressTextField = makeTextField(placeholder: "Number, Street")
        lazy var cityTextField = makeTextField(placeholder: "City")
        lazy var regionTextField = makeTextField(placeholder: "Region")
        lazy var zipTextField = makeTextField(placeholder: "Postal code")
        lazy var countryTextField = makeTextField(placeholder: "Country")
        let saveButton = UIMaker.makeMainButton(title: "Save")
        let regionButton = UIMaker.makeButton()

        var picker: knPickerView!
        func makePicker(datasource: [Region]) {
            let types = datasource.compactMap({ return $0.shipping_region })
            picker = knPickerView.make(texts: types)
        }

        func makeTextField(placeholder: String) -> UITextField {
            let tf = Common.makeTextField(placeholder: placeholder,
                                           icon: UIImage(named: ""))
            tf.returnKeyType = .done
            return tf
        }

        func setupView() -> [knTableCell] {
            addressTextField.autocapitalizationType = .words
            addressTextField.returnKeyType = .next

            cityTextField.returnKeyType = .next
            cityTextField.autocapitalizationType = .words

            countryTextField.returnKeyType = .next
            countryTextField.autocapitalizationType = .words

            zipTextField.returnKeyType = .next
            zipTextField.keyboardType = .numberPad

            regionTextField.addFill(regionButton)

            return [
                makeCell(tf: addressTextField),
                makeCell(tf: cityTextField),
                makeCell(tf: zipTextField),
                makeCell(tf: countryTextField),
                makeCell(tf: regionTextField),
            ]
        }

        func makeCell(tf: UITextField) -> knTableCell {
            let cell = knTableCell()
            cell.addSubviews(views: tf)
            tf.fill(toView: cell, space: UIEdgeInsets(top: gap, left: gap, right: gap))
            tf.height(50)
            return cell
        }
    }
}
