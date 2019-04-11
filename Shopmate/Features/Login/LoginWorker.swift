//
//  LoginWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class smUser {
    var email: String?
    var token: String?
    var name: String?
    var firstName: String?
    var lastName: String?
    var userId: Int?
    var avatar: String?
    var cover: String?
    var phone: String?
//    var billingAddress: snAddress?
//    var shippingAddress: snAddress?

    init(raw: AnyObject) {
        email = raw["email"] as? String
        firstName = raw["first_name"] as? String
        lastName = raw["last_name"] as? String
        name = firstName.or("") + " " + lastName.or("")
        userId = raw["id"] as? Int

        phone = raw["phone"] as? String
//        billingAddress = snAddress(billingRaw: raw)
//        shippingAddress = snAddress(shippingRaw: raw)
        cover = raw["phone"] as? String

        let defaulCover = "https://images.unsplash.com/photo-1503513883989-25ef8b2f1a53?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=36eaafb958cd6787048415f4096b646f&auto=format&fit=crop&w=1700&q=80"
        cover = cover ?? defaulCover

        let defaultAvatar = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSV_ExqGjttR39hREvayDTIQarycXsSoGwFltGGT9_j6CfYmNPL"
        avatar = raw["photo"] as? String ?? defaultAvatar
    }
}

struct LoginWorker {
    private let api = "/users/login/"
    var email: String
    var password: String
    var success: ((smUser) -> Void)?
    var fail: ((knError) -> Void)?

    init(email: String, password: String,
         success: ((smUser) -> Void)?,
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

        guard let raw = returnData["user"] as? AnyObject else {
            let err = knError(code: "no_data", message: "No user data returned")
            failResponse(err: err)
            return
        }
        let user = smUser(raw: raw)
        user.token = returnData["token"] as? String
        success?(user)
    }

    private func failResponse(err: knError) {
        fail?(err)
    }
}
