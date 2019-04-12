//
//  CartItem.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct CartItem {
    var itemID = 0
    var name = ""
    var size = ""
    var color = ""
    var price = ""
    var quantity = 0
    var subtotal = ""

    init(raw: AnyObject) {
        itemID = raw["item_id"] as? Int ?? 0
        name = raw["name"] as? String ?? ""
        if let attributesRaw = raw["attributes"] as? String {
            let attributes = attributesRaw.splitString(", ")
            if attributes.count > 0 {
                color = attributes[0]
            }
            if attributes.count > 1 {
                size = attributes[1]
            }
        }
        price = raw["price"] as? String ?? "0"
        price = "$" + price
        subtotal = raw["subtotal"] as? String ?? ""
        quantity = raw["quantity"] as? Int ?? 0
    }
}
