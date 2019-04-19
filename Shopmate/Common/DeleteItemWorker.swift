//
//  DeleteItemWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct DeleteItemWorker {
    private var api = "/shoppingcart/removeProduct/"
    private var itemID: Int
    private var fail: ((knError) -> Void)?

    init(itemID: Int,
         fail: ((knError) -> Void)?) {
        self.itemID = itemID
        self.fail = fail
    }

    func execute() {
        let params = [
            "item_id": itemID,
        ]
        let finalApi = api + String(itemID)
        ApiConnector.delete(finalApi, params: params,
                         success: successResponse,
                         fail: failResponse)
    }

    func successResponse(returnData: AnyObject) {

    }

    func failResponse(err: knError) {
        fail?(err)
    }
}

