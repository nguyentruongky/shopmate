//
//  RegisterWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//


import Foundation
struct RegisterWorker {
    private let api = "/customers"
    var name: String
    var email: String
    var password: String
    var success: ((Customer) -> Void)?
    var fail: ((knError) -> Void)?

    init(name: String,
         email: String, password: String,
         success: ((Customer) -> Void)?,
         fail: ((knError) -> Void)?) {
        self.name = name
        self.email = email
        self.password = password
        self.fail = fail
        self.success = success
    }

    func execute() {
        let params = [
            "name": name,
            "email": email,
            "password": password
        ]
        let finalApi = appSetting.baseURL + api
        ApiConnector.post(finalApi, params: params,
                              success: successResponse,
                              fail: failResponse)
    }

    func successResponse(returnData: AnyObject) {
        guard let raw = returnData["customer"] as AnyObject? else {
            let err = knError(code: "no_data", message: "No user data returned")
            failResponse(err: err)
            return
        }

        let user = Customer(raw: raw)
        user.token = returnData["accessToken"] as? String
        success?(user)
    }

    func failResponse(err: knError) {
        var newErr = err
        if err.code == "409" {
            newErr.message = "Your email is registered. Please try another one"
        }
        fail?(newErr)
    }
}

