//
//  LoginWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit


struct LoginWorker {
    private let api = "/customers/login"
    var email: String
    var password: String
    var success: ((Customer) -> Void)?
    var fail: ((knError) -> Void)?

    init(email: String, password: String,
         success: ((Customer) -> Void)?,
         fail: ((knError) -> Void)?) {
        self.email = email
        self.password = password
        self.fail = fail
        self.success = success
    }

    func execute() {
        let params = [
            "email": email,
            "password": password
        ]
        ApiConnector.post(api, params: params,
                              success: successResponse,
                              fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        if let message = returnData["detail"] as? String {
            let err = knError(code: "login_fail", message: message)
            failResponse(err: err)
            return
        }

        guard let raw = returnData["user"] as AnyObject? else {
            let err = knError(code: "no_data", message: "No user data returned")
            failResponse(err: err)
            return
        }
        let user = Customer(raw: raw)
        user.token = returnData["accessToken"] as? String
        success?(user)
    }

    private func failResponse(err: knError) {
        fail?(err)
    }
}
