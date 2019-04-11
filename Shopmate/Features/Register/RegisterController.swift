//
//  RegisterController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class RegisterController: knStaticListController {
    lazy var output = Interactor(controller: self)
    let validation = Validation()
    let ui = UI()

    override func setupView() {
        title = "Join shopmate"
        let closeButton = UIBarButtonItem(image: UIImage(named: "close"),
                                          style: .done, target: self, action: #selector(close))
        hideNavBar(false)
        navigationItem.leftBarButtonItem = closeButton
        super.setupView()
        datasource = ui.setupView()
        tableView.setFooter(ui.makeFooter(), height: 200)
        tableView.setHeader(UIView(), height: gap)
        view.addSubviews(views: tableView)
        tableView.fill(toView: view)

        ui.registerButton.addTarget(self, action: #selector(register))
        ui.signinButton.addTarget(self, action: #selector(showSignin))
        ui.nameTextField.delegate = self
        ui.emailTextField.delegate = self
        ui.passwordTextField.delegate = self
    }

    @objc func register() {
        hideKeyboard()
        validation.name = ui.nameTextField.text
        validation.email = ui.emailTextField.text
        validation.password = ui.passwordTextField.text
        let (result, error) = validation.validate()
        if result == false, let error = error {
            MessageHub.showError(error)
            return
        }
        ui.registerButton.setProcess(visible: true)
        output.register(validation: validation)
    }

    @objc func showSignin() {
        hideNavBar(true)
        setControllers([LoginController()])
    }

    @objc func close() {
        dismiss()
    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isFirstNameEmpty = ui.nameTextField.text?.isEmpty == true
        let isEmailEmpty = ui.emailTextField.text?.isEmpty == true
        let isPasswordEmpty = ui.passwordTextField.text?.isEmpty == true

        if !isFirstNameEmpty && !isEmailEmpty && !isPasswordEmpty {
            register()
            return true
        }

        if textField == ui.nameTextField {
            ui.emailTextField.becomeFirstResponder()
        } else if textField == ui.emailTextField {
            ui.passwordTextField.becomeFirstResponder()
        } else if textField == ui.passwordTextField {
            register()
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        var isValid = textField.text?.isEmpty == false
        if textField == ui.emailTextField {
            isValid = textField.text?.isValidEmail() == true
        }

        if isValid {
            textField.setView(.right, image: UIImage(named: "checked") ?? UIImage())
        } else {
            textField.rightView = nil
        }
    }
}
