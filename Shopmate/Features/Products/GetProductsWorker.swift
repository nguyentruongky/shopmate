//
//  GetProductsWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
struct GetProductsWorker {
    private let api = "/products"
    private let page: Int
    private var successAction: (([Product]) -> Void)?
    private var failAction: ((knError) -> Void)?

    init(page: Int = 1,
         successAction: (([Product]) -> Void)?,
         failAction: ((knError) -> Void)?) {
        self.page = page
        self.successAction = successAction
        self.failAction = failAction
    }

    func execute() {
        let params = [
            "page": page
        ]
        ApiConnector.get(api, params: params,
                          success: successResponse,
                          fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let raw = returnData["rows"] as? [AnyObject] else {
            successAction?([])
            return
        }

        let products = raw.map({ return Product(raw: $0) })
        successAction?(products)
    }

    private func failResponse(error: knError) {
        failAction?(error)
    }
}
