//
//  LoginController.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class LoginController: knStaticListController {
    let ui = UI()
    lazy var output = Interactor(controller: self)
    var validation = Validation()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar(true)
    }

    override func setupView() {
        title = "Login"
        tableView.setHeader(ui.makeHeader(), height: screenHeight / 2)

        super.setupView()
        view.addSubviews(views: tableView)
        tableView.fillSuperView(space: UIEdgeInsets(top: -44))
        datasource = ui.setupView()

        ui.registerButton.addTarget(self, action: #selector(showRegister))
        ui.forgotButton.addTarget(self, action: #selector(showForgot))
        ui.closeButton.addTarget(self, action: #selector(dismissScreen))
        ui.loginButton.addTarget(self, action: #selector(login))

        ui.emailTextField.delegate = self
        ui.passwordTextField.delegate = self
    }

    @objc func dismissScreen() {
        dismiss()
    }

    @objc func showRegister(){
        setControllers([RegisterController()])
    }

    @objc func showForgot(){
        MessageHub.presentMessage("Forgot password is coming")
    }

    @objc func login() {
        hideKeyboard()
        validation.email = ui.emailTextField.text
        validation.password = ui.passwordTextField.text
        let (valid, message) = validation.validate()
        if valid == false, let message = message {
            MessageHub.showError(message)
            return
        }

        ui.loginButton.setProcess(visible: true)
        output.login(email: validation.email!, password: validation.password!)
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isScrollEnabled = false
        let bottomOffset = CGPoint(x: 0, y: 300)
        tableView.setContentOffset(bottomOffset, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ui.emailTextField {
            ui.passwordTextField.becomeFirstResponder()
        } else {
            login()
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isScrollEnabled = true
        tableView.setContentOffset(CGPoint(x: 0, y: -44), animated: true)
        if textField == ui.emailTextField {
            if ui.emailTextField.text?.isValidEmail() == true {
                textField.setView(.right, image: UIImage(named: "checked") ?? UIImage())
            } else {
                textField.rightView = nil
            }
        }
    }
}
