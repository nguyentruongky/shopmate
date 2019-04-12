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
        if let cartID = appSetting.cartID {
            self.cartID = cartID
            addToCart()
        } else {
            CreateCartWorker(successAction: { [weak self] cartID in
                self?.cartID = cartID
                self?.addToCart()
            }).execute()
        }
    }

    private func addToCart() {
        let params = [
            "cart_id": cartID!,
            "product_id": productID,
            "attributes": attributes
            ] as [String : Any]
        ApiConnector.post(api, params: params,
                          success: successResponse,
                          fail: failResponse)
    }

    func successResponse(returnData: AnyObject) {
        print(returnData)
    }

    func failResponse(err: knError) {
        fail?(err)
    }
}

