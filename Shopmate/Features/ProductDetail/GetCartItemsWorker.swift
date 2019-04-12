//
//  CountCartItemWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct GetCartItemsWorker {
    private var api = "/shoppingcart/"
    private var successAction: (([CartItem]) -> Void)?

    init(successAction: (([CartItem]) -> Void)?) {
        self.successAction = successAction
        guard let id = appSetting.cartID else { return }
        api += id
    }

    func execute() {
        guard appSetting.didLogin else { return }
        ApiConnector.get(api, success: successResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let raw = returnData as? [AnyObject] else {
            successAction?([])
            return
        }
        let items = raw.map({ return CartItem(raw: $0) })
        successAction?(items)
    }
}

