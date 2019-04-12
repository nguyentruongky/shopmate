//
//  UpdateCartWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct UpdateCartWorker {
    private let api = "/shoppingcart/update/"
    private var itemID: Int
    private var quantity: Int
    private var fail: ((knError) -> Void)?

    init(itemID: Int,
         quantity: Int,
         fail: ((knError) -> Void)?) {
        self.itemID = itemID
        self.quantity = quantity
        self.fail = fail
    }

    func execute() {
        let params = [
            "item_id": itemID,
            "quantity": quantity
        ]
        let finalApi = api + String(itemID)
        ApiConnector.put(finalApi, params: params,
                          success: successResponse,
                          fail: failResponse)
    }

    func successResponse(returnData: AnyObject) {

    }

    func failResponse(err: knError) {
        fail?(err)
    }
}

