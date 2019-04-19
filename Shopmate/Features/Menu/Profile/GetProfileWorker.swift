//
//  GetProfileWorker.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation

struct GetProfileWorker {
    private let api = "/customer"
    private var successAction: ((Customer) -> Void)?
    private var failAction: ((knError) -> Void)?
    init(successAction: ((Customer) -> Void)?,
         failAction: ((knError) -> Void)?) {
        self.successAction = successAction
        self.failAction = failAction
    }

    func execute() {
        guard let _ = appSetting.token else { return }
        ApiConnector.get(api,
                         success: successResponse,
                         fail: failResponse)
    }

    private func successResponse(returnData: AnyObject) {
        let account = Customer(raw: returnData)
        successAction?(account)
    }

    private func failResponse(error: knError) {
        failAction?(error)
    }
}
