//
//  AddToCartWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

class AddToCartWorker {
    private let api = "/shoppingcart/add"
    private var cartID: String?
    private var productID: Int
    private var attributes: String
    private var success: (() -> Void)?
    private var fail: ((knError) -> Void)?

    init(productID: Int,
         size: String,
         color: String,
         success: (() -> Void)?,
         fail: ((knError) -> Void)?) {
        self.productID = productID
        attributes = color + ", " + size
        self.fail = fail
        self.success = success
    }

    func execute() {
        func addToCart(cart: String) {
            let params = [
                "cart_id": cart,
                "product_id": productID,
                "attributes": self.attributes
                ] as [String: Any]
            ApiConnector.post(api, params: params,
                              success: successResponse,
                              fail: failResponse)
        }
        if let cartID = appSetting.cartID {
            self.cartID = cartID
            addToCart(cart: cartID)
        } else {
            CreateCartWorker(successAction: { cartID in
                appSetting.cartID = cartID
                addToCart(cart: cartID)
            }).execute()
        }
    }



    func successResponse(returnData: AnyObject) {
        print(returnData)
    }

    func failResponse(err: knError) {
        fail?(err)
    }
}

