//
//  GetTotalAmountWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/13/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct GetTotalAmountWorker {
    private var api = "/shoppingcart/totalAmount/"
    private var successAction: ((Double) -> Void)?
    private var failAction: ((knError) -> Void)?
    private var cartID: String?
    init(successAction: ((Double) -> Void)?,
         failAction: ((knError) -> Void)?) {
        guard let cartID = appSetting.cartID else { return }
        api += String(cartID)
        self.cartID = cartID
        self.successAction = successAction
        self.failAction = failAction
    }

    func execute() {
        guard let cartID = cartID else { return }
        ApiConnector.get(api,
                         params: ["cart_id": cartID],
                         success: successResponse,
                         fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let total = returnData["total_amount"] as? String else {
            successAction?(0)
            return
        }
        let amount = Double(total) ?? 0
        successAction?(amount)
    }

    private func failResponse(error: knError) {
        failAction?(error)
    }
}
