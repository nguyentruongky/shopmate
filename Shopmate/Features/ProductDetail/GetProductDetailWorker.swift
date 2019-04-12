//
//  GetProductDetailWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct GetProductDetailWorker {
    private var api = "/products/"
    private var successAction: ((Product) -> Void)?
    private var failAction: ((knError) -> Void)?

    init(productID: Int,
         successAction: ((Product) -> Void)?,
         failAction: ((knError) -> Void)?) {
        api += String(productID)
        self.successAction = successAction
        self.failAction = failAction
    }

    func execute() {
        ApiConnector.get(api,
                         success: successResponse,
                         fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        let product = Product(raw: returnData)
        successAction?(product)
    }

    private func failResponse(error: knError) {
        failAction?(error)
    }
}
