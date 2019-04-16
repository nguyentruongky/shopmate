//
//  SearchProductsWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct SearchProductsWorker {
    private let api = "/products/search"
    private let word: String
    private let page: Int
    private var successAction: (([Product]) -> Void)?
    private var failAction: ((knError) -> Void)?

    init(word: String,
         page: Int,
         successAction: (([Product]) -> Void)?,
         failAction: ((knError) -> Void)?) {
        self.word = word
        self.page = page
        self.successAction = successAction
        self.failAction = failAction
    }

    func execute() {
        let params = [
            "query_string": word,
            "page": page,
            "all_words": "off"
            ] as [String : Any]
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
