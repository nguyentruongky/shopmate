//
//  AddCardController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class AddCardController: knStaticListController {
    let ui = UI()
    let cardHandler = knCardNumberHandler()
    let nameHandler = knNameHandler()
    let cvvHandler = knCVVHandler()
    var expireDates = [String]()

    override func setupView() {
        navigationController?.hideBar(false)
        title = "New card"
        addBackButton()
        super.setupView()
        view.addSubviews(views: tableView)
        tableView.fill(toView: view, space: UIEdgeInsets(top: 66))
        datasource = ui.setupView()
        let color = UIColor(r: 243, g: 245, b: 248)
        tableView.backgroundColor = color
        view.backgroundColor = color

        view.addSubviews(views: ui.saveButton)
        ui.saveButton.horizontal(toView: view, space: 16)
        ui.saveButton.bottom(toView: view, space: -54)

        ui.cardNumberTextField.delegate = cardHandler
        ui.nameTextField.delegate = nameHandler
        ui.cvvTextField.delegate = cvvHandler

        let button = ui.coverExpiry()
        button.addTarget(self, action: #selector(showExpiryDatePicker))

        ui.saveButton.addTarget(self, action: #selector(addCard))
    }

    @objc func addCard() {
        guard let number = ui.cardNumberTextField.text,
            let userName = ui.nameTextField.text,
            let expiry = ui.expiryDateTextField.text,
            let cvv = ui.cvvTextField.text else { return }
        ui.saveButton.setProcess(visible: true)
        let card = Card(number: number,
                        userName: userName,
                        expiration: expiry,
                        cvc: cvv)
        stripeWrapper.createCard(card: card,
                                 successAction: didCreateCard,
                                 failAction: nil)

    }

    func didCreateCard(_ cardId: String) {
        back()
    }

    override func back() {
        pop()
    }

    @objc func showExpiryDatePicker() {
        expireDates = GetExpiryDateWorker().execute()
        ui.datePicker.delegate = self
        ui.datePicker.updateDatasource(expireDates)
        ui.datePicker.show(in: self)
    }
}

extension AddCardController: knPickerViewDelegate {
    func didSelectText(_ text: String) {
        ui.expiryDateTextField.text = text
    }
}


