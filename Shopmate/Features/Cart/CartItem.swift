//
//  CartItem.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct CartItem {
    var price: String
    var quantity = 0
    var title: String
    var color: String
    var size: String
    var url: String

    init(price: String, quantity: Int, title: String, color: String, size: String, url: String) {
        self.price = price
        self.quantity = quantity
        self.title = title
        self.color = color
        self.size = size
        self.url = url
    }
}
