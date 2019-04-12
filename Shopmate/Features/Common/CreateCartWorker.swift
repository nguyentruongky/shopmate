//
//  CreateCartWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct CreateCartWorker {
    private var api = "/shoppingcart/generateUniqueId"
    private var successAction: ((String) -> Void)?

    init(successAction: ((String) -> Void)?) {
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api,
                         success: successResponse,
                         fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let id = returnData["cart_id"] as? String else { return }
        successAction?(id)
        appSetting.cartID = id
    }

    private func failResponse(error: knError) {
        print(error)
    }
}
