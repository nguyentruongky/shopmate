//
//  LoginWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class Address {
    var address1: String?
    var address2: String?
    var city: String?
    var region: String?
    var postalCode: String?
    var country: String?

    init(raw: AnyObject) {
        address1 = raw["address_1"] as? String
        address2 = raw["address_2"] as? String
        city = raw["city"] as? String
        region = raw["region"] as? String
        postalCode = raw["postal_code"] as? String
        country = raw["country"] as? String
    }
}

class Customer {
    var email: String?
    var token: String?
    var name: String?
    var customerID: Int
    var phone: String?
    var address: Address?

    init(raw: AnyObject) {
        email = raw["email"] as? String
        name = raw["name"] as? String
        customerID = raw["customer_id"] as? Int ?? 0
        phone = raw["mob_phone"] as? String
        address = Address(raw: raw)
    }
}

struct LoginWorker {
    private let api = "/users/login/"
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
        user.token = returnData["token"] as? String
        success?(user)
    }

    private func failResponse(err: knError) {
        fail?(err)
    }
}
