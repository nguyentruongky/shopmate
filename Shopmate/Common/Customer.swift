//
//  Customer.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

class Address {
    var address1: String?
    var address2: String?
    var city: String?
    var region: String?
    var postalCode: String?
    var country: String?
    var shippingRegionId: Int?

    init() {}
    init(raw: AnyObject) {
        address1 = raw["address_1"] as? String
        address2 = raw["address_2"] as? String
        city = raw["city"] as? String
        region = raw["region"] as? String
        postalCode = raw["postal_code"] as? String
        country = raw["country"] as? String
        shippingRegionId = raw["shipping_region_id"] as? Int
    }
}

class Customer {
    var email: String?
    var token: String?
    var name: String?
    var customerID: Int
    var phone: String?
    var address: Address?

    init() {
        customerID = 0
    }

    init(raw: AnyObject) {
        email = raw["email"] as? String
        name = raw["name"] as? String
        customerID = raw["customer_id"] as? Int ?? 0
        phone = raw["mob_phone"] as? String
        address = Address(raw: raw)
    }
}
