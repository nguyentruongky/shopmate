//
//  LoginInteraction.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension LoginController {
    func didLogin(user: Customer) {
        ui.loginButton.setProcess(visible: false)
        appSetting.user = user
        appSetting.token = user.token
        dismiss()
    }

    func didLoginFail(err: knError) {
        MessageHub.showError(err.message ?? "Login fail")
        ui.loginButton.setProcess(visible: false)
    }

}

extension LoginController {
    class Interactor {
        func login(email: String, password: String) {
            LoginWorker(email: email, password: password,
                          success: output?.didLogin,
                          fail: output?.didLoginFail).execute()
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = LoginController
}

extension LoginController {
    class Validation {
        var email: String?
        var password: String?
        func validate() -> (isValid: Bool, error: String?) {
            let emptyMessage = "%@ can't be empty"
            if email == nil || email?.isEmpty == true {
                return (false, String(format: emptyMessage, "Email")) }
            if password == nil || password?.isEmpty == true  {
                return (false, String(format: emptyMessage, "Password")) }

            if email?.isValidEmail() == false {
                return (false, "Invalid email or password") }

            return (true, nil)
        }
    }
}

