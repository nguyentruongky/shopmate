//
//  RegisterWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//


import Foundation
struct RegisterWorker {
    private let api = "/users/register/"
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var success: ((smUser) -> Void)?
    var fail: ((knError) -> Void)?

    init(firstName: String, lastName: String,
         email: String, password: String,
         success: ((smUser) -> Void)?,
         fail: ((knError) -> Void)?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.fail = fail
        self.success = success
    }

    func execute() {
        let params = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password
        ]

        ApiConnector.post(api, params: params,
                              success: successResponse,
                              fail: failResponse)
    }

    func successResponse(returnData: AnyObject) {
        guard let raw = returnData["user"] as AnyObject? else {
            let err = knError(code: "no_data", message: "No user data returned")
            failResponse(err: err)
            return
        }

        let user = smUser(raw: raw)
        user.token = returnData["token"] as? String
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

