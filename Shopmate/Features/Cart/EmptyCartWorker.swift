//
//  EmptyCartWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/13/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct EmptyCartWorker {
    private var api = "/shoppingcart/empty/"
    private var successAction: (() -> Void)?
    private var cartID: String

    init(cartID: String, successAction: (() -> Void)?) {
        api += cartID
        self.cartID = cartID
        self.successAction = successAction
    }

    func execute() {
        let params = [
            "cart_id": cartID
        ]
        ApiConnector.delete(api,
                         params: params,
                         success: successResponse,
                         fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let _ = returnData as? [AnyObject] else { return }
        successAction?()
    }

    private func failResponse(error: knError) {
        print(error)
    }
}
