//
//  GetProductReviewWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct GetProductReviewWorker {
    private var api = "/products/%d/reviews"
    private var successAction: (([knReview]) -> Void)?

    init(productID: Int,
         successAction: (([knReview]) -> Void)?) {
        api = String(format: api, productID)
        self.successAction = successAction
    }

    func execute() {
        ApiConnector.get(api,
                         success: successResponse,
                         fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        guard let raw = returnData as? [AnyObject] else {
            successAction?([])
            return
        }

        let reviews = raw.map({ return knReview(raw: $0) })
        successAction?(reviews)
    }

    private func failResponse(error: knError) {
        successAction?([])
    }
}
