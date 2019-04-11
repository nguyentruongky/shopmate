//
//  RegisterInteraction.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension RegisterController {
    func didRegister(user: Customer) {
        ui.registerButton.setProcess(visible: false)
        appSetting.user = user
        appSetting.token = user.token
        dismiss()
    }

    func didRegisterFail(_ err: knError) {
        ui.registerButton.setProcess(visible: false)
        MessageHub.showError(err.message ?? "Can't register at this time")
    }
}

extension RegisterController {
    class Interactor {
        func register(validation: Validation) {
            RegisterWorker(name: validation.name!,
                             email: validation.email!,
                             password: validation.password!,
                             success: output?.didRegister,
                             fail: output?.didRegisterFail).execute()
        }

        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = RegisterController
}

extension RegisterController {
    class Validation {
        var name: String?
        var email: String?
        var password: String?
        func validate() -> (isValid: Bool, error: String?) {
            let emptyMessage = "%@ can't be empty"
            if name == nil || name?.isEmpty == true {
                return (false, String(format: emptyMessage, "First name"))
            }
            if email == nil || email?.isEmpty == true {
                return (false, String(format: emptyMessage, "Email"))
            }
            if password == nil || password?.isEmpty == true  {
                return (false, String(format: emptyMessage, "Password"))
            }

            if email?.isValidEmail() == false {
                return (false, "Invalid email")
            }

            let passwordCheck = knPasswordValidation()
            if passwordCheck.checkCharCount(password!) == false {
                return (false, "Password has at least 6 characters")
            }

            return (true, nil)
        }
    }
}

