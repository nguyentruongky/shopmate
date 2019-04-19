//
//  1.Setting.swift
//  knCollection
//
//  Created by Ky Nguyen Coinhako on 7/3/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

var appSetting = AppSetting()
var stripeWrapper = appSetting.stripeWrapper
class AppSetting {
    private let stripePublicKey = "pk_test_0KYGBBDltDgGwzEFuDMBhV6C"
    private let stripeAuthKey = "Bearer sk_test_QkRXOoSQUde1PoJI2IQDuajq"
    private let stripeSecret = "sk_test_QkRXOoSQUde1PoJI2IQDuajq" // test key
    var stripeUserID: String? {
        get { return UserDefaults.get(key: "stripeUserID") as String? }
        set {
            stripeWrapper.userId = newValue
            UserDefaults.set(key: "stripeUserID", value: newValue)
        }
    }
    lazy var stripeWrapper = StripeWrapper(userId: stripeUserID,
                                           authKey: stripeAuthKey,
                                           secretKey: stripeSecret,
                                           publicKey: stripePublicKey)

    let baseURL = "https://mobilebackend.turing.com"
    let baseImageURL = "https://mobilebackend.turing.com/images/products/"
    var myAccount: Customer?

    var token: String? {
        get { return UserDefaults.get(key: "token") as String? }
        set {
            didLogin = newValue != nil
            UserDefaults.set(key: "token", value: newValue)
        }
    }

    var cartID: String? {
        get { return UserDefaults.get(key: "cartID") as String? }
        set {
            didLogin = newValue != nil
            UserDefaults.set(key: "cartID", value: newValue)
        }
    }

    var userEmail: String? {
        get { return UserDefaults.get(key: "userEmail") as String? ?? "nguyentruongky33@gmail.com" }
        set {
            UserDefaults.set(key: "userEmail", value: newValue)
        }
    }

    var user: Customer?


    var didLogin: Bool {
        get { return UserDefaults.get(key: "didLogin") as Bool? ?? false }
        set { UserDefaults.set(key: "didLogin", value: newValue) }
    }

    func removeUserData() {
        token = nil
        stripeUserID = nil
        cartID = nil
        userEmail = nil
        user = nil
        stripeWrapper.userId = nil
        boss?.productsController.cartButton.badge = nil
    }
}

let gap: CGFloat = 16
